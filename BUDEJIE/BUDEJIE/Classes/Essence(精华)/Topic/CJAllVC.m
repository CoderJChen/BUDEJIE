//
//  CJAllVC.m
//  BUDEJIE
//
//  Created by eric on 17/1/11.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJAllVC.h"
#import "CJTopic.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "CJTopicCell.h"

@interface CJAllVC ()
@property (copy, nonatomic) NSString * maxTime;
/** 所有的帖子数据 */
@property (nonatomic, strong) NSMutableArray <CJTopic *> *topics;
@property (strong, nonatomic) AFHTTPSessionManager * manager;

@property (weak, nonatomic) UIView * footer;
@property (weak, nonatomic) UILabel * footerLabel;

@property (weak, nonatomic) UIView * header;
@property (weak, nonatomic) UILabel * headerLabel;

@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;
@property (assign, nonatomic, getter=isFooterRefreshing) BOOL footerRefreshing;

// 有了方法声明，点语法才会有智能提示
- (CJTopicType)type;
@end

static NSString * const CJTopicCellId = @"CJTopicCellId";
@implementation CJAllVC

-(AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CJRandomColor;
    self.tableView.contentInset = UIEdgeInsetsMake(CJNavMaxY + CJTitlesViewH, 0, CJTabBarH, 0);
  
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.rowHeight = 200;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CJTopicCell" bundle:nil] forCellReuseIdentifier:CJTopicCellId];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:CJTabBarButtonDidRepeatClickNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(titleButtonDidRepeatClick) name:CJTitleButtonDidRepeatClickNotification object:nil];
    
    [self setupRefresh];
}
#pragma mark - 监听
/**
 *  监听tabBarButton重复点击
 */
- (void)tabBarButtonDidRepeatClick
{
    //    if (重复点击的不是精华按钮) return;
    if (self.view.window == nil) return;
    
    //    if (显示在正中间的不是AllViewController) return;
    if (self.tableView.scrollsToTop == NO) return;
    
    [self headerBeginRefreshing];
    CJLog(@"%@ - 刷新数据", self.class);
}

/**
 *  监听titleButton重复点击
 */
- (void)titleButtonDidRepeatClick
{
    [self tabBarButtonDidRepeatClick];
}

- (void)setupRefresh{
    
    UILabel * label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor orangeColor];
    label.frame = CGRectMake(0, 0, 0, 30);
    label.text = @"广告";
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = label;
    
    UIView * header = [[UIView alloc]init];
    header.frame = CGRectMake(0, -50, self.tableView.width, 50);
    [self.tableView addSubview:header];
    _header = header;
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = header.bounds;
    headerLabel.backgroundColor = [UIColor redColor];
    headerLabel.text = @"下拉可以刷新";
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:headerLabel];
    self.headerLabel = headerLabel;
    header.hidden = YES;
//    让header自动进入刷新
    [self headerBeginRefreshing];
    
    UIView * footer = [[UIView alloc]init];
    footer.frame = CGRectMake(0, 0, self.tableView.width, 35);
    _footer = footer;
    
    UILabel * footerLabel = [[UILabel alloc]init];
    footerLabel.frame = footer.bounds;
    footerLabel.backgroundColor = [UIColor redColor];
    footerLabel.text = @"上拉可以加载更多";
    footerLabel.textColor = [UIColor whiteColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:footerLabel];
    _footerLabel = footerLabel;
    self.tableView.tableFooterView = footer;
}
- (void)headerBeginRefreshing{
    self.header.hidden = NO;
    if (self.isHeaderRefreshing) {
        return;
    }
    self.headerLabel.text = @"正在刷新数据...";
    self.headerLabel.backgroundColor = [UIColor blueColor];
    self.headerRefreshing = YES;
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top +=self.header.height;
        self.tableView.contentInset = inset;
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, -inset.top);
    }];
    [self loadNewTopic];
}
- (void)headerEndRefreshing{
    
    self.headerRefreshing = NO;
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top -= self.header.height;
        self.tableView.contentInset = inset;
    }];
    self.header.hidden = YES;
}
- (void)footerBeginRefreshing{
    if (self.isFooterRefreshing) {
        return;
    }
    self.footerRefreshing = YES;
    self.footerLabel.text = @"正在加载更多数据...";
    self.footerLabel.backgroundColor = [UIColor blueColor];
    [self loadMoreTopics];
}
- (void)footerEndRefreshing{
    self.footerRefreshing = NO;
    self.footerLabel.text = @"上拉可以加载更多";
    self.footerLabel.backgroundColor = [UIColor redColor];
}
- (CJTopicType)type{
    return CJTopicTypePicture;
}
- (void)loadNewTopic{
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type); // 这里发送@1也是可行的
    [_manager GET:CJCommonURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CJAFNWriteToPlist(new_topic);
        self.maxTime = responseObject[@"info"][@"maxtime"];
        self.topics = [CJTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.tableView reloadData];
        [self headerEndRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试!"];
        [self headerEndRefreshing];
    }];
}
- (void)loadMoreTopics{
    // 1.创建请求会话管理者
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type); // 这里发送@1也是可行的
    parameters[@"maxtime"] = self.maxTime;
    
    [_manager GET:CJCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.maxTime = responseObject[@"info"][@"maxtime"];
        NSArray * moreTopics = [CJTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:moreTopics];
        [self.tableView reloadData];
        [self footerEndRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        [self footerEndRefreshing];
    }];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    self.footer.hidden =  self.footer.hidden = (self.topics.count == 0);;
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CJTopicCell * cell = [tableView dequeueReusableCellWithIdentifier:CJTopicCellId];
    
    CJTopic * topics = self.topics[indexPath.row];
    cell.topics = topics;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CJLog(@"####%f",self.topics[indexPath.row].cellHeight);
    return self.topics[indexPath.row].cellHeight;
}
/**
 *  用户松开scrollView时调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat offsetY = -(self.tableView.contentInset.top + self.header.height);
    if (self.tableView.contentOffset.y <= offsetY) {
        [self headerBeginRefreshing];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self dealHeader];
    [self dealFooter];
}
//处理下拉刷新
- (void)dealHeader{
    if (self.isHeaderRefreshing) {
        return;
    }
    CGFloat offsetY = - (self.tableView.contentInset.top + self.header.height);
    if (self.tableView.contentOffset.y <= offsetY) {
        self.header.hidden = NO;
        self.headerLabel.text = @"松开立即刷新";
        self.headerLabel.backgroundColor = [UIColor grayColor];
    } else {
        
        self.headerLabel.text = @"下拉可以刷新";
        self.headerLabel.backgroundColor = [UIColor redColor];
    }
}
//处理上拉刷新
- (void)dealFooter{
    
    if (self.tableView.contentSize.height == 0) {
        return;
    }
    if (self.isFooterRefreshing) {
        return;
    }
    CGFloat offsetY = self.tableView.contentSize.height - self.tableView.height + self.tableView.contentInset.bottom;
    if (self.tableView.contentOffset.y >= offsetY && self.tableView.contentOffset.y > - (self.tableView.contentInset.top)) {
        [self footerBeginRefreshing];
    }

}


@end

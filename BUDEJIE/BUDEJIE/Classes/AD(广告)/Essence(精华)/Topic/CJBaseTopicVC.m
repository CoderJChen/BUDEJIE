//
//  CJBaseTopicVC.m
//  BUDEJIE
//
//  Created by eric on 17/1/13.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJBaseTopicVC.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension/MJExtension.h>
#import "CJTopicCell.h"
#import "CJCommentVC.h"
#import "CJNavigationVC.h"

@interface CJBaseTopicVC ()

@property (copy, nonatomic) NSString * maxTime;
/** 所有的帖子数据 */
@property (nonatomic, strong) NSMutableArray <CJTopic *> *topics;
@property (strong, nonatomic) AFHTTPSessionManager * manager;

@end
/* cell的重用标识 */
static NSString *const CJTopicCellId = @"CJTopicCellId";

@implementation CJBaseTopicVC
- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
/** 在这里实现type方法，仅仅是为了消除警告 */
- (CJTopicType)type{
    return 0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = CJRandomColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(CJNavMaxY + CJTitlesViewH, 0, CJTabBarH, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
//    注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"CJTopicCell" bundle:nil] forCellReuseIdentifier:CJTopicCellId];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:CJTabBarButtonDidRepeatClickNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(titleButtonDidRepeatClick) name:CJTitleButtonDidRepeatClickNotification object:nil];
    
    [self setupRefresh];
}
#pragma mark - 监听
/**
 *  监听tabBarButton重复点击
 */
- (void)tabBarButtonDidRepeatClick{
    // 重复点击的不是精华按钮
    if (self.view.window == nil) {
        return;
    }
    // 显示在正中间的不是VideoViewController
    if (self.tableView.scrollsToTop == NO) {
        return;
    }
    [self.tableView.mj_header beginRefreshing];
}
/**
 *  监听titleButton重复点击
 */
- (void)titleButtonDidRepeatClick{
    [self tabBarButtonDidRepeatClick];
}

- (void)setupRefresh{
//    广告条
    UILabel * label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor orangeColor];
    label.frame = CGRectMake(0, 0, 0, 30);
    label.text = @"广告";
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = label;
//    header
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    // 自动切换透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    
}
#pragma mark - 数据处理
/**
 *  发送请求给服务器，下拉刷新数据
 */
- (void)loadNewTopic{
//    取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
//    拼接参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type); // 这里发送@1也是可行的
//    发送请求
    [_manager GET:CJCommonURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.type == CJTopicTypeVideo) {
            CJAFNWriteToPlist(video_total);
        }
//        存储maxtime
        self.maxTime = responseObject[@"info"][@"maxtime"];
//        字典数组 -> 模型数据
        self.topics = [CJTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
//        刷新表格
        [self.tableView reloadData];
//        结束刷新
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 并非是取消任务导致的error，其他网络问题导致的error
        if (error.code != NSURLErrorCancelled) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
//        结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
    
}
- (void)loadMoreTopics{
//    1、取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
//    拼接参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type); // 这里发送@1也是可行的
    params[@"maxtime"] = self.maxTime;
//    发送请求
    [_manager GET:CJCommonURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        存储maxtime
        self.maxTime = responseObject[@"info"][@"maxtime"];
//        字典数组 -> 模型数据
        NSArray * moreTopics = [CJTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
//        累加到旧数组的后面
        [self.topics addObjectsFromArray:moreTopics];
//        刷新表格
        [self.tableView reloadData];
//        结束刷新
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) {
            // 并非是取消任务导致的error，其他网络问题导致的error
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
//        结束刷新
        [self.tableView.mj_footer endRefreshing];
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
    // 根据数据量显示或者隐藏footer
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CJTopicCell * cell = [tableView dequeueReusableCellWithIdentifier:CJTopicCellId];
    cell.topics = self.topics[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.topics[indexPath.row].cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CJCommentVC * commentVC = [[CJCommentVC alloc]init];
    commentVC.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVC animated:YES];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 清除内存缓存
    [[SDImageCache sharedImageCache]clearMemory];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

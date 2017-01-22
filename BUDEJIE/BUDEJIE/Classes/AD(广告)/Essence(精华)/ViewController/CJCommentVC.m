//
//  CJCommentVC.m
//  BUDEJIE
//
//  Created by eric on 17/1/16.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJCommentVC.h"
#import "CJTopicCell.h"
#import "CJTopic.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <MJExtension.h>
#import "CJComment.h"
#import "CJCommentCell.h"
#import "CJCommentHeaderView.h"
#import "CJUser.h"

static NSString * const CJCommentCellId = @"comment";
static NSString * const CJHeaderId = @"header";
@interface CJCommentVC ()<UITableViewDelegate,UITableViewDataSource>
/** 请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 暂时存储：最热评论 */
@property (nonatomic, strong) CJComment *topComment;
/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论（所有的评论数据） */
@property (nonatomic, strong) NSMutableArray *latestComments;
/** 写方法声明的目的是为了使用点语法提示 */
- (CJComment *)selectedComment;
@end


@implementation CJCommentVC

- (AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self setupTable];
    
    [self setupRefresh];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)setupNav{
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"comment_nav_item_share_icon"] highImage:[UIImage imageNamed:@"comment_nav_item_share_icon_click"] target:self action:@selector(commentClick)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)setupTable{
    
    self.tableView.backgroundColor = CJCommonBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CJCommentCell class]) bundle:nil] forCellReuseIdentifier:CJCommentCellId];
    
    [self.tableView registerClass:[CJCommentHeaderView class] forHeaderFooterViewReuseIdentifier:CJHeaderId];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
//    处理数据模型
    if(self.topic.topComment){
        self.topComment = self.topic.topComment;
        self.topic.topComment = nil;
        self.topic.cellHeight = 0;
    }
//    cell
    CJTopicCell * cell = [CJTopicCell CJ_ViewFromXib];
    cell.topics = self.topic;
    cell.frame = CGRectMake(0, 0, CJScreenW, self.topic.cellHeight);
//    设置header
    UIView * header = [[UIView alloc]init];
    header.height = cell.height + 2 * CJMargin;
    [header addSubview:cell];
    self.tableView.tableHeaderView = header;
}
- (void)setupRefresh{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    // 自动切换透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    
}
- (void)loadNewComments{
//    取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
//    请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @1;
    CJWeakSelf;
//    发送请求
    [self.manager GET:CJCommonURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
//            意味着没有评论数
//            结束刷新
            [weakSelf.tableView.mj_header endRefreshing];
//            返回
            return ;
        }
//        CJAFNWriteToPlist(new_comment);
//       最热评论
        weakSelf.hotComments = [CJComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
//        最新评论
        weakSelf.latestComments = [CJComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
//        刷新表格
        [weakSelf.tableView reloadData];
//        结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
//        判断评论数是否已经加载完全
        if (self.latestComments.count >= [responseObject[@"total"] intValue]) {
//           评论数已经加载完毕
            weakSelf.tableView.mj_footer.hidden = YES;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];

}
- (void)loadMoreComments{
//    取消之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
//    请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"lastcid"] = [self.latestComments.lastObject ID];
//    发送请求
    CJWeakSelf;
    [self.manager GET:CJCommonURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        CJAFNWriteToPlist(comment_more);
//        最新评论
        if (!responseObject[@"data"]) {
            return ;
        }
//        最新表格
        NSArray * newComments = [CJComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.latestComments addObjectsFromArray:newComments];
//        刷新表格
        [weakSelf.tableView reloadData];
        
        if (self.latestComments.count >= [responseObject[@"total"] intValue]) {
//           数据已经加载完毕
            weakSelf.tableView.mj_footer.hidden = YES;
        }else{
//            应该还会有下一页
//            结束刷新（恢复到普通状态，仍旧可以刷新）
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
//    工具条平移的距离 == 屏幕高度 - 键盘最终的Y值
    self.bottomSpace.constant = CJScreenH - [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
- (void)commentClick{

}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    if (self.topComment) {
        self.topic.topComment = self.topComment;
        self.topic.cellHeight = 0;
    }
}
#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    CJLog(@"%zd",self.hotComments.count);
    if (self.hotComments.count) {
        return 2;
    }
    if (self.latestComments.count) {
        return 1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 && self.hotComments.count) {
        return self.hotComments.count;
    }
    return self.latestComments.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CJCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:CJCommentCellId];
//    获得对应的评论数据
    NSArray * comments = self.latestComments;
    
    if (indexPath.section == 0 && self.hotComments.count) {
        comments = self.hotComments;
    }
//    传递模型给cell
    cell.comment = comments[indexPath.row];
    return cell;
}
#pragma mark - 
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CJCommentHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CJHeaderId];
//    覆盖文字
    if (section == 0 && self.hotComments.count) {
        header.text = @"最热评论";
    }else{
        header.text = @"最新评论";
    }
    
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取出cell
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    UIMenuController * menu = [UIMenuController sharedMenuController];
//    设置菜单内容
    menu.menuItems = @[
                       [[UIMenuItem alloc]initWithTitle:@"顶" action:@selector(ding:)],
                       [[UIMenuItem alloc]initWithTitle:@"回复" action:@selector(rely:)],
                       [[UIMenuItem alloc]initWithTitle:@"举报" action:@selector(warn:)]
                       ];
//    显示位置
    CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, 1);
    [menu setTargetRect:rect inView:cell];
//    显示出来
    [menu setMenuVisible:YES animated:YES];
    
}
#pragma mark - 获得当前选中的评论
- (CJComment *)selectedComment{
    NSIndexPath * indexPath = self.tableView.indexPathForSelectedRow;
    NSInteger row = indexPath.row;
    NSArray * comments = self.latestComments;
    if (indexPath.section == 0 && self.hotComments.count) {
        comments = self.hotComments;
    }
    return comments[row];
}
#pragma mark - UIMenuController
- (BOOL)canBecomeFirstResponder{
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (!self.isFirstResponder) {
        if (action == @selector(ding:)|| action == @selector(rely:) || action == @selector(warn:)) {
            return NO;
        }
    }
    return [super canPerformAction:action withSender:sender];
}
- (void)ding:(UIMenuController *)menu{
    CJLog(@"ding - %@ %@",
           self.selectedComment.user.username,
           self.selectedComment.content);
}
- (void)rely:(UIMenuController *)menu{
    CJLog(@"ding - %@ %@",
          self.selectedComment.user.username,
          self.selectedComment.content);
}
- (void)warn:(UIMenuController *)menu{
    CJLog(@"ding - %@ %@",
          self.selectedComment.user.username,
          self.selectedComment.content);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

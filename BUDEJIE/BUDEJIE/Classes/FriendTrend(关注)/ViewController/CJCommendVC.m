//
//  CJCommendVC.m
//  BUDEJIE
//
//  Created by eric on 17/1/17.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJCommendVC.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>
#import "CJFollowCategory.h"
#import "CJFollowUser.h"
#import "CJCategoryCell.h"
#import "CJUserCell.h"

@interface CJCommendVC ()<UITableViewDelegate,UITableViewDataSource>
/** 左边👈 ←的类别表格 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 右边👉 →的用户表格 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
/** 请求管理者 */
@property (nonatomic, weak) AFHTTPSessionManager *manager;
/** 左边👈 ←的类别数据 */
@property (nonatomic, strong) NSArray *categories;

@end
static NSString * const CJCategoryCellId = @"category";
static NSString * const CJUserCellId = @"user";

@implementation CJCommendVC
-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTable];
    [self setupRefresh];
    [self loadCategories];
}
- (void)setupTable{
    
    self.title = @"推荐关注";
    self.view.backgroundColor = CJCommonBgColor;
//    ios7之后tableView自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIEdgeInsets inset = UIEdgeInsetsMake(CJNavMaxY, 0, 0, 0);
    
    self.categoryTableView.contentInset = inset;
    self.categoryTableView.scrollIndicatorInsets = inset;
    
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CJCategoryCell class]) bundle:nil] forCellReuseIdentifier:CJCategoryCellId];
    
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.userTableView.rowHeight = 70;
    self.userTableView.contentInset = inset;
    self.userTableView.scrollIndicatorInsets = inset;
    

    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CJUserCell class]) bundle:nil] forCellReuseIdentifier:CJUserCellId];
    self.userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (void)setupRefresh{
//    下拉刷新
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
//    上拉刷新
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
}
- (void)loadCategories{
    
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
//    弹框
    [SVProgressHUD show];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
//    发送请求
    CJWeakSelf;
    [self.manager GET:CJCommonURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CJLog(@"###%@",responseObject);
//        字典数组 -> 模型数组
        weakSelf.categories = [CJFollowCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
//        刷新表格
        [weakSelf.categoryTableView reloadData];
//        选中左边的第0行
        [weakSelf.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
//        让右边表格进入下拉刷新
        [weakSelf.userTableView.mj_header beginRefreshing];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        
    }];
}
- (void)loadNewUsers{
//    取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    // 左边选中的类别的ID
    CJFollowCategory * selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
    params[@"category_id"] = selectedCategory.ID;
//    发送请求
    CJWeakSelf;
    [self.manager GET:CJCommonURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        重置页码为1
        selectedCategory.page = 1;
//        储存总数
        selectedCategory.total = [responseObject[@"total"]integerValue];
//        存储用户数据
        selectedCategory.users = [CJFollowUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
//        刷新右边表格
        [weakSelf.userTableView reloadData];
//        结束刷新
        [weakSelf.userTableView.mj_header endRefreshing];
        
        if (selectedCategory.users.count >= selectedCategory.total) {
            weakSelf.userTableView.mj_footer.hidden = YES;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        结束刷新
        [weakSelf.userTableView.mj_header endRefreshing];
    }];
}
- (void)loadMoreUsers{
//    取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    // 左边选中的类别的ID
    CJFollowCategory *selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
    params[@"category_id"] = selectedCategory.ID;
    // 页码
    NSInteger page = selectedCategory.page + 1;
    params[@"page"] = @(page);
//    发送请求
    CJWeakSelf;
    [self.manager GET:CJCommonURL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        设置当前的最新页码数
        selectedCategory.page = page;
//        存储总数
        selectedCategory.total = [responseObject[@"total"] integerValue];
//        追加新的用户数据到以前的数组中
        NSArray * newUsers = [CJFollowUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [selectedCategory.users addObjectsFromArray:newUsers];
//        刷新右边表格
        [weakSelf.userTableView reloadData];
        
        if (selectedCategory.users.count >= selectedCategory.total) {
//            这组所有的用户数据已经加载完毕
            weakSelf.userTableView.mj_footer.hidden = YES;
            
        }else{
//            还可能会到下一页用户数据
//            结束刷新
            [weakSelf.userTableView.mj_footer endRefreshing];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        结束刷新
        [weakSelf.userTableView.mj_footer endRefreshing];
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.categoryTableView) {
        
        return self.categories.count;
        
    }else{
//        右边的用户表格 👉 →
//        左边选中的类别
        CJFollowCategory * selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        return selectedCategory.users.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) {
        CJCategoryCell * cell = [tableView dequeueReusableCellWithIdentifier:CJCategoryCellId];
        cell.category = self.categories[indexPath.row];
        return cell;
    }else{
//        右边的用户表格
        CJUserCell * cell = [tableView dequeueReusableCellWithIdentifier:CJUserCellId];
//        左边选中的类别
        CJFollowCategory * selectedCategory = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        cell.users = selectedCategory.users[indexPath.row];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) {
        CJFollowCategory * selectedCategory = self.categories[indexPath.row];
//        刷新右边的用户表格
        // （MJRefresh的默认做法：表格有数据，就会自动显示footer，表格没有数据，就会自动隐藏footer）
        [self.userTableView reloadData];
        
        if (selectedCategory.users.count >= selectedCategory.total) {
//            这组数据加载完毕
            self.userTableView.mj_footer.hidden = YES;
        }
//        判断是否有过用户数据
        if (selectedCategory.users.count == 0) {
//            加载右边的用户数据
            [self.userTableView.mj_header beginRefreshing];
        }
    }else{
//        右边的用户表格
        CJLog(@"点击了👉→的%zd行",indexPath.row);
    }
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

//
//  CJMeVC.m
//  百思不得其解
//
//  Created by eric on 17/1/4.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJMeVC.h"
#import "CJSettingsVC.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "CJSquareItem.h"
#import "CJSquareCell.h"
#import "CJWebViewVC.h"
/*
 搭建基本结构 -> 设置底部条 -> 设置顶部条 -> 设置顶部条标题字体 -> 处理导航控制器业务逻辑(跳转)
 */
static NSString * const ID = @"cell";
static NSInteger const cols = 4;
static CGFloat const margin = 1;

#define itemWH (CJScreenW - (cols - 1) * margin) / cols

@interface CJMeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(weak, nonatomic) UICollectionView * collectionView;
@property(strong, nonatomic) NSMutableArray * squreItem;
@end

@implementation CJMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor yellowColor];
    // 设置导航条
    [self setupNavBar];
    
    // 设置tableView底部视图
    [self setUpFootView];
    // 展示方块内容 -> 请求数据(查看接口文档)
    [self loadData];
    
     // 处理cell间距,默认tableView分组样式,有额外头部和尾部间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
    
    self.tableView.contentInset = UIEdgeInsetsMake(CJNavMaxY - 35, 0, 0, 0);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:CJTabBarButtonDidRepeatClickNotification object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - 监听
/**
 *  监听tabBarButton重复点击
 */
- (void)tabBarButtonDidRepeatClick
{
    if (self.view.window == nil) return;
    
    CJFUNC;
}
- (void)setupNavBar
{
    // 左边按钮
    // 把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    
    // 设置
    UIBarButtonItem *settingItem =  [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(setting)];
    
    // 夜间模型
    UIBarButtonItem *nightItem =  [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem,nightItem];
    
    // titleView
    self.navigationItem.title = @"我的";
    
}
- (void)setUpFootView{
//    1、初始化要设置流水布局
//    2、cell必须要注册
//    3、cell必须自定义
//    设置布局
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //    设置cell尺寸
    layout.itemSize = CGSizeMake(itemWH,itemWH);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
     // 创建UICollectionView
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:layout];
    collectionView.backgroundColor = self.tableView.backgroundColor;
    self.tableView.tableFooterView = collectionView;
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollEnabled = NO;
    
    [collectionView registerNib:[UINib nibWithNibName:@"CJSquareCell" bundle:nil] forCellWithReuseIdentifier:ID];
    _collectionView = collectionView;
}
#pragma mark - 请求数据
- (void)loadData{
    // 1.创建请求会话管理者
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
     // 2.拼接请求参数
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"a"] = @"square";
    params[@"c"] = @"topic";
    [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray * dictArr = responseObject[@"square_list"];
        _squreItem = [CJSquareItem mj_objectArrayWithKeyValuesArray:dictArr];
        // 处理数据
//        [self resloveData];
        // 设置collectionView 计算collectionView高度 = rows * itemWH
        // Rows = (count - 1) / cols + 1  3 cols4
        
        NSInteger count = _squreItem.count;
        NSInteger rows = (count -1)/cols+1;
        // 设置collectioView高度
        self.collectionView.height = rows * itemWH;
        // 设置tableView滚动范围:自己计算
        self.tableView.tableFooterView = self.collectionView;
        
        [self.collectionView reloadData];
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CJLog(@"%@",error.localizedDescription);
    }];
}
- (void)resloveData{
    
    NSInteger count = self.squreItem.count;
    NSInteger exter = count % cols;
    CJLog(@"%ld",exter);
    if (exter) {
        exter = cols - exter;
        for (int i = 0; i < exter; i++) {
            CJSquareItem * item = [[CJSquareItem alloc]init];
            [self.squreItem addObject:item];
        }
    }
}
- (void)night:(UIButton *)button
{
    button.selected = !button.selected;
    
}

#pragma mark - 设置就会调用
- (void)setting
{
    // 跳转到设置界面
    CJSettingsVC *settingVc = [[CJSettingsVC alloc] init];
    // 必须要在跳转之前设置
    
    [self.navigationController pushViewController:settingVc animated:YES];
    
    /*
     1.底部条没有隐藏
     2.处理返回按钮样式 : 1.去设置控制器里
     */
    
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 跳转界面 push 展示网页
    /*
     1.Safari openURL :自带很多功能(进度条,刷新,前进,倒退等等功能),必须要跳出当前应用
     2.UIWebView (没有功能) ,在当前应用打开网页,并且有safari,自己实现,UIWebView不能实现进度条
     3.SFSafariViewController:专门用来展示网页 需求:即想要在当前应用展示网页,又想要safari功能 iOS9才能使用
     3.1 导入#import <SafariServices/SafariServices.h>
     
     4.WKWebView:iOS8 (UIWebView升级版本,添加功能 1.监听进度 2.缓存)
     4.1 导入#import <WebKit/WebKit.h>
     
     */
    // 创建网页控制器
    CJSquareItem * items = self.squreItem[indexPath.row];
    if (![items.url containsString:@"http"]) {
        return;
    }
    CJWebViewVC * webView = [[CJWebViewVC alloc]init];
    webView.url = [NSURL URLWithString:items.url];
    [self.navigationController pushViewController:webView animated:YES];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.squreItem.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 从缓存池取
    CJSquareCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.items = self.squreItem[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDataSource UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

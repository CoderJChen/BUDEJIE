//
//  CJEssenceVC.m
//  百思不得其解
//
//  Created by eric on 17/1/4.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJEssenceVC.h"
#import "CJAllVC.h"
#import "CJVideoVC.h"
#import "CJVoiceVC.h"
#import "CJPictureVC.h"
#import "CJWordVC.h"
#import "CJTitleButton.h"
@interface CJEssenceVC ()<UIScrollViewDelegate>
/** 用来存放所有子控制器view的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 标题栏 */
@property(weak, nonatomic) UIView * titlesView;
/** 上一次点击的标题按钮 */
@property(weak, nonatomic) CJTitleButton * currentTitleButton;
/** 标题下划线 */
@property(nonatomic, weak) UIView *titleUnderline;

@end

@implementation CJEssenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
//    设置导航栏
    [self setupNavBar];
//    初始化子控制器
    [self setUpAllChildVCs];
//    scrollView
    [self setUpScrollView];
//    标题栏
    [self setUpTitlesView];
//    添加第一个子控制器的view
    [self addChildViewIntoScrollView:0];
    // Do any additional setup after loading the view.
}

#pragma mark - 设置导航条
- (void)setupNavBar
{
    // 左边按钮
    // 把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(game)];
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:nil action:nil];
    
    // titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
}

- (void)game
{
    CJFUNC;
}

/**
 *  初始化子控制器
 */
- (void)setUpAllChildVCs{
    [self addChildViewController:[[CJAllVC alloc]init]];
    [self addChildViewController:[[CJVideoVC alloc]init]];
    [self addChildViewController:[[CJVoiceVC alloc]init]];
    [self addChildViewController:[[CJPictureVC alloc]init]];
    [self addChildViewController:[[CJWordVC alloc]init]];
}
- (void)setUpScrollView{
    // 不允许自动修改UIScrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView * scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor greenColor];
    scrollView.frame = self.view.bounds;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollsToTop = NO;//点击状态栏的时候，这个scrollView不会滚动到最顶部
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    // 添加子控制器的view
    NSUInteger count = self.childViewControllers.count;
    CGFloat scrollViewH = scrollView.height;
    CGFloat scrollViewW = scrollView.width;
    for (int i = 0; i < count; i++) {
        UIView * childView = self.childViewControllers[i].view;
        childView.frame = CGRectMake(i*scrollViewW, 0, scrollViewW, scrollViewH);
        [scrollView addSubview:childView];
    }
    scrollView.contentSize = CGSizeMake(count * scrollViewW, 0);
}
/**
 *  标题栏
 */
- (void)setUpTitlesView{
    UIView * titlesView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 35)];
    titlesView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:titlesView];
    _titlesView = titlesView;
//    标题栏按钮
    [self setUpTitleButtons];
//    标题栏下划线
    [self setUpTitleUnderline];
    
}
/**
 *  标题栏按钮
 */
- (void)setUpTitleButtons{
//    标题文字
    NSArray * titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    NSUInteger count = titles.count;
//    标题按钮的尺寸
    CGFloat titleButtonW = self.titlesView.width/count;
    CGFloat titleButtonH = self.titlesView.height;
//    创建5个标题按钮
    for (int i = 0; i < count; i++) {
        CJTitleButton * titleButton = [CJTitleButton buttonWithType:UIButtonTypeCustom];
//        frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
//        titleButton.backgroundColor = [UIColor grayColor];
        titleButton.tag =100 + i;
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        文字
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        [self.titlesView addSubview:titleButton];
        
    }
}
#pragma mark - 监听
/**
 *  点击标题按钮
 */
- (void)titleButtonClick:(CJTitleButton *)btn{
//    重复点击了标题按钮
    if (self.currentTitleButton == btn) {
        [[NSNotificationCenter defaultCenter]postNotificationName:CJTitleButtonDidRepeatClickNotification object:nil];
    }
//    处理按钮的点击
//    切换按钮的状态
    self.currentTitleButton.selected = NO;
    btn.selected = YES;
    self.currentTitleButton = btn;
    NSInteger index = btn.tag - 100;
    
    [UIView animateWithDuration:0.25 animations:^{
//        处理下划线
        self.titleUnderline.width = self.currentTitleButton.titleLabel.width + 10;
        self.titleUnderline.centerX = self.currentTitleButton.centerX;
//        滚动scrollView
        self.scrollView.contentOffset = CGPointMake(self.scrollView.width * index, self.scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
//        添加子控制器的view
        [self addChildViewIntoScrollView:index];
    }];
//    设置index位置对应的tableView.scrollsToTop = YES，其他设置都为NO
    for (int i = 0; i < self.childViewControllers.count; i++) {
        UIViewController * childVC = self.childViewControllers[i];
//        如果view还没有被创建，就不用去处理
        if (!childVC.isViewLoaded) {
            continue;
        }
        UIScrollView * scrollView = (UIScrollView *)childVC.view;
        if (![scrollView isKindOfClass:[UIScrollView class]]) {
            continue;
        }
        scrollView.scrollsToTop = (i == index);
    }
}
/**
 *  标题下划线
 */
- (void)setUpTitleUnderline{
//    标题按钮
   CJTitleButton * firstTitleButton = self.titlesView.subviews.firstObject;
//    下划线
    UIView * titleUnderline = [[UIView alloc]init];
    titleUnderline.height = 2;
    titleUnderline.y = self.titlesView.height - titleUnderline.height;
    titleUnderline.backgroundColor = [UIColor redColor];
    [self.titlesView addSubview:titleUnderline];
    _titleUnderline = titleUnderline;
//    切换按钮状态
    firstTitleButton.selected = YES;
    self.currentTitleButton = firstTitleButton;
    // 让label根据文字内容计算尺寸
    [firstTitleButton.titleLabel sizeToFit];
    self.titleUnderline.width = firstTitleButton.titleLabel.width + 10;
    self.titleUnderline.centerX = firstTitleButton.centerX;
}
#pragma mark -其他
/**
 *  添加第index个子控制器的view到scrollView中
 */
- (void)addChildViewIntoScrollView:(NSInteger)index{
    
    UIViewController * childVC = self.childViewControllers[index];
    // 如果view已经被加载过，就直接返回
    if (childVC.isViewLoaded) {
        return;
    }
//    设置子控制器的frame
    UIView * childView = childVC.view;
    CGFloat scrollViewW = self.scrollView.width;
    childView.frame = CGRectMake(index * scrollViewW, 0, scrollViewW, self.scrollView.height);
//    添加子控制器的view到scrollView中
    [self.scrollView addSubview:childView];
}
#pragma mark - UIScrollViewDelegate
/**
 *  当用户松开scrollView并且滑动结束时调用这个代理方法（scrollView停止滚动的时候）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    求出标题按钮的索引
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
//    取出对应的标题按钮
    CJTitleButton * titleButton = self.titlesView.subviews[index];
    [self titleButtonClick:titleButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

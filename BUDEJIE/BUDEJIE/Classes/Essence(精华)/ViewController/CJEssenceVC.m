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

@property(weak, nonatomic) UIView * titlesView;
@property(weak, nonatomic) CJTitleButton * currentTitleButton;
@property(nonatomic, weak) UIView *titleUnderline;
@end

@implementation CJEssenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self setupNavBar];
    
    [self setUpAllChildVCs];
    
    [self setUpScrollView];
    
    [self setUpTitlesView];
    
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
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    NSUInteger count = self.childViewControllers.count;
    CGFloat scrollViewH = scrollView.height;
    CGFloat scrollViewW = scrollView.width;
    for (int i = 0; i < count; i++) {
        UIView * childView = self.childViewControllers[i].view;
        childView.frame = CGRectMake(i*scrollViewW, 0, scrollViewW, scrollViewH);
        [scrollView addSubview:childView];
    }
    scrollView.contentSize = CGSizeMake(count*scrollViewW, 0);
}
- (void)setUpTitlesView{
    UIView * titlesView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 35)];
    titlesView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:titlesView];
    _titlesView = titlesView;
    
    [self setUpTitleButtons];
    
    [self setUpTitleUnderline];
    
}
- (void)setUpTitleButtons{
    
    NSArray * titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    NSUInteger count = titles.count;
    CGFloat titleButtonW = self.titlesView.width/count;
    CGFloat titleButtonH = self.titlesView.height;
    for (int i = 0; i < count; i++) {
        CJTitleButton * titleButton = [CJTitleButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
//        titleButton.backgroundColor = [UIColor grayColor];
        titleButton.tag =100 + i;
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        [self.titlesView addSubview:titleButton];
        
    }
}
- (void)titleButtonClick:(CJTitleButton *)btn{
    if (self.currentTitleButton == btn) {
        [[NSNotificationCenter defaultCenter]postNotificationName:CJTitleButtonDidRepeatClickNotification object:nil];
    }
    self.currentTitleButton.selected = NO;
    btn.selected = YES;
    self.currentTitleButton = btn;
    NSInteger index = btn.tag - 100;
    [UIView animateWithDuration:0.25 animations:^{
        self.titleUnderline.width = self.currentTitleButton.titleLabel.width + 10;
        self.titleUnderline.centerX = self.currentTitleButton.centerX;
        
        self.scrollView.contentOffset = CGPointMake(self.scrollView.width * index, self.scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        [self addChildViewIntoScrollView:index];
    }];
    for (int i = 0; i < self.childViewControllers.count; i++) {
        UIViewController * childVC = self.childViewControllers[i];
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
- (void)setUpTitleUnderline{
    
   CJTitleButton * firstTitleButton = self.titlesView.subviews.firstObject;
    UIView * titleUnderline = [[UIView alloc]init];
    titleUnderline.height = 2;
    titleUnderline.y = self.titlesView.height - titleUnderline.height;
    titleUnderline.backgroundColor = [UIColor redColor];
    [self.titlesView addSubview:titleUnderline];
    _titleUnderline = titleUnderline;
    
    firstTitleButton.selected = YES;
    self.currentTitleButton = firstTitleButton;
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
    UIView * childView = childVC.view;
    CGFloat scrollViewW = self.scrollView.width;
    childView.frame = CGRectMake(index * scrollViewW, 0, scrollViewW, self.scrollView.height);
    [self.scrollView addSubview:childView];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    CJTitleButton * titleButton = self.titlesView.subviews[index];
    [self titleButtonClick:titleButton];
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

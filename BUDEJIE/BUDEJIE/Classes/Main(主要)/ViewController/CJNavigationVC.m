//
//  CJNavigationVC.m
//  百思不得其解
//
//  Created by eric on 17/1/4.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJNavigationVC.h"

@interface CJNavigationVC ()<UIGestureRecognizerDelegate>

@end

@implementation CJNavigationVC

+(void)initialize{
    /** 设置UINavigationBar */
    UINavigationBar * appearence = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
//    设置标题文字属性
    NSMutableDictionary * attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20.0];
    [appearence setTitleTextAttributes:attr];
//    设置背景
    [appearence setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
//    设置UIBarButtonItem
    UIBarButtonItem * itemAppearence = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
//    UIControlStateNormal
    NSMutableDictionary * normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17.0];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [itemAppearence setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
//    UIControlStateDisabled
    NSMutableDictionary * disabledAttrs = [NSMutableDictionary dictionary];
    disabledAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [itemAppearence setTitleTextAttributes:disabledAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    [self.view addGestureRecognizer:pan];
    
    pan.delegate = self;
//    禁止之前的手势
    self.interactivePopGestureRecognizer.enabled = NO;
    // Do any additional setup after loading the view.
}
#pragma mark -  UIGestureRecognizerDelegate

// 决定是否触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return self.childViewControllers.count > 1;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        // 恢复滑动返回功能 -> 分析:把系统的返回按钮覆盖 -> 1.手势失效(1.手势被清空 2.可能手势代理做了一些事情,导致手势失效)
         viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"]  target:self action:@selector(back) title:@"返回"];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (void)back{
    [self popViewControllerAnimated:YES];
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

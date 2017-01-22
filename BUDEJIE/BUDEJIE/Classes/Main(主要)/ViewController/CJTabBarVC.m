//
//  CJTabBarVC.m
//  百思不得其解
//
//  Created by eric on 17/1/4.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJTabBarVC.h"
#import "CJNavigationVC.h"
#import "CJEssenceVC.h"
#import "CJFriendTrendVC.h"
#import "CJMeVC.h"
#import "CJNewsVC.h"
#import "CJPublishVC.h"
#import "CJSettingsVC.h"
#import "CJTabBar.h"
@interface CJTabBarVC ()

@end

@implementation CJTabBarVC
/*
 问题:
 1.选中按钮的图片被渲染 -> iOS7之后默认tabBar上按钮图片都会被渲染 1.修改图片 2.通过代码 √
 2.选中按钮的标题颜色:黑色 标题字体大 -> 对应子控制器的tabBarItem √
 3.发布按钮显示不出来 分析:为什么其他图片可以显示,我的图片不能显示 => 发布按钮图片太大,导致显示不出来
 
 1.图片太大,系统帮你渲染 => 能显示 => 位置不对 => 高亮状态达不到
 
 解决:不能修改图片尺寸, 效果:让发布图片居中
 
 2.如何解决:系统的TabBar上按钮状态只有选中,没有高亮状态 => 中间发布按钮 不能用系统tabBarButton => 发布按钮 不是 tabBarController子控制器
 
 1.自定义tabBar
 
 */
//只会调用一次
+ (void)load{
//    获取哪个类中UITabBaritem
    UITabBarItem * item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    // 设置按钮选中标题的颜色:富文本:描述一个文字颜色,字体,阴影,空心,图文混排
    // 创建一个描述文本属性的字典
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    // 设置字体尺寸:只有设置正常状态下,才会有效果
    NSMutableDictionary * attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:attr forState:UIControlStateNormal];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    CJLog(@"%@",self.tabBar);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    1、添加子控制器（5个子控制器）->自定义控制器 -> 划分项目文件结构
    CJEssenceVC * essenceVc = [[CJEssenceVC alloc]init];
    [self addChildVC:essenceVc title:@"精华" image:@"tabBar_essence_icon" selectImage:@"tabBar_essence_click_icon"];
    CJNewsVC * newsVc = [[CJNewsVC alloc]init];
    [self addChildVC:newsVc title:@"新帖" image:@"tabBar_new_icon" selectImage:@"tabBar_new_click_icon"];
    
    CJFriendTrendVC * friendTrendVc = [[CJFriendTrendVC alloc]init];
    [self addChildVC:friendTrendVc title:@"关注" image:@"tabBar_friendTrends_icon" selectImage:@"tabBar_friendTrends_click_icon"];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([CJMeVC class]) bundle:nil];
   CJMeVC * meVc = [storyboard instantiateInitialViewController];
//    CJMeVC * meVc = [[CJMeVC alloc]init];
    [self addChildVC:meVc title:@"我" image:@"tabBar_me_icon" selectImage:@"tabBar_me_click_icon"];
//    自定义tabBar
    CJTabBar * tabBar = [[CJTabBar alloc]init];
    [self setValue:tabBar forKeyPath:@"tabBar"];

    // Do any additional setup after loading the view.
}
- (void)addChildVC:(UIViewController *)VC title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage{
    
    VC.tabBarItem.title = title;
    VC.tabBarItem.image = [UIImage imageNamed:image];
    VC.tabBarItem.selectedImage = [UIImage imageWithOrgionalImageName:selectImage];
    
    CJNavigationVC * navigationController = [[CJNavigationVC alloc]initWithRootViewController:VC];
    
    [self addChildViewController:navigationController];
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

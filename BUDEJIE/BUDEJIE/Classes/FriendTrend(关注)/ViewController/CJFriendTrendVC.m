//
//  CJFriendTrendVC.m
//  百思不得其解
//
//  Created by eric on 17/1/4.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJFriendTrendVC.h"
#import "CJLoginRegistVC.h"
#import "CJCommendVC.h"
@interface CJFriendTrendVC ()

@end

@implementation CJFriendTrendVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view.
    [self setupNavBar];
}

#pragma mark - 设置导航条
- (void)setupNavBar
{
    // 左边按钮
    // 把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(friendsRecomment)];
    
    // titleView
    self.navigationItem.title = @"我的关注";
    
}

// 推荐关注
- (void)friendsRecomment
{
    CJCommendVC * commentVC = [[CJCommendVC alloc]init];
    [self.navigationController pushViewController:commentVC animated:YES];
}
- (IBAction)loginRegistClick:(id)sender {
    
    CJLoginRegistVC * loginRegisterVC = [[CJLoginRegistVC alloc]init];
    loginRegisterVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:loginRegisterVC animated:YES completion:nil];
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

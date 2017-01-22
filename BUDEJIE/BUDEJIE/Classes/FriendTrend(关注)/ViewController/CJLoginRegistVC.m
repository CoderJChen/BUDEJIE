//
//  CJLoginRegistVC.m
//  BUDEJIE
//
//  Created by eric on 17/1/10.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJLoginRegistVC.h"
#import "CJRegisterLoginView.h"
#import "CJFastLoginView.h"

// 1.划分结构(顶部 中间 底部) // 2.一个结构一个结构
// 越复杂的界面 越要封装(复用)

/*
 屏幕适配:
 1.一个view从xib加载,需不需在重新固定尺寸 一定要在重新设置一下
 
 2.在viewDidLoad设置控件frame好不好,开发中一般在viewDidLayoutSubviews布局子控件
 */

@interface CJLoginRegistVC ()
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadIcons;
@property (weak, nonatomic) CJRegisterLoginView * registerView;
@property (weak, nonatomic) CJRegisterLoginView * loginView;
@property (weak, nonatomic) CJFastLoginView * fastLoginView;
@end

@implementation CJLoginRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    创建登录view
    CJRegisterLoginView * regist = [CJRegisterLoginView registerView];
//    添加到中间的view
    [self.middleView addSubview:regist];
    self.registerView = regist;
//    添加注册界面
    CJRegisterLoginView * login = [CJRegisterLoginView loginView];
    //    添加到中间的view
    [self.middleView addSubview:login];
    self.loginView = login;
//    添加快速登录view
    CJFastLoginView * fastLogin = [CJFastLoginView fastLoginView];
//    添加到底部的View
    [self.bottomView addSubview:fastLogin];
    self.fastLoginView = fastLogin;
    
    // Do any additional setup after loading the view from its nib.
}
// viewDidLayoutSubviews:才会根据布局调整控件的尺寸
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    设置登录view
    self.loginView.frame = CGRectMake(0, 0, self.middleView.width*0.5, self.middleView.height);
//    设置注册view
    self.registerView.frame = CGRectMake(self.middleView.width*0.5,0, self.middleView.width*0.5, self.middleView.height);
//    设置快速登录
    self.fastLoginView.frame = self.bottomView.bounds;
    
}
//让状态栏样式为白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registerClick:(UIButton *)sender {
    sender.selected = ! sender.selected;
    
    _leadIcons.constant = _leadIcons.constant == 0 ? -_middleView.width*0.5:0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
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

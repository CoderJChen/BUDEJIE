//
//  CJRegisterLoginView.m
//  BUDEJIE
//
//  Created by eric on 17/1/10.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJRegisterLoginView.h"

@interface CJRegisterLoginView()
@property (weak, nonatomic) IBOutlet UITextField *login_phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *login_password;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *login_forgetPwd;
@property (weak, nonatomic) IBOutlet UITextField *regist_phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *regist_password;
@property (weak, nonatomic) IBOutlet UIButton *regist;

@end

@implementation CJRegisterLoginView
// 越复杂的界面,封装 有特殊效果界面,也需要封装
//登录
+ (instancetype)loginView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}
//注册
+ (instancetype)registerView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

- (IBAction)loginClick:(id)sender {
}

- (IBAction)forgetPasswordClick:(id)sender {
}

- (IBAction)registClick:(UIButton *)sender {
}
- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    UIImage * loginImage = _login.currentBackgroundImage;
    UIImage * registerImage  = _regist.currentBackgroundImage;
    
    loginImage = [loginImage stretchableImageWithLeftCapWidth:loginImage.size.width*0.5 topCapHeight:loginImage.size.height*0.5];
    
    registerImage = [registerImage stretchableImageWithLeftCapWidth:registerImage.size.width*0.5 topCapHeight:registerImage.size.height*0.5];
    // 让按钮背景图片不要被拉伸
    [_login setBackgroundImage:loginImage forState:UIControlStateNormal];
    [_regist setBackgroundImage:registerImage forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

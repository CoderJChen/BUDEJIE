//
//  CJFastLoginView.m
//  BUDEJIE
//
//  Created by eric on 17/1/10.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJFastLoginView.h"

@interface CJFastLoginView()
@property (weak, nonatomic) IBOutlet UIButton *QQ_Login;
@property (weak, nonatomic) IBOutlet UIButton *weiBo_Login;
@property (weak, nonatomic) IBOutlet UIButton *tecent_Login;

@end

@implementation CJFastLoginView
//快速登录
+ (instancetype)fastLoginView{
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
    
}
- (IBAction)QQLoginClick:(UIButton *)sender {
}
- (IBAction)weiBoLoginClick:(UIButton *)sender {
}
- (IBAction)tecentLoginClick:(UIButton *)sender {
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

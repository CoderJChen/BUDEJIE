//
//  CJTabBar.m
//  百思不得其解
//
//  Created by eric on 17/1/4.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJTabBar.h"
#import "CJPublishVC.h"
@interface CJTabBar()
@property(nonatomic,weak)UIButton * plusButton;
@property(nonatomic, weak) UIControl * previousTabBarButton;
@end

@implementation CJTabBar
- (UIButton *)plusButton{
    if (_plusButton == nil) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        [self addSubview:btn];
        _plusButton = btn;
    }
    return _plusButton;
    
}
- (void)publishClick{
    CJPublishVC * publish = [[CJPublishVC alloc]init];
    [self.window.rootViewController presentViewController:publish animated:NO completion:nil];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger count = self.items.count;
    
    CGFloat width = self.width/(count+1);
    CGFloat height = self.height;
    CGFloat x = 0;
    int i = 0;
    for (UIControl * tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (i == 0 && self.previousTabBarButton == nil) {
                self.previousTabBarButton = tabBarButton;
            }
            if (i == 2) {
                i += 1;
            }
            x = i * width;
            tabBarButton.frame = CGRectMake(x, 0, width, height);
            i++;
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.plusButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}
//tabBarButton的点击
- (void)tabBarButtonClick:(UIControl *)tabBarButton{
    if (_previousTabBarButton == tabBarButton) {
        // 发出通知，告知外界tabBarButton被重复点击了
        [[NSNotificationCenter defaultCenter]postNotificationName:CJTabBarButtonDidRepeatClickNotification object:nil];
    }
    self.previousTabBarButton = tabBarButton;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  UITextField+Placeholder.m
//  BUDEJIE
//
//  Created by eric on 17/1/11.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "UITextField+Placeholder.h"
#import <objc/message.h>
@implementation UITextField (Placeholder)
+ (void)load{
    
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setCJ_PlaceholderMethod = class_getInstanceMethod(self, @selector(setCJ_Placeholder:));
    method_exchangeImplementations(setPlaceholderMethod, setCJ_PlaceholderMethod);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    // 给成员属性赋值 runtime给系统的类添加成员属性
    // 添加成员属性
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
     // 获取占位文字label控件
    UILabel * placeholderLabel = [self valueForKey:@"placeholderLabel"];
    // 设置占位文字颜色
    placeholderLabel.textColor = placeholderColor;
    
}

// 设置占位文字
// 设置占位文字颜色
- (UIColor *)placeholderColor{
    return objc_getAssociatedObject(self, @"placeholderColor");
}
- (void)setCJ_Placeholder:(NSString *)placeholder{
    [self setCJ_Placeholder:placeholder];
    self.placeholderColor = self.placeholderColor;
}
@end

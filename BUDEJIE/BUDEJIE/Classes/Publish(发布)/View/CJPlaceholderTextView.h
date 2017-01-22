//
//  CJPlaceholderTextView.h
//  BUDEJIE
//
//  Created by eric on 17/1/13.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJPlaceholderTextView : UITextView
//占位文字
@property (copy, nonatomic) NSString * placeholder;
//占位文字颜色
@property (strong, nonatomic) UIColor * placeholderColor;
@end

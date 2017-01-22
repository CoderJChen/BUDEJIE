//
//  CJTagTextField.h
//  BUDEJIE
//
//  Created by eric on 17/1/13.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJTagTextField : UITextField
/** 点击删除键需要执行的操作 */
@property (nonatomic, copy) void (^deleteBackwardOperation)();
@end

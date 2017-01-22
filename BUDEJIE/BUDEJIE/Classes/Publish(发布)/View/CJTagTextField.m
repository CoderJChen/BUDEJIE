//
//  CJTagTextField.m
//  BUDEJIE
//
//  Created by eric on 17/1/13.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJTagTextField.h"

@implementation CJTagTextField
/**
 * 监听键盘内部的删除键点击
 */
- (void)deleteBackward
{
    // 执行需要做的操作
    !self.deleteBackwardOperation ? : self.deleteBackwardOperation();
    
    [super deleteBackward];
}
@end

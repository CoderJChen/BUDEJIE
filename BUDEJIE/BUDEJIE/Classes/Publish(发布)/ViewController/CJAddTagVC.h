//
//  CJAddTagVC.h
//  BUDEJIE
//
//  Created by eric on 17/1/13.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJAddTagVC : UIViewController
/** 传递tag数据的block, block的参数是一个字符串数组 */
@property (copy, nonatomic) void (^getTagsBlock)(NSArray *);
/** 从上一个界面传递过来的标签数据 */
@property (strong, nonatomic) NSArray * tags;
@end

//
//  CJCommentVC.h
//  BUDEJIE
//
//  Created by eric on 17/1/16.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJTopic;
@interface CJCommentVC : UIViewController
/** 帖子模型 */
@property (nonatomic, strong) CJTopic *topic;
@end

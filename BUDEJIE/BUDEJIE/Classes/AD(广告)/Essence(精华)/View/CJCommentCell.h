//
//  CJCommentCell.h
//  BUDEJIE
//
//  Created by eric on 17/1/16.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJComment;
@interface CJCommentCell : UITableViewCell
/** 评论模型数据 */
@property (nonatomic, strong) CJComment *comment;
@end

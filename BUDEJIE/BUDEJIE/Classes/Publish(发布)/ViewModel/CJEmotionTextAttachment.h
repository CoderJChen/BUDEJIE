//
//  CJEmotionTextAttachment.h
//  BUDEJIE
//
//  Created by eric on 17/1/20.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJEmotionModel;
@interface CJEmotionTextAttachment : NSTextAttachment
@property(nonatomic, strong) CJEmotionModel * emotion;
@end

//
//  CJEmotionTool.h
//  BUDEJIE
//
//  Created by eric on 17/1/20.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CJEmotionModel;
@interface CJEmotionTool : NSObject
+ (void)addRecentEmotion:(CJEmotionModel *)emotion;
+ (NSArray *)achiveRecentEmotions;
@end

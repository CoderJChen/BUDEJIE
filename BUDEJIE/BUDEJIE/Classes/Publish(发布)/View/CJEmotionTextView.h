//
//  CJEmotionTextView.h
//  BUDEJIE
//
//  Created by eric on 17/1/20.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJPlaceholderTextView.h"
@class CJEmotionModel;
@interface CJEmotionTextView : CJPlaceholderTextView
- (void)insertEmotion:(CJEmotionModel *)emotion;
- (NSString *)fullText;
@end

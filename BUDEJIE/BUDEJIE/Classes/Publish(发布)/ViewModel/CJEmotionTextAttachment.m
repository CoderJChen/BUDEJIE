//
//  CJEmotionTextAttachment.m
//  BUDEJIE
//
//  Created by eric on 17/1/20.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJEmotionTextAttachment.h"
#import "CJEmotionModel.h"
@implementation CJEmotionTextAttachment
- (void)setEmotion:(CJEmotionModel *)emotion{
    _emotion = emotion;
    self.image = [UIImage imageNamed:emotion.png];
}
@end

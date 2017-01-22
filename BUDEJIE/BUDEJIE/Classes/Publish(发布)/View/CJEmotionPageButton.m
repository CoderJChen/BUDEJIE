//
//  CJEmotionPageButton.m
//  BUDEJIE
//
//  Created by eric on 17/1/20.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJEmotionPageButton.h"
#import "CJEmotionModel.h"
@implementation CJEmotionPageButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp{
        self.titleLabel.font = [UIFont systemFontOfSize:32.0];
        // 按钮高亮的时候。不要去调整图片（不要调整图片会灰色）
        self.adjustsImageWhenHighlighted = NO;
    //        self.adjustsImageWhenDisabled =

}
-(void)setEmotions:(CJEmotionModel *)emotions{
    _emotions = emotions;
    if (emotions.png) {
        [self setImage:[UIImage imageNamed:emotions.png] forState:UIControlStateNormal];
    }else if (emotions.code){
        [self setTitle:emotions.code.emoji forState:UIControlStateNormal];
    }
}
@end

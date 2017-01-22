//
//  CJEmotionButton.m
//  BUDEJIE
//
//  Created by eric on 17/1/20.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJEmotionButton.h"

@implementation CJEmotionButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUp];
}
- (void)setUp{
//    self.titleLabel.font = [UIFont systemFontOfSize:32.0];
//    // 按钮高亮的时候。不要去调整图片（不要调整图片会灰色）
//    self.adjustsImageWhenHighlighted = NO;
    //        self.adjustsImageWhenDisabled =
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.titleLabel.font = [UIFont systemFontOfSize:13.0];

    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

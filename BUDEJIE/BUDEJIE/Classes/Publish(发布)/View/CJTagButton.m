//
//  CJTagButton.m
//  BUDEJIE
//
//  Created by eric on 17/1/13.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJTagButton.h"

@implementation CJTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CJTagBgColor;
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return self;
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self sizeToFit];
    
    self.height = CJTagH;
    self.width += 3 * CJCommonSmallMargin;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.x = CJCommonSmallMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + CJCommonSmallMargin;
}
@end

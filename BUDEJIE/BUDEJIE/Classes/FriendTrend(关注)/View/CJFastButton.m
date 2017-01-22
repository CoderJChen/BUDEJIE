//
//  CJFastButton.m
//  BUDEJIE
//
//  Created by eric on 17/1/10.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJFastButton.h"

static CGFloat radio = 0.8;

@implementation CJFastButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeCenter;
        
        self.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeCenter;
}
//设置标题位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, contentRect.size.height*radio, contentRect.size.width, contentRect.size.height*(1-radio));
}
//设置图片位置
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake((contentRect.size.width - contentRect.size.height*radio) / 2, 0, contentRect.size.height * radio, contentRect.size.height*radio);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

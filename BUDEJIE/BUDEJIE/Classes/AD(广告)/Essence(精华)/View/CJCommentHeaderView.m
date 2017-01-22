//
//  CJCommentHeaderView.m
//  BUDEJIE
//
//  Created by eric on 17/1/16.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJCommentHeaderView.h"

@interface CJCommentHeaderView()
/** 内部的label */
@property (nonatomic, weak) UILabel *label;
@end

@implementation CJCommentHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = CJCommonBgColor;
        UILabel * label = [[UILabel alloc]init];
        label.x = CJCommonSmallMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        label.textColor = CJGrayColor(120);
        
        label.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:label];
        
        self.label = label;
    }
    
    return self;
}
- (void)setText:(NSString *)text{
    _text = [text copy];
    self.label.text = text;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

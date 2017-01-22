//
//  CJEmotionPopView.m
//  BUDEJIE
//
//  Created by eric on 17/1/20.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJEmotionPopView.h"
#import "CJEmotionPageButton.h"
@interface CJEmotionPopView()
@property (weak, nonatomic) IBOutlet CJEmotionPageButton *emotionButton;

@end

@implementation CJEmotionPopView
+ (instancetype)popView{
    return [self CJ_ViewFromXib];
}
- (void)showPopViewFrom:(CJEmotionPageButton *)button{
    if (!button) {
        return;
    }
    self.emotionButton.emotions = button.emotions;
    UIWindow * window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    CGRect fromRect = [button convertRect:button.bounds toView:window];
    self.y = CGRectGetMidY(fromRect) - self.height;
    self.centerX = CGRectGetMidX(fromRect);
    
}
- (void)awakeFromNib{
    [super awakeFromNib];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end

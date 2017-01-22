//
//  CJEmotionPageView.m
//  BUDEJIE
//
//  Created by eric on 17/1/20.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJEmotionPageView.h"
#import "CJEmotionPageButton.h"
#import "CJEmotionPopView.h"
#import "CJEmotionPageButton.h"
#import "CJEmotionTool.h"
@interface CJEmotionPageView ()
@property (weak,nonatomic) CJEmotionPopView * popView;
@property (weak,nonatomic) UIButton * deleteButton;
@property (strong,nonatomic) NSMutableArray * emotionButtons;
@end

@implementation CJEmotionPageView
- (CJEmotionPopView *)popView{
    if (!_popView) {
        CJEmotionPopView * popView = [CJEmotionPopView popView];
        _popView = popView;
    }
    return _popView;
}
- (NSMutableArray *)emotionButtons{
    if (!_emotionButtons) {
        _emotionButtons = [NSMutableArray array];
    }
    return _emotionButtons;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = CJRandomColor;
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.deleteButton = button;
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressPageView:)]];
    }
    return self;
}
- (void)deleteClick:(UIButton *)button{
    [CJNotificationCenter postNotificationName:CJEmotionDidDeleteNotification object:nil];
}
- (void)longPressPageView:(UILongPressGestureRecognizer *)longPress{
    CGPoint locationP = [longPress locationInView:longPress.view];
    CJEmotionPageButton * pageButton = [self emotionButtonWithLocation:locationP];
    switch (longPress.state) {
       
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            
            [self.popView removeFromSuperview];
            if (pageButton) {
                [self selectEmotion:pageButton.emotions];
            }
            break;
        }
        case UIGestureRecognizerStateFailed:
            
            break;
        case UIGestureRecognizerStateBegan:// 手势开始（刚检测到长按）
        case UIGestureRecognizerStateChanged:// 手势改变（手指的位置改变）
            [self.popView showPopViewFrom:pageButton];
            break;
        default:
            break;
    }
}
- (CJEmotionPageButton *)emotionButtonWithLocation:(CGPoint)location{
    NSInteger count = self.emotionButtons.count;
    for (int i = 0; i < count; i++) {
        CJEmotionPageButton * btn = self.emotionButtons[i];
        if (CGRectContainsPoint(btn.frame, location)) {
            return btn;
        }
    }
    return nil;
}
- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    for (int i = 0; i < emotions.count; i++) {
        CJEmotionPageButton * btn = [CJEmotionPageButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = CJRandomColor;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.emotions = emotions[i];
        [self addSubview:btn];
        [self.emotionButtons addObject:btn];
        
    }
}
- (void)btnClick:(CJEmotionPageButton *)button{
    [self.popView showPopViewFrom:button];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    [self selectEmotion:button.emotions];
}
- (void)selectEmotion:(CJEmotionModel *)emotion{
    [CJEmotionTool addRecentEmotion:emotion];
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
    userInfo[CJSelectEmotionKey] = emotion;
    [CJNotificationCenter postNotificationName:CJEmotionDidSelectNotification object:nil userInfo:userInfo];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    int margin = 20;
    CGFloat btnW = (self.width - 2 * margin)/CJEmotionMaxCols;
    CGFloat btnH = (self.height - margin)/CJEmotionMaxRows;
    
    for (int i = 0; i < self.emotionButtons.count; i++) {
        UIButton * btn = self.emotionButtons[i];
//        列数
        int col = i % CJEmotionMaxCols;
//        行数
        int row = i / CJEmotionMaxCols;
        
        btn.width = btnW;
        btn.height = btnH;
        btn.x = margin + col * btnW ;
        btn.y = margin + row * btnH;
    }
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.x = self.width - self.deleteButton.width - margin;
    self.deleteButton.y = self.height - self.deleteButton.height;
}
@end

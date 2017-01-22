//
//  CJEmotionTabBar.m
//  BUDEJIE
//
//  Created by eric on 17/1/19.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJEmotionTabBar.h"
#import "CJEmotionButton.h"
@interface CJEmotionTabBar()
@property (strong ,nonatomic) NSMutableArray * btnArrary;
@property (strong, nonatomic) CJEmotionButton * selectBtn;
@end
@implementation CJEmotionTabBar
-(NSMutableArray *)btnArrary{
    if (!_btnArrary) {
        _btnArrary = [ NSMutableArray array];
    }
    return _btnArrary;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBtnTitle: @"最近" buttonType:CJEmotionTabBarButtonTypeRecent];
        [self setBtnTitle:@"默认" buttonType:CJEmotionTabBarButtonTypeDefault];
        [self setBtnTitle:@"Emoji" buttonType:CJEmotionTabBarButtonTypeEmoji];
        [self setBtnTitle:@"浪小花" buttonType:CJEmotionTabBarButtonTypeLxh];
    }
    return self;
}
- (void)setBtnTitle:(NSString *)title buttonType:(CJEmotionTabBarButtonType)type{
    
    CJEmotionButton * button = [CJEmotionButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = type;
    [self addSubview:button];
    
    [self.btnArrary addObject:button];
    
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *selectImage = @"compose_emotion_table_mid_selected";
    if (self.btnArrary.count == 1) {
        image =@"compose_emotion_table_left_normal";
        selectImage = @"compose_emotion_table_left_selected";
    }else if (self.btnArrary.count == 4){
        image = @"compose_emotion_table_right_normal";
        selectImage =@"compose_emotion_table_right_selected";
    }
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateDisabled];
}
- (void)setDelegate:(id<CJEmotionTabBarDelegate>)delegate{
    _delegate = delegate;
    [self btnClick:[self viewWithTag:CJEmotionTabBarButtonTypeDefault]];
}
- (void)btnClick:(CJEmotionButton *)button{
    self.selectBtn.enabled = YES;
    button.enabled = NO;
    self.selectBtn = button;
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:tabBarButtonTye:)]) {
//        CJLog(@"%ld",button.tag);
        [self.delegate emotionTabBar:self tabBarButtonTye:button.tag];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnWidth = self.width/self.btnArrary.count;
    CGFloat btnHeight = self.height;
    for (int i = 0; i < self.btnArrary.count; i++) {
        UIButton * button = self.btnArrary[i];
        button.x = i * btnWidth;
        button.y = 0;
        button.width = btnWidth;
        button.height = btnHeight;
    }
}
@end

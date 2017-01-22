//
//  CJEmotionKeyboardView.m
//  BUDEJIE
//
//  Created by eric on 17/1/19.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJEmotionKeyboardView.h"
#import "CJEmotionTabBar.h"
#import <MJExtension/MJExtension.h>
#import "CJEmotionListView.h"
#import "CJEmotionModel.h"
#import "CJEmotionTool.h"
@interface CJEmotionKeyboardView()<CJEmotionTabBarDelegate>
/** 保存正在显示listView （弱指针）*/
@property (nonatomic, weak) CJEmotionListView *showingListView;
/** 表情内容 （强指针）*/
@property (nonatomic, strong) CJEmotionListView * recentListView;
@property (nonatomic, strong) CJEmotionListView * defaultListView;
@property (nonatomic, strong) CJEmotionListView * emojiListView;
@property (nonatomic, strong) CJEmotionListView * lxhListView;

@property(weak,nonatomic) CJEmotionTabBar *tabBar;
@end

@implementation CJEmotionKeyboardView
- (CJEmotionListView *)recentListView{
    if (!_recentListView) {
        _recentListView = [[CJEmotionListView alloc]init];
        _recentListView.emotions = [CJEmotionTool achiveRecentEmotions];
    }
    return _recentListView;
}
- (CJEmotionListView *)defaultListView{
    if (!_defaultListView) {
       _defaultListView = [[CJEmotionListView alloc]init];
        
        NSString * path = [[NSBundle mainBundle]pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        NSArray * emotion = [CJEmotionModel mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        _defaultListView.emotions = emotion;
    }
    return _defaultListView;
}
- (CJEmotionListView *)emojiListView{
    if (!_emojiListView) {
        _emojiListView = [[CJEmotionListView alloc]init];
        NSString * path = [[NSBundle mainBundle]pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        _emojiListView.emotions = [CJEmotionModel mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiListView;
}
- (CJEmotionListView *)lxhListView{
    if (!_lxhListView) {
        _lxhListView = [[CJEmotionListView alloc]init];
NSString * path = [[NSBundle mainBundle]pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        _lxhListView.emotions = [CJEmotionModel mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhListView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        CJEmotionTabBar * tabBar = [[CJEmotionTabBar alloc]init];
        tabBar.delegate = self;
        tabBar.backgroundColor = CJRandomColor;
        [self addSubview:tabBar];
        _tabBar = tabBar;
   
    }
    return self;
}
#pragma mark -CJEmotionTabBarDelegate
- (void)emotionTabBar:(CJEmotionTabBar *)tabBar tabBarButtonTye:(CJEmotionTabBarButtonType)type{
    
    [self.showingListView removeFromSuperview];
    switch (type) {
        case CJEmotionTabBarButtonTypeRecent:
            [self addSubview:self.recentListView];
            break;
        case CJEmotionTabBarButtonTypeDefault:
            [self addSubview:self.defaultListView];
            break;
        case CJEmotionTabBarButtonTypeEmoji:
            [self addSubview:self.emojiListView];
            break;
        case CJEmotionTabBarButtonTypeLxh:
            [self addSubview:self.lxhListView];
            break;
            
        default:
            break;
    }
    self.showingListView = [self.subviews lastObject];
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
//    状态栏
    self.tabBar.width = self.width;
    self.tabBar.height = 37;
    self.tabBar.x = 0;
    self.tabBar.y = self.height - self.tabBar.height;
//    显示的表情列表
    self.showingListView.x = self.showingListView.y = 0;
    self.showingListView.width = self.width;
    self.showingListView.height = self.tabBar.y;
}
@end

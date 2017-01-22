//
//  CJEmotionTabBar.h
//  BUDEJIE
//
//  Created by eric on 17/1/19.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJEmotionTabBar;
typedef NS_ENUM(NSUInteger,CJEmotionTabBarButtonType){
    CJEmotionTabBarButtonTypeRecent = 0, // 最近
    CJEmotionTabBarButtonTypeDefault, // 默认
    CJEmotionTabBarButtonTypeEmoji, // emoji
    CJEmotionTabBarButtonTypeLxh, // 浪小花
};

@protocol CJEmotionTabBarDelegate <NSObject>
- (void)emotionTabBar:(CJEmotionTabBar *)tabBar tabBarButtonTye:(CJEmotionTabBarButtonType)type;
@end

@interface CJEmotionTabBar : UIView
@property(weak, nonatomic) id <CJEmotionTabBarDelegate> delegate;
@end

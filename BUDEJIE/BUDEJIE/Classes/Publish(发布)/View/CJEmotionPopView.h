//
//  CJEmotionPopView.h
//  BUDEJIE
//
//  Created by eric on 17/1/20.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJEmotionPageButton;
@interface CJEmotionPopView : UIView
+ (instancetype)popView;
- (void)showPopViewFrom:(CJEmotionPageButton *)button;
@end

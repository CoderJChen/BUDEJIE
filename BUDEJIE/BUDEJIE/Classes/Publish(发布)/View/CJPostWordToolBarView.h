//
//  CJPostWordToolBarView.h
//  BUDEJIE
//
//  Created by eric on 17/1/13.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJPostWordToolBarView;

typedef NS_ENUM(NSInteger,CJComposeToolbarButtonType){
    CJComposeToolbarButtonTypeCamera = 0, // 拍照
    CJComposeToolbarButtonTypePicture, // 相册
    CJComposeToolbarButtonTypeMention, // @
    CJComposeToolbarButtonTypeTrend, // #
    CJComposeToolbarButtonTypeEmotion // 表情
};

@protocol CJPostWordToolBarViewDelegate <NSObject>

- (void)composeTool:(CJPostWordToolBarView *)toolBar buttonType:(CJComposeToolbarButtonType) type;

@end

@interface CJPostWordToolBarView : UIView
@property(assign,nonatomic) BOOL showKeyboardButton;
@property(weak,nonatomic) id <CJPostWordToolBarViewDelegate> delegate;
@end

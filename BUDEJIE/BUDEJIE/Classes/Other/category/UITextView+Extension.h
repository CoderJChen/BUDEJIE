//
//  UITextView+Extension.h
//  BUDEJIE
//
//  Created by eric on 17/1/22.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Extension)
- (void)insertAttribute:(NSAttributedString *)attrbute;
- (void)insertAttributeText:(NSAttributedString *)attrbute settingBlock:(void(^)(NSMutableAttributedString * attributeText))settingBlock;
@end

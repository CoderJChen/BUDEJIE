//
//  UITextView+Extension.m
//  BUDEJIE
//
//  Created by eric on 17/1/22.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)
- (void)insertAttribute:(NSAttributedString *)attrbute{
    [self insertAttributeText:attrbute settingBlock:nil];
}
- (void)insertAttributeText:(NSAttributedString *)attrbute settingBlock:(void (^)(NSMutableAttributedString *))settingBlock{
    
    NSMutableAttributedString * attributeText = [[NSMutableAttributedString alloc]init];
    
    [attributeText appendAttributedString:self.attributedText];
    NSUInteger loc = self.selectedRange.location;
    [attributeText insertAttributedString:attrbute atIndex:loc];
    
    settingBlock?:settingBlock(attributeText);
    self.attributedText = attributeText;
    self.selectedRange = NSMakeRange(loc + 1, 0);
    
}
@end

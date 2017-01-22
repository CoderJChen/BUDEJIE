//
//  CJEmotionTextView.m
//  BUDEJIE
//
//  Created by eric on 17/1/20.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJEmotionTextView.h"
#import "CJEmotionModel.h"
#import "CJEmotionTextAttachment.h"
@implementation CJEmotionTextView
/**
 selectedRange :
 1.本来是用来控制textView的文字选中范围
 2.如果selectedRange.length为0，selectedRange.location就是textView的光标位置
 
 关于textView文字的字体
 1.如果是普通文字（text），文字大小由textView.font控制
 2.如果是属性文字（attributedText），文字大小不受textView.font控制，应该利用NSMutableAttributedString的- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;方法设置字体
 **/
- (void)insertEmotion:(CJEmotionModel *)emotion{
    
    if (emotion.code) {
        [self insertText:emotion.code.emoji];
        
    }else if (emotion.png){
        
        CJEmotionTextAttachment * attach = [[CJEmotionTextAttachment alloc]init];
        attach.emotion = emotion;
        CGFloat attachWH = self.font.lineHeight;
        attach.bounds = CGRectMake(0, -4, attachWH, attachWH);
        //        根据一个附件创建一个文字属性
        NSAttributedString * imageAttr = [NSAttributedString attributedStringWithAttachment:attach];
        
        [self insertAttributeText:imageAttr settingBlock:^(NSMutableAttributedString *attributeText) {
            [attributeText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributeText.length)];
        }];
    }
}
- (NSString *)fullText{
    NSMutableString * fullText = [NSMutableString string];
    
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        CJEmotionTextAttachment * attach = [[CJEmotionTextAttachment alloc]init];
        if (attach) {
            [fullText appendString:attach.emotion.chs];
        }else{
            NSAttributedString * str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    return fullText;
}
@end

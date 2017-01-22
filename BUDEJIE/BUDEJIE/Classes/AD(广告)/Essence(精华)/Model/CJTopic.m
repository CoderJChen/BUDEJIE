//
//  CJTopic.m
//  BUDEJIE
//
//  Created by eric on 17/1/11.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJTopic.h"
#import "MJExtension.h"
@implementation CJTopic
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID":@"id",
             @"topComment" : @"top_cmt[0]"
             };
}
/*
 如果错误信息里面包含了：NaN，一般都是因为除0造成（比如x/0）
 (NaN : Not a number）
 */
- (CGFloat)cellHeight{
//    如果已经计算过了，直接返回
    
    if (_cellHeight) {
        return _cellHeight;
    }
    
//    文字的y值
    _cellHeight += 55;
//    文字的高度
    CGSize textMaxSize = CGSizeMake(CJScreenW - 2 * CJMargin, MAXFLOAT);
    _cellHeight += [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size.height + CJMargin;
//    中间的内容
    if (self.type != CJTopicTypeWord) {
        CGFloat middleW = textMaxSize.width;
        CGFloat middleH = middleW * self.height / self.width;
        if (middleH >= CJScreenH) {// 显示的图片高度超过一个屏幕，就是超长图片
            middleH = 200;
            self.bigPicture = YES;
        }
        CGFloat middleY = _cellHeight;
        CGFloat middleX = CJMargin;
        
        self.middleFrame = CGRectMake(middleX, middleY, middleW, middleH);
        _cellHeight += middleH + CJMargin;
    }
    
    if (self.top_cmt.count) {
        _cellHeight += 21;
        
        NSDictionary * cmt = self.top_cmt.firstObject;
        NSString * content = cmt[@"content"];
        if (content.length == 0) {
            content = @"[语音评论]";
        }
        NSString * userName = cmt[@"user"][@"username"];
        NSString * cmyText = [NSString stringWithFormat:@"%@ : %@",userName,content];
        _cellHeight += [cmyText boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]} context:nil].size.height + CJMargin;
    }
//    工具条
    _cellHeight += 35 + CJMargin;
    return _cellHeight;
}
@end

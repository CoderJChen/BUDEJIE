//
//  CJEmotionModel.m
//  BUDEJIE
//
//  Created by eric on 17/1/20.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJEmotionModel.h"

@implementation CJEmotionModel
/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该如何解档
 */
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.chs = [coder decodeObjectForKey:@"chs"];
        self.png = [coder decodeObjectForKey:@"png"];
        self.code = [coder decodeObjectForKey:@"code"];
    }
    return self;
}
/**
 * 当一个对象归档进沙盒中去，就会调用这个方法
 * 目的：在这个方法中说明沙盒中的属性该如何解析（需要取出那些属性）
 */
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.chs forKey:@"chs"];
    [aCoder encodeObject:self.png forKey:@"png"];
    [aCoder encodeObject:self.code forKey:@"code"];
}
@end

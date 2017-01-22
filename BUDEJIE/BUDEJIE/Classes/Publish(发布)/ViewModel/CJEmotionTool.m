//
//  CJEmotionTool.m
//  BUDEJIE
//
//  Created by eric on 17/1/20.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJEmotionTool.h"
#import "CJEmotionModel.h"

#define CJRecentEmotion [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"emotions.archiver"]

@implementation CJEmotionTool
+ (void)addRecentEmotion:(CJEmotionModel *)emotion{
//    添加到沙盒中的表情
    NSMutableArray * emotions = (NSMutableArray *)[self achiveRecentEmotions];
    if (emotions == nil) {
        emotions = [NSMutableArray array];
    }
    [emotions insertObject:emotion atIndex:0];
    [NSKeyedArchiver archiveRootObject:emotions toFile:CJRecentEmotion];
}
+ (NSArray *)achiveRecentEmotions{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:CJRecentEmotion];
}
@end

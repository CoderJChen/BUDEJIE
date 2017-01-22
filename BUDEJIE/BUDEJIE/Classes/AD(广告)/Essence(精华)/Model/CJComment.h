//
//  CJComment.h
//  BUDEJIE
//
//  Created by eric on 17/1/16.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CJUser;

@interface CJComment : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;

/** 文字内容 */
@property (nonatomic, copy) NSString *content;

/** 用户 */
@property (nonatomic, strong) CJUser *user;

/** 点赞数 */
@property (nonatomic, assign) NSInteger like_count;

/** 语音文件的路径 */
@property (nonatomic, copy) NSString *voiceuri;

/** 语音文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;

@end

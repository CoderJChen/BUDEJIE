//
//  CJFollowUser.h
//  BUDEJIE
//
//  Created by eric on 17/1/17.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJFollowUser : NSObject
/** 粉丝数 */
@property (nonatomic, assign) NSInteger fans_count;
/** 头像 */
@property (nonatomic, copy) NSString *header;
/** 昵称 */
@property (nonatomic, copy) NSString *screen_name;
@end

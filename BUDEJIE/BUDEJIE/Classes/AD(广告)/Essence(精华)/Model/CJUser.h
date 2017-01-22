//
//  CJUser.h
//  BUDEJIE
//
//  Created by eric on 17/1/16.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJUser : NSObject
/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
@end

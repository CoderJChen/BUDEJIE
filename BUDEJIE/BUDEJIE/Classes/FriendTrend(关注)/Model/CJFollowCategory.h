//
//  CJFollowCategory.h
//  BUDEJIE
//
//  Created by eric on 17/1/17.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJFollowCategory : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;
/** 名字 */
@property (nonatomic, copy) NSString *name;

/** 这组的用户总数 */
@property (nonatomic, assign) NSInteger total;
/** 当前的页码 */
@property (nonatomic, assign) NSInteger page;
/** 这个类别对应的用户数据 */
@property (nonatomic, strong) NSMutableArray *users;
@end

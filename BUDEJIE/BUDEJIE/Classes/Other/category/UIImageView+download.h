//
//  UIImageView+download.h
//  BUDEJIE
//
//  Created by eric on 17/1/12.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
@interface UIImageView (download)

- (void)CJ_setOriginImage:(NSString *)originImageURL thumbnailImage:(NSString *)thumbImageURL placeholder:(UIImage *)placeholder completion:(SDWebImageCompletionBlock)completionBlock;

- (void)CJ_setHeader:(NSString *)header;

@end

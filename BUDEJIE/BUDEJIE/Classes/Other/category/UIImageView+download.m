//
//  UIImageView+download.m
//  BUDEJIE
//
//  Created by eric on 17/1/12.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "UIImageView+download.h"
#import <AFNetworkReachabilityManager.h>

@implementation UIImageView (download)
-(void)CJ_setOriginImage:(NSString *)originImageURL thumbnailImage:(NSString *)thumbImageURL placeholder:(UIImage *)placeholder completion:(SDWebImageCompletionBlock)completionBlock{
    // 根据网络状态来加载图片
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 获得原图（SDWebImage的图片缓存是用图片的url字符串作为key）
    UIImage *originImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originImageURL];
    if (originImage) { // 原图已经被下载过
        [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completionBlock];
    } else { // 原图并未下载过
        if (mgr.isReachableViaWiFi) {
            [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completionBlock];
        } else if (mgr.isReachableViaWWAN) {
            // 3G\4G网络下时候要下载原图
            BOOL downloadOriginImageWhen3GOr4G = YES;
            if (downloadOriginImageWhen3GOr4G) {
                [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completionBlock];
            } else {
                [self sd_setImageWithURL:[NSURL URLWithString:thumbImageURL] placeholderImage:placeholder completed:completionBlock];
            }
        } else { // 没有可用网络
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbImageURL];
            if (thumbnailImage) { // 缩略图已经被下载过
                [self sd_setImageWithURL:[NSURL URLWithString:thumbImageURL] placeholderImage:placeholder completed:completionBlock];
            } else { // 没有下载过任何图片
                // 占位图片;
                [self sd_setImageWithURL:nil placeholderImage:placeholder completed:completionBlock];
            }
        }
    }
}
- (void)CJ_setHeader:(NSString *)header{
    
    UIImage * placeholder = [UIImage CJ_circleImageName:@"defaultUserIcon"];
    
    [self sd_setImageWithURL:[NSURL URLWithString:header] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 图片下载失败，直接返回，按照它的默认做法
        if (!image) {
            return ;
        }
        self.image = [image CJ_circleImage];
    }];
}
@end

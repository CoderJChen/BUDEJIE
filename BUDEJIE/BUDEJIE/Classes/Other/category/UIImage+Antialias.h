//
//  UIImage+Antialias.h
//  BUDEJIE
//
//  Created by eric on 17/1/11.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Antialias)
//返回一个抗锯齿图片->本质：在图片生成一个透明为1的像素边框
- (UIImage *)imageAntialias;
@end

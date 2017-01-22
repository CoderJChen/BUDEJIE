//
//  UIImage+Extension.m
//  百思不得其解
//
//  Created by eric on 17/1/4.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (instancetype)imageWithOrgionalImageName:(NSString *)imageName{
    UIImage * image = [UIImage imageNamed:imageName];
   return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
- (instancetype)CJ_circleImage{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    UIBezierPath * bezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [bezier addClip];
    [self drawAtPoint:CGPointZero];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (instancetype)CJ_circleImageName:(NSString *)name{
    return [[self imageNamed:name]CJ_circleImage];
}
@end

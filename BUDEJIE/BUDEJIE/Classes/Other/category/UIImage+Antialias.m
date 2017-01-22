//
//  UIImage+Antialias.m
//  BUDEJIE
//
//  Created by eric on 17/1/11.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "UIImage+Antialias.h"

@implementation UIImage (Antialias)
// 在周边加一个边框为1的透明像素
- (UIImage *)imageAntialias{
    
    CGFloat border = 1.0f;
    CGRect rect = CGRectMake(border, border, self.size.width - 2*border, self.size.height - 2 * border);
    
    UIImage * image = nil;
    
    UIGraphicsBeginImageContext(rect.size);
    
    [self drawInRect:CGRectMake(-1, -1, rect.size.width, rect.size.height)];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(self.size);
    [image drawInRect:rect];
    
    UIImage * antialiasImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return antialiasImage;
}
@end

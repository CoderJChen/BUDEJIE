//
//  UIImage+Extension.h
//  百思不得其解
//
//  Created by eric on 17/1/4.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (instancetype)imageWithOrgionalImageName:(NSString *)imageName;
+ (instancetype)CJ_circleImageName:(NSString *)name;
- (instancetype)CJ_circleImage;
@end

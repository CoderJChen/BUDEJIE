//
//  UIView+Extention.h
//  CJGoJD
//
//  Created by chenjie on 16/7/18.
//  Copyright © 2016年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extention)

@property(nonatomic,assign)CGFloat x;

@property(nonatomic,assign)CGFloat y;

@property(nonatomic,assign)CGFloat width;

@property(nonatomic,assign)CGFloat height;

@property(nonatomic,assign)CGFloat centerX;

@property(nonatomic,assign)CGFloat centerY;

@property(nonatomic,assign)CGPoint origin;

@property(nonatomic,assign)CGSize size;

+ (instancetype)CJ_ViewFromXib;
@end

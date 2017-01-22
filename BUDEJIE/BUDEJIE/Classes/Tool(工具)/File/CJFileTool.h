//
//  CJFileTool.h
//  BUDEJIE
//
//  Created by eric on 17/1/11.
//  Copyright © 2017年 eric. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 业务类:以后开发中用来专门处理某件事情,网络处理,缓存处理
 */

@interface CJFileTool : NSObject
/**
 *  获得文件夹尺寸
 * @param  directoryPath 文件夹路径
 *  返回文件夹尺寸
 */
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger totalSize))completion;
/**
 * 删除文件夹所有文件
 * @param directoryPath 文件夹路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;
@end

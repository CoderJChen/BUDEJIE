//
//  CJFileTool.m
//  BUDEJIE
//
//  Created by eric on 17/1/11.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJFileTool.h"

@implementation CJFileTool
+ (void)getFileSize:(NSString *)directoryPath completion:(void (^)(NSInteger))completion{
//    获取文件管理者
    NSFileManager * manager = [NSFileManager defaultManager];
//    查看该文件路径是否存在
    BOOL isDirectory;
    BOOL isExist = [manager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isExist || !isDirectory) {
//        抛出异常
//    name:异常名称
//    reason:报错原因
        NSException * exception = [NSException exceptionWithName:@"pathError" reason:@"需要传入的是文件夹路径,并且路径要存在" userInfo:nil];
        [exception raise];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        获得文件夹下所有的子路径，包含子路径的子路径
        NSArray * subPaths = [manager subpathsAtPath:directoryPath];
        NSInteger totalSize = 0;
        for (NSString * subPath in subPaths) {
//            获取文件全路径
            NSString * filePath = [directoryPath stringByAppendingPathComponent:subPath];
//            判断隐藏文件
            if ([filePath containsString:@".DS"]) {
                continue;
            }
//            判断是否是文件夹
            BOOL isDirectory;
//            判断文件是否存在，并且判断是否是文件夹
            BOOL isExist = [manager fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (!isExist || isDirectory) {
                continue;
            }
//            获得文件属性
            // attributesOfItemAtPath:只能获取文件尺寸,获取文件夹不对,
            NSDictionary * attrs = [manager attributesOfItemAtPath:filePath error:nil];
//            获取文件尺寸
            NSInteger fileSize = [attrs fileSize];
            totalSize += fileSize;
        }
//        计算完成回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(totalSize);
            }
        });
    });
}
+ (void)removeDirectoryPath:(NSString *)directoryPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    BOOL isDirectory ;
    BOOL isExist = [manager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isExist || !isDirectory) {
//        抛异常
//    name: 异常名称
//    reason:异常原因
        NSException * exception = [NSException exceptionWithName:@"pathError" reason:@"需要传入的是文件夹路径,并且路径要存在" userInfo:nil];
        [exception raise];
    }
    NSArray * subPaths = [manager subpathsAtPath:directoryPath];
    for (NSString * subPath in subPaths) {
//        获得完整的全路径
        NSString * filePath = [directoryPath stringByAppendingPathComponent:subPath];
//        删除路径
        [manager removeItemAtPath:filePath error:nil];
    }
}
@end

//
//  CJSettingsVC.m
//  百思不得其解
//
//  Created by eric on 17/1/4.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJSettingsVC.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>
#import "CJFileTool.h"

#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface CJSettingsVC ()
@property(assign, nonatomic) NSInteger totalSize;
@end

static NSString * const ID = @"cellID";

@implementation CJSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航条左边按钮
    
    self.title = @"设置";
    
    // 设置右边
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"jump" style:0 target:self action:@selector(jump)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    [SVProgressHUD showWithStatus:@"正在计算缓存尺寸ing...."];
    // 获取文件夹尺寸
    // 文件夹非常小,如果我的文件非常大
    [CJFileTool getFileSize:CachePath completion:^(NSInteger totalSize) {
        _totalSize = totalSize;
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
    
}

- (void)jump
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - UITableViewDataSource UITableViewDelegate
//点击cell就会调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_totalSize) {
        return;
    }
//    清空缓存
//    删除文件夹里面所有的文件
    [CJFileTool removeDirectoryPath:CachePath];
    [SVProgressHUD showSuccessWithStatus:@"清除成功"];
    
    _totalSize = 0;
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    // 计算缓存数据,计算整个应用程序缓存数据 => 沙盒(Cache) => 获取cache文件夹尺寸
    // 获取缓存尺寸字符串
    cell.textLabel.text = [self sizeString];
    return cell;
}
// 获取缓存尺寸字符串
- (NSString *)sizeString{
    
    NSInteger totalSize = _totalSize;
    NSString * sizeStr = @"清除缓存";
    //MB KB B
    if (totalSize > 1000 * 1000) {
        CGFloat sizeF = totalSize / 1000.0 /1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fMB)",sizeStr,sizeF];
    }else if (totalSize > 1000){
        CGFloat sizeF = totalSize / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fKB)",sizeStr,sizeF];
    }else if(totalSize < 1000){
        sizeStr = [NSString stringWithFormat:@"%@(%ldB)",sizeStr,totalSize];
    }
    return sizeStr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

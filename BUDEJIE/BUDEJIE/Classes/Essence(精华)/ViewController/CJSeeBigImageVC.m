//
//  CJSeeBigImageVC.m
//  BUDEJIE
//
//  Created by eric on 17/1/12.
//  Copyright © 2017年 eric. All rights reserved.
/*
 date 1.12
 1、 进度汇报
    1>界面上拉和下拉刷新完善
    2>在界面点击图片显示大图
    3>完善菜单界面，自定义相册，添加图片到相册
 2、 任务问题讨论
 -----无
 3 、明天重点工作安排
 -----根据实际安排
 4 、工作资源需求，或请假需求
 */

#import "CJSeeBigImageVC.h"
#import "SVProgressHUD.h"
#import <Photos/Photos.h>
@interface CJSeeBigImageVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) UIScrollView * scrollView;
@property (weak, nonatomic) UIImageView * imageView;
/** 当前App对应的自定义相册 */
- (PHAssetCollection *)createdCollection;
/** 返回刚才保存到【相机胶卷】的图片 */
- (PHFetchResult<PHAsset *>*)createdAssets;
@end

@implementation CJSeeBigImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView * scrollView = [[UIScrollView alloc]init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeClick:)]];
    [self.view insertSubview:scrollView atIndex:0];
    self.scrollView = scrollView;
    
    UIImageView * imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_topics.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            return;
        }
        self.saveButton.enabled = YES;
    }];
    imageView.width = scrollView.width;
    imageView.height = imageView.width * self.topics.height / self.topics.width;
    imageView.x = 0;
    if (imageView.height > CJScreenH) {
        imageView.y = 0;
        scrollView.contentSize = CGSizeMake(0, imageView.height);
    }else{
        imageView.centerY = scrollView.height * 0.5;
    }
    [scrollView addSubview:imageView];
    
    self.imageView = imageView;
    
    CGFloat maxScale = self.topics.width/self.topics.height;
    if (maxScale > 1) {
        scrollView.maximumZoomScale = maxScale;
        scrollView.delegate = self;
    }
    // Do any additional setup after loading the view from its nib.
}
#pragma mark -UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
- (PHAssetCollection *)createdCollection{
    NSString * title = [NSBundle mainBundle].infoDictionary[(__bridge NSString *)kCFBundleNameKey];
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 查找当前App对应的自定义相册
    for (PHAssetCollection * collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    /** 当前App对应的自定义相册没有被创建过 **/
    // 创建一个【自定义相册】
    NSError * error= nil;
    __block NSString * createdCollectionID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        createdCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    if (error) {
        return nil;
    }
    // 根据唯一标识获得刚才创建的相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionID] options:nil].firstObject;
}
- (PHFetchResult<PHAsset *> *)createdAssets{
    NSError * error = nil;
    __block NSString * assetID = nil;
    // 保存图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    if (error) {
        return nil;
    }
    // 获取刚才保存的相片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
}

- (IBAction)closeClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveClick:(UIButton *)sender {
    // 请求\检查访问权限 :
    // 如果用户还没有做出选择，会自动弹框，用户对弹框做出选择后，才会调用block
    // 如果之前已经做过选择，会直接执行block
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusDenied) {
            if (oldStatus != PHAuthorizationStatusNotDetermined) {// 用户拒绝当前App访问相册

                CJLog(@"提醒用户打开开关");
            }
        }else if(status == PHAuthorizationStatusAuthorized){// 用户允许当前App访问相册
            [self saveImageIntoAlbum];
        }else if (status == PHAuthorizationStatusRestricted){// 无法访问相册
            [SVProgressHUD showErrorWithStatus:@"因系统原因，无法访问相册！"];
        }
    }];
}
/**
 *  保存图片到相册
 */
- (void)saveImageIntoAlbum{
//    获得相片
    PHFetchResult <PHAsset *> * createdAssets = self.createdAssets;
    if (!createdAssets) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
        return;
    }
//    获得相册
    PHAssetCollection * createdCollection = self.createdCollection;
    if (!createdCollection) {
        [SVProgressHUD showErrorWithStatus:@"创建或者获取相册失败！"];
        return;
    }
//    添加刚才保存的图片到【自定义相册】
    NSError * error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        PHAssetCollectionChangeRequest * request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
        
    } error:&error];
//    最后判断
    if (error) {
        
        [SVProgressHUD showErrorWithStatus:@"保存图片失败！"];
        
    }else{
        
        [SVProgressHUD showSuccessWithStatus:@"保存图片成功！"];
        
            [self closeClick:nil];
       
    }
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

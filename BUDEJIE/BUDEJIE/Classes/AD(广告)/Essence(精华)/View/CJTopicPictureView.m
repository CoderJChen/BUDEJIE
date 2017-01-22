//
//  CJTopicPictureView.m
//  BUDEJIE
//
//  Created by eric on 17/1/12.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJTopicPictureView.h"
#import "CJTopic.h"
#import "CJSeeBigImageVC.h"
@interface CJTopicPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;

@end

@implementation CJTopicPictureView
- (IBAction)seeBigPictureButtonClick:(UIButton *)sender {
    [self seeBigPicture];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeBigPicture)]];
}
/**
 *  查看大图
 */
- (void)seeBigPicture{
    CJSeeBigImageVC * vc = [[CJSeeBigImageVC alloc]init];
    vc.topics = self.topics;
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
}
- (void)setTopics:(CJTopic *)topics{
    _topics = topics;
    self.placeholderView.hidden = NO;
    [self.imageView CJ_setOriginImage:topics.image1 thumbnailImage:topics.image0 placeholder:nil completion:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            return ;
        }
         self.placeholderView.hidden = YES;
        if (topics.isBigPicture) {
            // 处理超长图片的大小
            CGFloat imageW = topics.middleFrame.size.width;
            CGFloat imageH = imageW * topics.height/topics.width;
            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
            [self.imageView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }];
    self.gifView.hidden = !topics.is_gif;
    // 点击查看大图
    if (topics.isBigPicture) {
        // 处理超长图片的大小
        self.seeBigPictureButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    }else{
        
        self.seeBigPictureButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

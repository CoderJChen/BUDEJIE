//
//  CJTopicVideoView.m
//  BUDEJIE
//
//  Created by eric on 17/1/12.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJTopicVideoView.h"
#import "CJTopic.h"
#import "CJSeeBigImageVC.h"
@interface CJTopicVideoView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *videoPlayButton;

@end

@implementation CJTopicVideoView
- (IBAction)videoPlayButtonClick:(UIButton *)sender {
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
    }];
    // 播放数量
    if (topics.playcount >= 10000) {
        self.playcountLabel.text = [NSString stringWithFormat:@"%.1f万播放", topics.playcount / 10000.0];
    } else {
        self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topics.playcount];
    }
    // %04d : 占据4位，多余的空位用0填补
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topics.videotime / 60, topics.videotime % 60];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

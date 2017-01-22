//
//  CJTopicVoiceView.m
//  BUDEJIE
//
//  Created by eric on 17/1/12.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJTopicVoiceView.h"
#import "CJTopic.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "CJSeeBigImageVC.h"
@interface CJTopicVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;

@end

@implementation CJTopicVoiceView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.iconView.userInteractionEnabled = YES;
    [self.iconView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeBigPicture)]];
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
    [self.iconView CJ_setOriginImage:topics.image1 thumbnailImage:topics.image0 placeholder:nil completion:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            return ;
        }
        self.placeholderView.hidden = YES;
        
    }];
//    播放数量
    if (_topics.playcount >= 10000) {
        self.playcountLabel.text = [NSString stringWithFormat:@"%.1f万人播放",_topics.playcount / 10000.0];
    }else{
        self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放",_topics.playcount];
    }
//    %04d : 占据4位，多余的空位用0补充
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",_topics.voicetime/60, _topics.voicetime % 60];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

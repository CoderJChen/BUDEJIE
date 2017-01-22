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
#import <ZFPlayer.h>
#import "CJVideoVC.h"
@interface CJTopicVideoView ()<ZFPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *videoPlayButton;
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation CJTopicVideoView
- (ZFPlayerView *)playerView
{
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        // _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView
{
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}
#pragma mark - ZFPlayerDelegate

- (void)zf_playerDownload:(NSString *)url
{
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    NSString *name = [url lastPathComponent];
//    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
    // 设置最多同时下载个数（默认是3）
//    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
}

- (IBAction)videoPlayButtonClick:(UIButton *)sender {
//    ZFPlayerModel * playerModel = [[ZFPlayerModel alloc]init];
//    playerModel.title = self.topics.text;
//    playerModel.videoURL = [NSURL URLWithString:self.topics.videouri];
////    playerModel.placeholderImageURLString
//   CJVideoVC * video = [[CJVideoVC alloc]init];
//    playerModel.tableView = video.tableView;
////    playerModel.indexPath
//    playerModel.fatherView = self.placeholderView;
//    [self.playerView playerControlView:self.controlView playerModel:playerModel];
//    self.playerView.hasDownload = YES;
//    
//    [self.playerView autoPlayTheVideo];
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

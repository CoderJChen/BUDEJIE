//
//  CJTopicCell.m
//  BUDEJIE
//
//  Created by eric on 17/1/12.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJTopicCell.h"
#import <UIImageView+WebCache.h>
#import "CJTopicVideoView.h"
#import "CJTopicVoiceView.h"
#import "CJTopicPictureView.h"

@interface CJTopicCell()
// 控件的命名 -> 功能 + 控件类型
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;
/* 中间控件 */
/** 图片控件 */
@property (weak, nonatomic) CJTopicPictureView  * pictureView;
/** 声音控件*/
@property (weak, nonatomic) CJTopicVoiceView * voiceView;
//视频控件
@property (weak, nonatomic) CJTopicVideoView * videoView;

@end

@implementation CJTopicCell
- (CJTopicPictureView *)pictureView{
    if (!_pictureView) {
        CJTopicPictureView * pictureView = [CJTopicPictureView CJ_ViewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}
- (CJTopicVoiceView *)voiceView{
    if (_voiceView == nil) {
        CJTopicVoiceView * voiceView = [CJTopicVoiceView CJ_ViewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}
- (CJTopicVideoView *)videoView{
    if (_videoView == nil) {
        CJTopicVideoView * videoView =[CJTopicVideoView CJ_ViewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}
- (IBAction)moreBtnClick:(UIButton *)sender {
    CJLog(@"moreBtnClick");
}
- (IBAction)dingButtonClick:(UIButton *)sender {
    CJLog(@"dingButtonClick");
}
- (IBAction)caiButtonClick:(UIButton *)sender {
    CJLog(@"caiButtonClick");
}
- (IBAction)repostButtonClick:(id)sender {
    CJLog(@"repostButtonClick");
}
- (IBAction)commentButtonClick:(UIButton *)sender {
    CJLog(@"commentButtonClick");
}
- (void)setTopics:(CJTopic *)topics{
    _topics = topics;
//    顶部控件的数据
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:_topics.profile_image] placeholderImage:[UIImage CJ_circleImageName:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (!image) {
            return ;
        }
        self.profileImageView.image = [image CJ_circleImage];
    }];
    self.nameLabel.text = _topics.name;
    self.passtimeLabel.text = _topics.passtime;
    self.text_label.text = _topics.text;
    
//    底部按钮文字
    [self setButtonTitle:self.dingButton number:_topics.ding placeholder:@"顶"];
    [self setButtonTitle:self.caiButton number:_topics.cai placeholder:@"踩"];
    [self setButtonTitle:self.repostButton number:_topics.repost placeholder:@"分享"];
    [self setButtonTitle:self.commentButton number:_topics.comment placeholder:@"评论"];
//    最热评论
    if (topics.top_cmt.count) {//有最热评论
        self.topCmtView.hidden = NO;
        
        NSDictionary * cmt = topics.top_cmt.firstObject;
        NSString * content = cmt[@"content"];
        if(content.length == 0){//语音评论
            content = @"[语音评论]";
        }
        NSString * userName = cmt[@"user"][@"username"];
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@ : %@",userName,content];
    }else{//没有最热评论
        self.topCmtView.hidden = YES;
    }
//    中间内容

    if (topics.type == CJTopicTypePicture) {    //  图片
        self.pictureView.hidden = NO;
        self.pictureView.topics = topics;
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
    }else if (topics.type == CJTopicTypeVoice){  // 声音
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        self.voiceView.topics = topics;
        self.voiceView.hidden = NO;
    }else if (topics.type == CJTopicTypeVideo){  // 视频
        self.pictureView.hidden = YES;
        self.videoView.hidden = NO;
        self.videoView.topics = topics;
        self.voiceView.hidden = YES;
    }else if(topics.type == CJTopicTypeWord){    //段子
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
    }
}

/*
 报错信息：-[UIViewController _loadViewFromNibNamed:bundle:] loaded the "XMGVideoView" nib but the view outlet was not set.
 错误原因：在使用xib创建控制器view时，并没有通过File's Owner设置控制器的view属性
 解决方案：通过File's Owner设置控制器的view属性为某一个view
 
 报错信息：-[UITableViewController loadView] loaded the "XMGVideoView" nib but didn't get a UITableView.
 错误原因：在使用xib创建UITableViewController的view时，并没有设置控制器的view为一个UITableView
 解决方案：通过File's Owner设置控制器的view属性为一个UITableView
 */

/**
 *  设置按钮的文字
 *  @param number       按钮数字
 *  @param placeholder  数字为0时，默认用占位文字
 */
- (void)setButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder{
    
    if (number > 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万",number/10000.0] forState:UIControlStateNormal];
    }else if (number > 0){
        [button setTitle:[NSString stringWithFormat:@"%zd",number] forState:UIControlStateNormal];
    }else{
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
    
}
//设置分割线
- (void)setFrame:(CGRect)frame{
    frame.size.height -= CJMargin;
    [super setFrame:frame];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    // Initialization code
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
//    CJLog(@"%@",NSStringFromCGRect(self.topics.middleFrame));
    
    if (self.topics.type == CJTopicTypePicture) {
        
        self.pictureView.frame = self.topics.middleFrame;
        
    }else if (self.topics.type == CJTopicTypeVideo){
        
        self.videoView.frame = self.topics.middleFrame;
        
    }else if (self.topics.type == CJTopicTypeVoice){
        
        self.voiceView.frame = self.topics.middleFrame;
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

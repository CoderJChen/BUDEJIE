//
//  CJCommentCell.m
//  BUDEJIE
//
//  Created by eric on 17/1/16.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJCommentCell.h"
#import "CJComment.h"
#import "CJUser.h"
@interface CJCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@end

@implementation CJCommentCell
- (IBAction)likeClick:(UIButton *)sender {
}
-(void)setComment:(CJComment *)comment{
    _comment = comment;
    
    if (comment.voiceuri.length) {
        
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''",comment.voicetime] forState:UIControlStateNormal];
        
    }else{
        self.voiceButton.hidden = YES;
    }
    [self.profileImageView CJ_setHeader:comment.user.profile_image];
    self.contentLabel.text = comment.content;
    self.userNameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    if ([comment.user.sex isEqualToString:CJUserSexMale]) {
        self.sexView.image = [UIImage imageNamed:@"Profile_manIcon"];
    }else{
        self.sexView.image = [UIImage imageNamed:@"Profile_womanIcon"];
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

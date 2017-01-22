//
//  CJUserCell.m
//  BUDEJIE
//
//  Created by eric on 17/1/17.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJUserCell.h"
#import "CJFollowUser.h"
@interface CJUserCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;


@end

@implementation CJUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setUsers:(CJFollowUser *)users{
    _users = users;
    
    [self.headerImageView CJ_setHeader:users.header];
    
    self.screenNameLabel.text = users.screen_name;
    if (users.fans_count >= 1000) {
        self.fansCountLabel.text = [NSString stringWithFormat:@"%.1f万人关注",users.fans_count / 10000.0];
    }else{
        self.fansCountLabel.text = [NSString stringWithFormat:@"%zd人关注",users.fans_count];
    }
}

@end

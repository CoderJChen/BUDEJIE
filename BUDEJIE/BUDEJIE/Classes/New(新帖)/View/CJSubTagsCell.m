//
//  CJSubTagsCell.m
//  BUDEJIE
//
//  Created by eric on 17/1/10.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJSubTagsCell.h"
#import "UIImageView+WebCache.h"
@interface CJSubTagsCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numView;
@property (weak, nonatomic) IBOutlet UIButton *subscriptionBtn;

@end

@implementation CJSubTagsCell
/*
 头像变成圆角 1.设置头像圆角 2.裁剪图片(生成新的图片 -> 图形上下文才能够生成新图片)
 处理数字
 */
- (void)setItem:(CJSubTagItem *)item{
    _item = item;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:item.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        开启上下文
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
        UIBezierPath * bezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        [bezier addClip];
        [image drawAtPoint:CGPointZero];
        image = UIGraphicsGetImageFromCurrentImageContext();
        _iconView.image = image;
    }];
    self.nameLabel.text = item.theme_name;
    [self resolveNum];
    
}
- (void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    // 才是真正去给cell赋值
    [super setFrame:frame];
}
- (void)resolveNum{
    NSString * numStr = [NSString stringWithFormat:@"%@人订阅",_item.sub_number];
    NSUInteger num = _item.sub_number.integerValue;
    if (num > 10000) {
        CGFloat number = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f万人订阅",number];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    self.numView.text = numStr;
    
}
// 从xib加载就会调用一次
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)subscriptionClick:(id)sender {
}

@end

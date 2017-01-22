//
//  CJSquareCell.m
//  BUDEJIE
//
//  Created by eric on 17/1/11.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJSquareCell.h"
#import <UIImageView+WebCache.h>
@interface CJSquareCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameView;

@end

@implementation CJSquareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setItems:(CJSquareItem *)items{
    _items = items;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:items.icon]];
    _nameView.text = _items.name;
}
@end

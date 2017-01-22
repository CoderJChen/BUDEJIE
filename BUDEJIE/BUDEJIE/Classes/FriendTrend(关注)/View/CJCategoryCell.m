//
//  CJCategoryCell.m
//  BUDEJIE
//
//  Created by eric on 17/1/17.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJCategoryCell.h"
#import "CJFollowCategory.h"
@interface CJCategoryCell()
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;
@end

@implementation CJCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.backgroundColor = [UIColor clearColor];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.textLabel.textColor = selected ? [UIColor redColor] : [UIColor darkGrayColor];
    self.selectedIndicator.hidden = !selected;
    
}
- (void)setCategory:(CJFollowCategory *)category{
    _category = category;
    self.textLabel.text = category.name;
}
@end

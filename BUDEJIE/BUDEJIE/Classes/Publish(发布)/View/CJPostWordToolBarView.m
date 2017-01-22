//
//  CJPostWordToolBarView.m
//  BUDEJIE
//
//  Created by eric on 17/1/13.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJPostWordToolBarView.h"
#import "CJAddTagVC.h"
#import "CJNavigationVC.h"
@interface CJPostWordToolBarView()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
//所有的标签label
@property (strong, nonatomic) NSMutableArray * tagLabels;
//加号按钮
@property (weak, nonatomic) UIButton * addButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *emotionButton;

@end

@implementation CJPostWordToolBarView
- (NSMutableArray *)tagLabels{
    if (_tagLabels == nil) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (IBAction)toolBarClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(composeTool:buttonType:)]) {
        [self.delegate composeTool:self buttonType:sender.tag-10];
    }
}
- (void)setShowKeyboardButton:(BOOL)showKeyboardButton{
    _showKeyboardButton = showKeyboardButton;
    NSString *highImage = @"compose_emoticonbutton_background_highlighted";
    NSString *image = @"compose_emoticonbutton_background";
    
    if (showKeyboardButton) {
        image = @"compose_keyboardbutton_background";
        highImage = @"compose_keyboardbutton_background_highlighted";
    }
    [self.emotionButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
}
-(void)awakeFromNib{
    [super awakeFromNib];

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:button];
    _addButton = button;
//    默认传递两个标签
    [self createTagLabels:@[@"吐槽", @"糗事"]];
}
- (void)addClick{
    CJWeakSelf;
    CJAddTagVC * tagVC = [[CJAddTagVC alloc]init];
    
    tagVC.getTagsBlock = ^(NSArray * tags){
        [weakSelf createTagLabels:tags];
    };
    tagVC.tags = [self.tagLabels valueForKeyPath:@"text"];
    
    // 拿到"窗口根控制器"曾经modal出来的“发表文字”所在的导航控制器
    CJNavigationVC * navigation = [[CJNavigationVC alloc]initWithRootViewController:tagVC];
    [self.window.rootViewController.presentedViewController presentViewController:navigation animated:YES completion:nil];
    
}
//创建标签label
- (void)createTagLabels:(NSArray *)tags{
//    移除所有的label
//    让self.tagsLabels数组中的所有对象执行removeFromSuperview
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
//    所有的标签label
    for (int i = 0; i < tags.count; i++) {
//        创建label
        UILabel * newTagsLabel = [[UILabel alloc]init];
        newTagsLabel.text = tags[i];
        newTagsLabel.font = [UIFont systemFontOfSize:14.0];
        newTagsLabel.backgroundColor = CJTagBgColor;
        newTagsLabel.textColor = [UIColor whiteColor];
        newTagsLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:newTagsLabel];
        [self.tagLabels addObject:newTagsLabel];
//        尺寸
        [newTagsLabel sizeToFit];
        newTagsLabel.height = CJTagH;
        newTagsLabel.width += 2 * CJCommonSmallMargin;
    }
//    //重新布局子控件
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    for (int i = 0; i < self.tagLabels.count; i++) {
//        创建label
        UILabel * newTagLabel = self.tagLabels[i];
//        位置
        if (i == 0) {
            newTagLabel.x = 0;
            newTagLabel.y = 0;
        }else{
            UILabel * previousLabel = self.tagLabels[i - 1];
            CGFloat leftWidth = CGRectGetMaxX(previousLabel.frame) + CJCommonSmallMargin;
            CGFloat rightWidth = CJScreenW - leftWidth;
            if (rightWidth >= newTagLabel.width) {
                newTagLabel.x = leftWidth;
                newTagLabel.y = previousLabel.y;
            }else{
                newTagLabel.x = 0;
                newTagLabel.y = CGRectGetMaxY(previousLabel.frame) + CJCommonSmallMargin;
            }
        }
    }
//    ➕标签
    UILabel * lastTagLabel = self.tagLabels.lastObject;
    if (lastTagLabel) {
        CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + CJCommonSmallMargin;
        CGFloat rightWidth = CJScreenW - leftWidth;
        if (rightWidth >= self.addButton.width) {
            self.addButton.x = leftWidth;
            self.addButton.y = lastTagLabel.y;
        }else{
            self.addButton.x = 0;
            self.addButton.y = CGRectGetMaxY(lastTagLabel.frame) + CJCommonSmallMargin;
        }
    }else{
        self.addButton.x = 0;
        self.addButton.y = 0;
    }
//    计算工具条的高度
    self.topViewHeight.constant = CGRectGetMaxY(self.addButton.frame);
    CGFloat oldHeight = self.height;
    self.height = self.topViewHeight.constant + self.bottomView.height + CJCommonSmallMargin;
    self.y += oldHeight - self.height;
    
}
                                                                                                                                                                                                                                                                                                                                                                             
@end

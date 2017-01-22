//
//  CJAddTagVC.m
//  BUDEJIE
//
//  Created by eric on 17/1/13.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJAddTagVC.h"
#import <SVProgressHUD.h>
#import "CJTagButton.h"
#import "CJTagTextField.h"
@interface CJAddTagVC ()<UITextFieldDelegate>
/** 用来容纳所有按钮和文本框 */
@property (nonatomic, weak) UIView * contentView;
/** 文本框 */
@property (nonatomic, weak) CJTagTextField * textField;
/** 提醒按钮 */
@property (nonatomic, weak) CJTagButton * tipButton;
/** 存放所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagButtons;
@end

@implementation CJAddTagVC
- (NSMutableArray *)tagButtons{
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}
- (CJTagButton *)tipButton{
    if (!_tipButton) {
        // 创建一个提醒按钮
        CJTagButton *tipButton = [CJTagButton buttonWithType:UIButtonTypeCustom];
        [tipButton addTarget:self action:@selector(tipClick) forControlEvents:UIControlEventTouchUpInside];
        tipButton.width = self.contentView.width;
        tipButton.height = CJTagH;
        tipButton.x = 0;
        tipButton.backgroundColor = CJTagBgColor;
        tipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        tipButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        tipButton.contentEdgeInsets = UIEdgeInsetsMake(0, CJCommonSmallMargin, 0, 0);
        [self.contentView addSubview:tipButton];
        _tipButton = tipButton;
    }
    return _tipButton;
}
- (void)setupNav{
    self.title = @"添加标签";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    
    [self setupContentView];
    
    [self setupTextField];
    
    [self setupTags];
    
    // Do any additional setup after loading the view.
}
- (void)setupTags{

    for (NSString * tag in self.tags) {
        self.textField.text = tag;
        [self tipClick];
    }
}
- (void)setupContentView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.x = CJCommonSmallMargin;
    contentView.y = CJNavMaxY + CJCommonSmallMargin;
    contentView.width = self.view.width - 2 * contentView.x;
    contentView.height = self.view.height;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)setupTextField
{
    
    CJTagTextField *textField = [[CJTagTextField alloc] init];
    [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    textField.width = self.contentView.width;
    textField.height = CJTagH;
    // 设置占位文字
    textField.placeholderColor = [UIColor grayColor];
    textField.placeholder = @"多个标签用逗号或者换行隔开";
    textField.delegate = self;
    [self.contentView addSubview:textField];
    [textField becomeFirstResponder];
    // 刷新的前提：这个控件已经被添加到父控件
    [textField layoutIfNeeded];
    self.textField = textField;
    
    CJWeakSelf;
    // 设置点击删除键需要执行的操作
    textField.deleteBackwardOperation = ^{
//         判断文本框是否有文字
        if (weakSelf.textField.hasText || weakSelf.tagButtons.count == 0) return;
        
//         点击了最后一个标签按钮（删掉最后一个标签按钮）
        [weakSelf tagClick:weakSelf.tagButtons.lastObject];
    };
    // stackoverflow
}

#pragma mark - 监听
/**
 监听textField的文字改变
 */
- (void)textDidChange
{
//    提醒按钮
    if (self.textField.hasText) {
        NSString * text = self.textField.text;
        NSString * lastStr = [text substringFromIndex:text.length-1];
//        最后输出的字符是逗号
        if ([lastStr isEqualToString:@","] || [lastStr isEqualToString:@"，"]) {
//            去掉文本框最后一个逗号
            [self.textField deleteBackward];
//            点击提醒按钮
            [self tipClick];
        }else{
//            最后一个输入的字符不是逗号
//            排布文本框
            [self setupTextFieldFrame];
            self.tipButton.hidden = NO;
            [self.tipButton setTitle:[NSString stringWithFormat:@"添加标签：%@", text] forState:UIControlStateNormal];
        }
    }else{
        self.tipButton.hidden = YES;
    }
}

/**
 点击了提醒按钮
 */
- (void)tipClick
{
    if (self.textField.hasText == NO) return;
    
    if (self.tagButtons.count == 5) {
        [SVProgressHUD showErrorWithStatus:@"最多添加5个标签"];
        return;
    }
    
    // 创建一个标签按钮
    CJTagButton *newTagButton = [CJTagButton buttonWithType:UIButtonTypeCustom];
    [newTagButton setTitle:self.textField.text forState:UIControlStateNormal];
    [newTagButton addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:newTagButton];
    
    // 设置位置 - 参照最后一个标签按钮
    [self setupTagButtonFrame:newTagButton referenceTagButton:self.tagButtons.lastObject];
    
    // 添加到数组中
    [self.tagButtons addObject:newTagButton];
    
    // 排布文本框
    self.textField.text = nil;
    [self setupTextFieldFrame];
    
    // 隐藏提醒按钮
    self.tipButton.hidden = YES;
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done
{
    // 1.传递标签数据回到上一个界面
//        NSMutableArray *tags = [NSMutableArray array];
//        for (CJTagButton *tagButton in self.tagButtons) {
//            [tags addObject:tagButton.currentTitle];
//        }
    // 将self.tagButtons中存放的所有对象的currentTitle属性值取出来，放到一个新的数组中，并返回
    NSArray *tags = [self.tagButtons valueForKeyPath:@"currentTitle"];
    !self.getTagsBlock ? : self.getTagsBlock(tags);
    
    // 2.关闭当前控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 点击了标签按钮
 */
- (void)tagClick:(UIButton *)clickedTagButton
{
    // 即将被删除的标签按钮的索引
    NSUInteger index = [self.tagButtons indexOfObject:clickedTagButton];
    
    // 删除按钮
    [clickedTagButton removeFromSuperview];
    [self.tagButtons removeObject:clickedTagButton];
    
    // 处理后面的标签按钮
    for (NSUInteger i = index; i < self.tagButtons.count; i++) {
        UIButton *tagButton = self.tagButtons[i];
        // 如果i不为0，就参照上一个标签按钮
        UIButton *previousTagButton = (i == 0) ? nil : self.tagButtons[i - 1];
        [self setupTagButtonFrame:tagButton referenceTagButton:previousTagButton];
    }
    
    // 排布文本框
    [self setupTextFieldFrame];
}

#pragma mark - 设置控件的frame
/**
 * 设置标签按钮的frame
 * @param tagButton 需要设置frame的标签按钮
 * @param referenceTagButton 计算tagButton的frame时参照的标签按钮
 */
- (void)setupTagButtonFrame:(UIButton *)tagButton referenceTagButton:(UIButton *)referenceTagButton
{
    // 没有参照按钮（tagButton是第一个标签按钮）
    if (referenceTagButton == nil) {
        tagButton.x = 0;
        tagButton.y = 0;
        return;
    }
//    tagButton不是第一个标签按钮
    CGFloat leftWidth = CGRectGetMaxX(referenceTagButton.frame) + CJCommonSmallMargin;
    CGFloat rightWidth  = self.contentView.width - leftWidth;
    if (rightWidth >= tagButton.width) {
         // 跟上一个标签按钮处在同一行
        tagButton.x = leftWidth;
        tagButton.y = referenceTagButton.y;
    }else{
        // 下一行
        tagButton.x = 0;
        tagButton.y = CGRectGetMaxY(referenceTagButton.frame) + CJCommonSmallMargin;
    }

}
//设置textField的frame
- (void)setupTextFieldFrame
{
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName:self.textField.font}].width;
    
    textW = MAX(100, textW);
    
    UIButton * lastTagButton = self.tagButtons.lastObject;
    
    if (lastTagButton) {
        
        CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + CJCommonSmallMargin;
        CGFloat rightWidth = self.contentView.width - leftWidth;
        
        if (rightWidth >= textW) {
            
            self.textField.x = leftWidth;
            self.textField.y = lastTagButton.y;
            
        }else{
            
            self.textField.x = 0;
            self.textField.y = CGRectGetMaxY(lastTagButton.frame) + CJCommonSmallMargin;
        }
        
    }else{
        self.textField.x = 0;
        self.textField.y = 0;
    }
    // 排布提醒按钮
    self.tipButton.y = CGRectGetMaxY(self.textField.frame) + CJCommonSmallMargin;
}

#pragma mark - <UITextFieldDelegate>
/**
 点击右下角return按钮就会调用这个方法
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self tipClick];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

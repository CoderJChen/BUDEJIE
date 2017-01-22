//
//  CJComposeVC.m
//  BUDEJIE
//
//  Created by eric on 17/1/19.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJComposeVC.h"
#import "CJEmotionTextView.h"
#import "CJPostWordToolBarView.h"
#import "CJEmotionKeyboardView.h"
#import "UIView+Extention.h"

@interface CJComposeVC ()<UITextViewDelegate,CJPostWordToolBarViewDelegate>
//文本框
@property (weak, nonatomic) CJEmotionTextView * textView;
@property (weak, nonatomic) CJPostWordToolBarView * toolBarView;
@property (strong, nonatomic) CJEmotionKeyboardView * keyboardView;
@property(assign,nonatomic,getter = isSwitchingKeyboard) BOOL switchingKeybaord;
@end

@implementation CJComposeVC
- (CJEmotionKeyboardView *)keyboardView{
    if (!_keyboardView) {
        CJEmotionKeyboardView * keyboard = [[CJEmotionKeyboardView alloc]init];
        keyboard.height = 216;
        keyboard.width = self.view.width;
        
        _keyboardView = keyboard;
    }
    return _keyboardView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    [self setupTextView];
    [self setupTooBar];
    // Do any additional setup after loading the view.
}
- (void)setupNav{
    self.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // 强制更新(能马上刷新现在的状态)
    [self.navigationController.navigationBar layoutIfNeeded];
}
- (void)setupTextView{
    
    CJEmotionTextView * textView = [[CJEmotionTextView alloc]init];
    textView.frame = self.view.bounds;
    //    不管内容有多少，竖直方向永远可以拖拽
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    [self.view addSubview:textView];
    self.textView = textView;
    //   监听键盘位置的改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //    监听添加表情
    [CJNotificationCenter addObserver:self selector:@selector(emotionDidSelect:) name:CJEmotionDidSelectNotification object:nil];
    //    监听删除按钮
    [CJNotificationCenter addObserver:self selector:@selector(emotionDidDelete:) name:CJEmotionDidDeleteNotification object:nil];
}
- (void)emotionDidSelect:(NSNotification *)notification{
    CJEmotionModel * emotion = notification.userInfo[CJSelectEmotionKey];
    [self.textView insertEmotion:emotion];
}
- (void)emotionDidDelete:(NSNotification *)notification{
    [self.textView deleteBackward];
}
- (void)setupTooBar{
    
    CJPostWordToolBarView * toolBar = [CJPostWordToolBarView CJ_ViewFromXib];
    toolBar.x = 0;
    toolBar.delegate = self;
    toolBar.y = self.view.height - toolBar.height;
    toolBar.width = self.view.width;
    [self.view addSubview:toolBar];
    self.toolBarView = toolBar;
 
}
#pragma mark - CJPostWordToolBarViewDelegate
- (void)composeTool:(CJPostWordToolBarView *)toolBar buttonType:(CJComposeToolbarButtonType)type{
    switch (type) {
        case CJComposeToolbarButtonTypeCamera:
            
            break;
        case CJComposeToolbarButtonTypePicture:
            break;
        case CJComposeToolbarButtonTypeEmotion:
            [self clickSwitchKeyBoard];
            break;
        case CJComposeToolbarButtonTypeMention:
            break;
        case CJComposeToolbarButtonTypeTrend:
            break;
        default:
            break;
    }
}
- (void)clickSwitchKeyBoard{
    
    if (self.textView.inputView == nil) {
        self.textView.inputView = self.keyboardView;
        self.toolBarView.showKeyboardButton = YES;
    }else{
        self.textView.inputView = nil;
        self.toolBarView.showKeyboardButton = NO;
    }
    self.switchingKeybaord = YES;
    [self.textView endEditing:YES];
    self.switchingKeybaord = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
}
#pragma mark - 监听键盘移动frame变化
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    if (self.isSwitchingKeyboard) {
        return;
    }
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        // 工具条平移的距离 == 键盘最终的Y值 - 屏幕高度
        CGFloat ty = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y - CJScreenH;
        self.toolBarView.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
}
#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)post{
    CJFUNC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

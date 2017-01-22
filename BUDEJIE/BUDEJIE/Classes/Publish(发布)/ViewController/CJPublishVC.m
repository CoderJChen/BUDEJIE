//
//  CJPublishVC.m
//  百思不得其解
//
//  Created by eric on 17/1/4.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJPublishVC.h"
#import <pop/POP.h>
#import "CJFastButton.h"
#import "CJComposeVC.h"
#import "CJNavigationVC.h"
static CGFloat const CJSpringFactor = 10;
@interface CJPublishVC ()
@property (weak, nonatomic) IBOutlet UIImageView *shareIcon;
//标语
@property (weak, nonatomic) UIImageView * sloganView;
//按钮
@property (strong, nonatomic) NSMutableArray * buttons;
//动画
@property (strong, nonatomic) NSArray * times;

@end

@implementation CJPublishVC
#pragma mark -懒加载
- (NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
- (NSArray *)times{
    if (!_times) {
        CGFloat interval = 0.1;//时间间隔
        _times = @[
                   @(5 * interval),
                   @(4 * interval),
                   @(3 * interval),
                   @(2 * interval),
                   @(0 * interval),
                   @(1 * interval),
                   @(6 * interval)//标语的动画时间
                   ];
    }
    return _times;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    禁止交互
    self.view.userInteractionEnabled = NO;
//    按钮
    [self setupButtons];
//    标语
    [self setupSloganView];
    
    // Do any additional setup after loading the view.
}
- (void)setupButtons{
//    数据
    NSArray * images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    
    NSArray * titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
//    一些参数
    NSUInteger count = images.count;
    
    int maxColCount = 3;//一行的列数
//    行数
    NSUInteger rowsCount = (count - 1)/maxColCount + 1;
//    按钮的尺寸
    CGFloat buttonW = CJScreenW / maxColCount;
    CGFloat buttonH = buttonW * 0.85;
    CGFloat buttonStartY = (CJScreenH - rowsCount * buttonH) * 0.5;
    
    for (int i = 0; i < count; i++) {
//        创建、添加
        CJFastButton * button = [CJFastButton buttonWithType:UIButtonTypeCustom];
        button.width = -1;// 按钮的尺寸为0，还是能看见文字缩成一个点，设置按钮的尺寸为负数，那么就看不见文字了
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
        [self.view addSubview:button];
        
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        
//        frame
        CGFloat buttonX = (i % maxColCount) * buttonW;
        CGFloat buttonY = buttonStartY + (i / maxColCount) * buttonH;
//       动画
        POPSpringAnimation * animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY - CJScreenH, buttonW, buttonH)];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        
        animation.springSpeed = CJSpringFactor;
        animation.springBounciness = CJSpringFactor;
//        CACurrentMediaTime()获得当前的时间
        animation.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
        [button pop_addAnimation:animation forKey:nil];
    }
}
- (void)setupSloganView{
    
    CGFloat sloganY = CJScreenH * 0.2;
    UIImageView * sloganView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"app_slogan"]];
    sloganView.y = sloganY - CJScreenH;
    sloganView.centerX = CJScreenW * 0.5;
    [self.view addSubview:sloganView];
    self.sloganView = sloganView;
    CJWeakSelf;
    
    POPSpringAnimation * animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    
    animation.toValue = @(sloganY);
    
    animation.springSpeed = CJSpringFactor;
    animation.springBounciness = CJSpringFactor;
    
    animation.beginTime = CACurrentMediaTime() + [self.times.lastObject doubleValue];
    [animation setCompletionBlock:^(POPAnimation * anim, BOOL finished) {
//        开始交互
        weakSelf.view.userInteractionEnabled = YES;
    }];
    [sloganView.layer pop_addAnimation:animation forKey:nil];
}

- (void)exit:(void(^)())task{
//    禁止交互
    self.view.userInteractionEnabled = NO;
//    让按钮执行动画
    for (int i = 0; i < self.buttons.count; i++) {
        
        CJFastButton * button = self.buttons[i];
        
        POPBasicAnimation * animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        
        animation.toValue = @(button.layer.position.y + CJScreenH);
        animation.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
        
        [button.layer pop_addAnimation:animation forKey:nil];
    }
    CJWeakSelf;
//    让标题执行动画
    POPBasicAnimation * anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.toValue = @(self.sloganView.layer.position.y + CJScreenH);
    // CACurrentMediaTime()获得的是当前时间
    anim.beginTime = CACurrentMediaTime() + [self.times.lastObject doubleValue];
    
    [anim setCompletionBlock:^(POPAnimation * anim, BOOL finished) {
//
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
//        if (task) {
//            task();
//        }
//        可能会执行其他的事情
        !task ? :task();
    }];
    
    [self.sloganView.layer pop_addAnimation:anim forKey:nil];
    
}
#pragma mark - 点击
- (void)buttonClick:(CJFastButton *)button{
    [self exit:^{
//        按钮索引
        NSUInteger index = [self.buttons indexOfObject:button];
        switch (index) {
            case 2:
            {
                CJComposeVC * post = [[CJComposeVC alloc]init];
                CJNavigationVC * navigation = [[CJNavigationVC alloc]initWithRootViewController:post];
                [self.view.window.rootViewController presentViewController:navigation animated:YES completion:nil];
                break;
            }
             case 0:
                CJLog(@"发视屏");
                break;
            case 1:
                CJLog(@"发图片");
                break;
            default:
                CJLog(@"其它");
                break;
        }
    }];
}
- (IBAction)cancel:(UIButton *)sender {
    [self exit:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self exit:nil];
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

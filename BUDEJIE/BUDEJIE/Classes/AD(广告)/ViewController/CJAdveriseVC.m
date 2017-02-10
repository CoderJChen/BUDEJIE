//
//  CJAdveriseVC.m
//  BUDEJIE
//
//  Created by eric on 17/1/10.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJAdveriseVC.h"
#import <AFNetworking/AFNetworking.h>
#import "CJTabBarVC.h"
#import "CJADItem.h"
#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>

#define code @"phcqnauguhykfmrquanhmgn_iaubthfqmgksuarhiwdgulpxnz3vndtkqw08nau_i1y1p1rhmhwz5hb8nbul5hdknwrhta_qmvqvqhgguhi_py4mqhf1tvchmgky5h6hmypw5rfrhzuet1dgulnhuan85hchuy7s5hdhiywgujy3p1n3mwb1pvdlnvf-pyf4mhr4nyrvmwpbmhwbpjclpyfspht3uwm4fmplphykfh7sta-b5yrzpj6spvrdfhpdtwysfmkzuykemyfqnauguau95rnsnbfknbm1qhnkww6vpjujnbdkfwd1qhnsnbrsnhwkfywawiu9mlfqhbd_h70htv6qnhn1pauvmynqnjclnj0lnj0lnj0lnj0lnj0hthyqniuvujykfhkc5hrvnb3dfh7spyfqnw0srj64nbu9tjysfmub5hdhtzfeujdztlk_mgpcfmp85rnsnbfknbm1qhnkww6vpjujnbdkfwd1qhnsnbrsnhwkfywawiubnhfdnjd4rjnvpwykfh7stzu-twy1qw68nbuwuhydnhchiayqphdzfhqsmypgizbqniuythuytjd1uavxnz3vnzu9ijyzfh6qp1rsfmws5y-fpaq8uht_nbuymycqnau1ijykpjrsnhb3n1mvnhdkqwd4niuvmybqniu1uy3qwd-hqdfkhakhhnn_hr7fq7udq7pchzkhir3_ryqnqd7jfzkpirn_wdkhqdp5hikpfrb_fnc_nbwpqddrhzkdinchtvww5hnvpj0zqwndnhrvnbsdpwb4ri3kpw0kphmhmlnqph6lp1ndm1-wpydvnhkbraw9nju9phihmh9wmh6zrjrhtv7_5iu85hdhtvd15hdhtltqp1rsfh4etjyypw0spzuvuyyqn1mynjc8nwbvrjtdqjrvrhb4qwdvnjddpbuk5yrzpj6spvrdgvpstbu_my4btvp9tarqnam"
/*
 1.广告业务逻辑
 2.占位视图思想:有个控件不确定尺寸,但是层次结构已经确定,就可以使用占位视图思想
 3.屏幕适配.通过屏幕高度判断
 */
@interface CJAdveriseVC ()
@property (weak, nonatomic) IBOutlet UIImageView *launchImage;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
@property (weak, nonatomic) UIImageView * adView;
@property (weak, nonatomic) NSTimer * timer;
@property (weak, nonatomic) CJADItem * item;
@property (weak, nonatomic) IBOutlet UIView *adContainView;

@end

@implementation CJAdveriseVC
- (UIImageView *)adView{
    if (_adView == nil) {
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        [self.adContainView addSubview:imageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [imageView addGestureRecognizer:tap];
        
        _adView = imageView;
    }
    return _adView;
}
// 点击广告界面调用
- (void)tap{
//    跳转到界面
    NSURL * url = [NSURL URLWithString:_item.ori_curl];
    UIApplication * app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app canOpenURL:url];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLaunchImage];
     // 加载广告数据 => 拿到活时间 => 服务器 => 查看接口文档 1.判断接口对不对 2.解析数据(w_picurl,ori_curl:跳转到广告界面,w,h) => 请求数据(AFN)
    [self loadAdveriseData];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerChange) userInfo:nil repeats:YES];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)timerChange{
    static int i = 3;
    if (i == 0) {
        [self jumpClick:nil];
    }
    i--;
    [self.jumpBtn setTitle:[NSString stringWithFormat:@"跳转(%ds)",i] forState:UIControlStateNormal];
}
- (void)loadAdveriseData{
//    1、创建请求会话管理者
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    2、拼接参数
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"code2"] = code;
//    3、发送请求
    [manager GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        请求数据 -> 解析数据（写成plist文件）-> 设计模型 -> 字典转模型 -> 展示数据
//        获取字典
        NSDictionary * adDict = [responseObject[@"ad"] lastObject];
        
//        字典转模型
        _item = [CJADItem mj_objectWithKeyValues:adDict];
//        创建UIImageView展示图片
        CGFloat h = CJScreenW / _item.w * _item.h;
        self.adView.frame = CGRectMake(0, 0, CJScreenW, h);
//        加载广告网页
        [self.adView sd_setImageWithURL:[NSURL URLWithString:_item.w_picurl]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CJLog(@"%@",error.localizedDescription);
    }];
   }
//点击跳转做的事情
- (IBAction)jumpClick:(id)sender {
//    销毁广告界面，进入主框架界面
    CJTabBarVC * tabBarVC = [[CJTabBarVC alloc]init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
//    干掉定时器
    [_timer invalidate];
}
- (void)setUpLaunchImage{
    
    if (iphone6P) {
        self.launchImage.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    }else if (iphone6){
        self.launchImage.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    }else if (iphone5){
        self.launchImage.image = [UIImage imageNamed:@"LaunchImage-568h"];
    }else if(iphone4){
        self.launchImage.image = [UIImage imageNamed:@"LaunchImage-700"];
    }
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

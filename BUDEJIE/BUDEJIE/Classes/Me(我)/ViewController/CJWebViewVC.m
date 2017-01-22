//
//  CJWebViewVC.m
//  BUDEJIE
//
//  Created by eric on 17/1/11.
//  Copyright © 2017年 eric. All rights reserved.
//

#import "CJWebViewVC.h"
#import <WebKit/WebKit.h>
@interface CJWebViewVC ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property(weak, nonatomic) WKWebView * webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwordItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;



@end

@implementation CJWebViewVC
- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}
- (IBAction)goForword:(id)sender {
    [self.webView goForward];
}
- (IBAction)goRefresh:(id)sender {
    [self.webView reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebView * webView = [[WKWebView alloc]init];
    [self.contentView addSubview:webView];
    NSURLRequest * request = [NSURLRequest requestWithURL:self.url];
    [webView loadRequest:request];
    _webView = webView;
    
    // KVO监听属性改变
    /*
     Observer:观察者
     KeyPath:观察webView哪个属性
     options:NSKeyValueObservingOptionNew:观察新值改变
     
     KVO注意点.一定要记得移除
     */
    [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"canGoForWord" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
//    进度条
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    // Do any additional setup after loading the view.
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    self.backItem.enabled = self.webView.canGoBack;
    self.forwordItem.enabled = self.webView.canGoForward;
    self.title = self.webView.title;
    self.progressView.progress = self.webView.estimatedProgress;
    self.progressView.hidden = self.webView.estimatedProgress >= 1;
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _webView.frame = self.contentView.bounds;
}
- (void)dealloc{
    [_webView removeObserver:self forKeyPath:@"canGoBack"];
    [_webView removeObserver:self forKeyPath:@"canGoForWord"];
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
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

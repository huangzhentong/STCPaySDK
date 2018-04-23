//
//  PayWebViewController.m
//  Pods
//
//  Created by KT--stc08 on 2018/4/23.
//

#import "STCPayWebViewController.h"
#import <WebKit/WebKit.h>
#import "STCWKWebViewPanelManager.h"
#import "UIImage+LoadWithBundle.h"
#import "STCThirdSDKManager.h"
#import "STCPayManager.h"
@interface STCPayWebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong)WKWebView *webView;

@property (nonatomic)UIButton* customBackButton;
@property(nonatomic)UIButton *closeButton;
@property(nonatomic)BOOL isNaviHidden;
@property(nonatomic,copy)NSBundle *bundle;

@end

@implementation STCPayWebViewController
-(instancetype)initWithObject:(id)object
{
    self = [super init];
    if (self) {
        if ([object isKindOfClass:[NSString class]]) {
            self.url = object;
        }
        else if ([object isKindOfClass:[NSDictionary class]])
        {
            self.url  = [object objectForKey:@"url"];
            
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.navigationItem.leftBarButtonItem  = nil;
    self.isNaviHidden = self.navigationController.navigationBarHidden;
    // Do any additional setup after loading the view.
}

-(NSBundle*)bundle
{
    if (!_bundle) {
//        _bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"Res" ofType:@"bundle"]];

       NSBundle *bundle =  [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle.resourcePath stringByAppendingString:@"/Res.bundle"];
        _bundle = [NSBundle bundleWithPath:path];
        
    }
    return _bundle;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = self.isNaviHidden;
}
-(void)setupUI
{
    [self.view addSubview:self.webView];
    self.navigationItem.hidesBackButton = YES;
    self.webView.frame = self.view.bounds;

    if (self.url!=nil) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
    [self.customBackButton setImage:[UIImage imageWithBundle:self.bundle withName:@"nav_return"] forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}
-(UIButton*)customBackButton{
    
    if (!_customBackButton) {
        
        _customBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_customBackButton setImage:[UIImage imageWithBundle:self.bundle withName:@"nav_return"] forState:UIControlStateNormal];
        _customBackButton.frame=CGRectMake(0, 0, 40, 30);
        [_customBackButton addTarget:self action:@selector(goBackBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:_customBackButton];
    }
    
    return _customBackButton;
}
-(UIButton*)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageWithBundle:self.bundle withName:@"nav_close"] forState:UIControlStateNormal];
        _closeButton.frame=CGRectMake(40, 0, 40, 30);
        [_closeButton addTarget:self action:@selector(closeBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:_closeButton];
        
    }
    
    return _closeButton;
}
- (WKWebView*)webView
{
    if (!_webView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        config.preferences = [[WKPreferences alloc] init];
        // 默认为0
        config.preferences.minimumFontSize = 10;
        // 默认认为YES
        config.preferences.javaScriptEnabled = YES;
        // 允许网页内嵌视频播放器
        config.allowsInlineMediaPlayback = YES;
        if (@available(iOS 9.0, *)) {
            config.allowsAirPlayForMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
        }
        config.selectionGranularity = YES;
        // 记忆读取
        config.suppressesIncrementalRendering = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        config.processPool = [[WKProcessPool alloc] init];
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        
        if (@available(iOS 9.0, *)) {
            _webView.customUserAgent =@"keytop.superpak.app";
        } else {
            // Fallback on earlier versions
        }
        _webView.navigationDelegate = self;
        _webView.UIDelegate=self;
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.allowsBackForwardNavigationGestures = YES;
        
    }
    return _webView;
}
-(void)setUA:(NSString *)UA
{
    _UA = [UA copy];
    if (_UA && [self isViewLoaded]) {
        if (@available(iOS 9.0, *)) {
            self.webView.customUserAgent = _UA;
        } else {
            // Fallback on earlier versions
        }
    }
}
-(void)setUrl:(NSString *)url
{
    _url = [url copy];
    if (_url && [self isViewLoaded]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
}

-(void)goBackBtnEvent{
    BOOL canGoBack =[self.webView canGoBack];
    if (canGoBack) {
        if ([[self.webView.URL absoluteString] isEqualToString:self.url]) {
            [self closeBtnEvent];
        }
        else{
            [self.webView goBack];
            self.closeButton.hidden=NO;
        }
    }
    else
    {
        [self closeBtnEvent];
    }
    
}
-(void)closeBtnEvent
{
    [self.customBackButton removeFromSuperview];
    [self.closeButton removeFromSuperview];
    
    if(self.presentedViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
         [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - WebView
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    //防止progressView被网页挡住
    
    //    [self updateNavigationItems];
}
// 导航加载完成后
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webView.url=%@",webView.URL);
    
    NSString *string = [webView.URL absoluteString];
    
    [STCThirdSDKManager disposePayURL:string withPayComplete:^(NSError *error,NSString *url) {
        
    }];
    //判断是否包涵支付信息
   
    
    
    NSLog(@"webViewDidFinishLoad-url=%@",[webView URL]);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
    
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    [STCWKWebViewPanelManager presentAlertOnController:self.view.window.rootViewController title:@"" message:message handler:completionHandler];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    [STCWKWebViewPanelManager presentConfirmOnController:self.view.window.rootViewController title:@"" message:message handler:completionHandler];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    [STCWKWebViewPanelManager presentPromptOnController:self.view.window.rootViewController title:@"" message:prompt defaultText:defaultText handler:completionHandler];
}


- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    //    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
    //        self.labelTitle = title;
    //        self.label.text = self.labelTitle;
    //    }];
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
    //            self.labelTitle = title;
    //            self.label.text = self.labelTitle;
    //        }];
    //    });
}
//处理加载失败事件
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    
    
    NSLog(@"%@", error.debugDescription);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    
    
    NSLog(@"%@", error.debugDescription);
}



@end

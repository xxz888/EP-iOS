//
//  KDHtmlWebViewController.m
//  MCOEM
//
//  Created by wza on 2020/4/2.
//  Copyright © 2020 MingChe. All rights reserved.
//

#import "KDHtmlWebViewController.h"
#import <WebKit/WebKit.h>
#import "MCShareManyNavigateController.h"
#import "MCApp.h"


@interface KDHtmlWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic, strong) UIProgressView *progress;
@property (nonatomic, copy) NSString *old_redirect_url;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, copy) NSString *urlScheme;

@property(nonatomic, strong) QMUIPopupMenuView *menuView;

@property(nonatomic, assign) BOOL isMingcheDomain;

@property(nonatomic, copy) NSString *localPageName;

@end

@implementation KDHtmlWebViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.tabBarController.tabBar setHidden:YES];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:self.title tintColor:nil];
    
    NSString *cssContentString = [NSString stringWithFormat:
    @"<!DOCTYPE html>"
        "<html>"
       "<head>"
       "<meta name=\"viewport\" content=\"width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no\">" //适配手机的关键
        "</head>"
        "<body>"
        "%@"
        "</body>"
        "</html>" , self.content];   //self.content就是后台传过来的标签
    [self.webView loadHTMLString:cssContentString baseURL:nil];
    [self.view addSubview:self.webView];
}


- (void)setupNavigationItems {
    [super setupNavigationItems];

}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *conf = [[WKWebViewConfiguration alloc] init];
        [conf.userContentController addScriptMessageHandler:self name:@"iosWebKit"];
        
        CGFloat contentTop = self.mc_nav_hidden ? StatusBarHeight : NavigationContentTop;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, contentTop, SCREEN_WIDTH, SCREEN_HEIGHT-contentTop) configuration:conf];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.clipsToBounds = YES;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _webView;
}
- (UIProgressView *)progress {
    if (!_progress) {
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        CGFloat contentTop = self.mc_nav_hidden ? StatusBarHeight : NavigationContentTop;
        _progress.frame = CGRectMake(0, contentTop, SCREEN_WIDTH, 2);
        _progress.tintColor = MAINCOLOR.qmui_inverseColor;
        _progress.trackTintColor = self.navigationBarTintColor;
    }
    return _progress;
}
#pragma mark - event response
- (void)backTouched:(UIBarButtonItem *)item {
    [self.webView stopLoading];
//    if (self.webView.canGoBack) {
//        [self.webView goBack];
//    } else {
        
        if (self.navigationController.viewControllers.count == 1) {
            SharedDefaults.not_auto_logonin = YES;
            [UIApplication sharedApplication].keyWindow.rootViewController = [MGJRouter objectForURL:rt_tabbar_list];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
//    }
}
- (void)close {
    [self.webView stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.progress.alpha = 1.0f;
        [self.progress setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.progress.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.progress setProgress:0 animated:NO];
                             }];
        }
        
    } else if (object == self.webView && [keyPath isEqualToString:@"title"]) {
        if (!self.title) {
            [self setNavigationBarTitle:self.webView.title tintColor:nil];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSString * name = message.body;
  
}

- (void)dealloc
{
    _webView.UIDelegate = nil;
    _webView.navigationDelegate = nil;
    [_webView stopLoading];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"iosWebKit"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
}


#pragma mark - Private Mtheds




@end

//
//  ANAboutBoboTViewController.m
//  baobaotangDealerAndMarket
//
//  Created by Eric on 16/1/25.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANAboutBoboTViewController.h"
#import "MBProgressHUD.h"

@interface ANAboutBoboTViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ANAboutBoboTViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"关于页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"关于页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 设置导航
    [self setNavgation];
    
    // 加载官网
    [self setWebView];
}


// 设置nav
- (void)setNavgation
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"关于抱抱堂";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setWebView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    self.webView.opaque = NO;
    self.webView.scalesPageToFit = YES;
    [self.webView sizeToFit];
    NSURL *url = [NSURL URLWithString:BoBoTWeb];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // 打开转菊花
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
    hud.labelText= netStr
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 结束转菊花
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
}

@end

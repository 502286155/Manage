//
//  ANDetailViewController.m
//  baobaotang
//
//  Created by 高赛 on 15/12/15.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANDetailViewController.h"

@interface ANDetailViewController ()<UIWebViewDelegate>

/**
 *  webView
 */
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ANDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"活动/公告详情"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"活动/公告详情"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self setNavgation];
    self.webView.delegate = self;
    self.webView.opaque = NO;
    self.webView.scalesPageToFit = YES;
    [self.webView sizeToFit];
    self.aboutUsUrl = [NSString stringWithFormat:@"%@&token=%@",self.aboutUsUrl,[ANCommon token]];
//    self.aboutUsUrl = @"http://baobaotang.alltosun.net/message_center/test/test_cookie";
    ANLog(@"%@",self.aboutUsUrl);
//    NSURL *url = [NSURL URLWithString:self.aboutUsUrl];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [self.webView loadRequest:request];
    [self loadRequest];
}
#pragma mark ----自定义方法
/**
 *  设置navgation
 */
- (void)setNavgation
{
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"详情";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
}
/**
 *  返回的点击事件
 */
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark
/**
 *  加载网页
 */
- (void)loadRequest {
    
    NSURL *url = [NSURL URLWithString:self.aboutUsUrl];
    
    // 设置cookie
    [Common setCookie:url];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    
    
    [self.webView loadRequest:request];
    
//    [self progressStart];
}
@end

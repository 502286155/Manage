//
//  ANHelpHFiveViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/8.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANHelpHFiveViewController.h"

@interface ANHelpHFiveViewController ()<UIWebViewDelegate>

/**
 *  webView
 */
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ANHelpHFiveViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"帮助页面"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"帮助页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    self.webView.opaque = NO;
    self.webView.scalesPageToFit = YES;
    [self.webView sizeToFit];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/article/category?type=2",HOSTURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark ----自定义方法
/**
 *  设置navgation
 */
- (void)setNavgation
{
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBackBtn:)];
    // 设置标题
    self.navigationItem.title = @"帮助";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
}
/**
 *  返回的点击事件
 */
- (void)navLeftBackBtn:(UIBarButtonItem *)btn
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end

//
//  ANLoginViewController.m
//  baobaotang
//
//  Created by Eric on 15/11/3.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANLoginViewController.h"
#import "ANForgetPasswordViewController.h"
#import "ANHomePageViewController.h"
#import "ANMarketHomepageViewController.h"
#import "ANLoginModel.h"
#import "ANHttpTool.h"
#import "JPUSHService.h"
#import "ANNavigationController.h"

@interface ANLoginViewController ()<UIAlertViewDelegate>
// 手机号TextField
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, strong) UIView *errorView;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ANLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"登录页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"登录页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航
    [self setNavgation];

    self.phoneTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]; //
//    self.pwdTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
}

- (void)setNavgation
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
   
    self.title = @"登录";
    // 中间的标题
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attribute];
    // 左边的按钮
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(navLeftClickedAction:)];
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_call_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(navRightClickedAction:)];
}

/**
 *  nav左边的点击事件
 */
//- (void)navLeftClickedAction:(UIButton *)btn
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

/**
 *  nav右边的添加按钮的点击事件
 */
- (void)navRightClickedAction:(UIButton *)btn
{
    
    ANLog(@"消息");
    
    [ANCommon setAlertViewWithTitle:@"工作时间:每天9:00-18:00" andMessage:[NSString stringWithFormat:@"呼叫%@", Tel] andVC:self];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        ANLog(@"拨打");
        [self callTel];
    }
}
/**
 *  打电话
 */
- (void)callTel
{
//    self.webView = [[UIWebView alloc] init];
//    NSString *telStr = [NSString stringWithFormat:@"tel://%@", Tel];
//    NSURL *url = [NSURL URLWithString:telStr];
//    
//    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:requestUrl];
    
    NSString *allString = [NSString stringWithFormat:@"tel:%@", Tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
}

/**
 *  忘记密码
 */
- (IBAction)forgetPasswordButtonAction:(id)sender {
    
    ANForgetPassWordViewController *forgetPasswordVC = [[ANForgetPassWordViewController alloc] init];
    [self.navigationController pushViewController:forgetPasswordVC animated:YES];
}


- (IBAction)clickLoginBtn:(id)sender {
    ANLog(@"登陆");
    [self.phoneTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
    
    self.loginBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.loginBtn.enabled = YES;
    });
    if ([self.phoneTextField.text isEqualToString:@""]) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,你的手机号不能为空!"];
        [self setNavErrorView];
        return;
    }else if (self.phoneTextField.text.length < 11) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,你的手机号错啦,再想想!"];
        [self setNavErrorView];
        return;
    }else if ([self.pwdTextField.text isEqualToString:@""]) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,你的密码错啦,再想想!"];
        [self setNavErrorView];
        return;
    }

    NSString *userName = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *pwd = [self.pwdTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSString *registrationID = [JPUSHService registrationID];
    ANLog(@"_+_+_+_+_+_ : %@", registrationID);
    
    
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"password"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             userName, @"user_name",
                             pwd, @"password",
                             nil];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (registrationID) {
        if ([registrationID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]]) {
            [params setValue:registrationID forKey:@"device_id"];
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
            [params setValue:registrationID forKey:@"device_id"];
        }
    }else {
        [params setValue:registrationID forKey:@"device_id"];
    }
    params = (NSMutableDictionary *)[ANCommon dicToSign:params];
    ANLog(@"%@",params);
    [ANHttpTool postWithUrl:@"/api/1/user/login_auth" params:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        
        if (responseObject[@"response"][@"token"]) {
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"response"][@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"response"][@"role_id"] forKey:@"reloID"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"response"][@"cookie"] forKey:@"remember_me"];
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userNme"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"response"][@"mobile"] forKey:@"mobile"];
            if (responseObject[@"response"][@"user_id"]) {
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"response"][@"user_id"] forKey:@"userID"];
            }
            if (5 == [responseObject[@"response"][@"role_id"] intValue]) { // 经销商首页
                ANHomePageViewController *homeVC = [[ANHomePageViewController alloc] init];
                ANNavigationController *homeNav = [[ANNavigationController alloc] initWithRootViewController:homeVC];
                [UIApplication sharedApplication].keyWindow.rootViewController = homeNav;
            }else if (10 == [responseObject[@"response"][@"role_id"] intValue]){ // 市场人员首页
                ANMarketHomepageViewController *marketVC = [[ANMarketHomepageViewController alloc] init];
                ANNavigationController *marketNav = [[ANNavigationController alloc] initWithRootViewController:marketVC];
                [UIApplication sharedApplication].keyWindow.rootViewController = marketNav;
            }
            [self dismissViewControllerAnimated:YES completion:^{
                [ANNotificationCenter postNotificationName:@"loginSuccess" object:nil];
            }];
        }
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:responseObject[@"message"]];
        [self setNavErrorView];
        return ;
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"1error : %@", error);
    }];
}
- (void)setNavErrorView
{
    [self.navigationController.navigationBar addSubview:self.errorView];
    [UIView animateWithDuration:0.5 animations:^{
        self.errorView.y = -20;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(removeError) withObject:self.errorView afterDelay:1];
    }];
}
- (void)removeError
{
    [UIView animateWithDuration:0.5 animations:^{
        self.errorView.height = -64;
    } completion:^(BOOL finished) {
        [self.errorView removeFromSuperview];
    }];
}
@end

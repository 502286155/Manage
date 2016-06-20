//
//  ANForgetPasswordViewController.m
//  baobaotang
//
//  Created by Eric on 15/11/3.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANForgetPassWordViewController.h"
#import "ANForgetPassWordView.h"
#import "ANHttpTool.h"

@interface ANForgetPassWordViewController () <ANForgetPassWordViewDelegate>


@property (nonatomic, strong) UIView *errorView;

@end

@implementation ANForgetPassWordViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"忘记密码页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"忘记密码页"];
}

/**
 *  视图加载
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ANColor(240, 240, 240);
    
    
    // 设置导航栏
    [self setNavgation];
    
    // 设置子视图
    [self setSubViews];
}

#pragma mark ----设置nav
// 设置nav
- (void)setNavgation
{
    self.navigationItem.title = @"忘记密码";
    // 中间的标题
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attribute];
    // 左边的按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(navLeftClickedAction:)];
}
/**
 *  nav左边的点击事件
 */
- (void)navLeftClickedAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ----布局子视图
/**
 *  视图布局
 */
- (void)setSubViews
{
    ANForgetPassWordView *forgetView = [[ANForgetPassWordView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 190)];
    forgetView.delegate = self;
    [self.view addSubview:forgetView];
}

/**
 *  获取新密码
 */
- (void)sendCaptcha:(NSString *)phone verifyCode:(NSString *)verifyCode
{
    
    ANLog(@"获取新密码");
    if (phone.length == 0) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,请输入手机号"];
        [self setNavErrorView];
        return;
    }else if (phone.length != 11) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,你的手机号错啦,再想想"];
        [self setNavErrorView];
        return;
    }else if (verifyCode.length == 0) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,请输入验证码"];
        [self setNavErrorView];
    }else {
        [self resignFirstResponder];
        
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:[phone stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"user_name"];
        [parmDict setObject:[verifyCode stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"code"];
        parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
        [ANHttpTool postWithUrl:@"/api/1/user/check_code" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
            self.errorView = [ANCommon errorViewWithColor:SuccessViewColor Message:@"伙伴,新密码已发送您的手机"];
            [self setNavErrorView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
            ANLog(@"error: %@",responseObject);
            self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:responseObject[@"message"]];
            [self setNavErrorView];
            return;
        } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
            ANLog(@"fail: %@",error);
            self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"密码获取失败"];
            [self setNavErrorView];
            return ;
        }];
    }
}

/**
 *  获取验证码
 */
- (void)sendCaptcha:(NSString *)phone
{
    ANLog(@"获取验证码");
    
    if (phone.length == 0) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,请输入手机号"];
        [self setNavErrorView];
        return;
    }else if (phone.length != 11) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,你的手机号错啦,再想想"];
        [self setNavErrorView];
        return;
    }else {
        
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:phone forKey:@"user_name"];
        parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
        [ANHttpTool postWithUrl:@"/api/1/user/back_password" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
            [ANNotificationCenter postNotificationName:@"setTime" object:nil];
            self.errorView = [ANCommon errorViewWithColor:SuccessViewColor Message:@"验证码发送成功"];
            [self setNavErrorView];
        } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
            ANLog(@"error:%@",responseObject);
            
            self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:responseObject[@"message"]];
            [self setNavErrorView];
            return ;
        } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
            ANLog(@"fail:%@",error);
            return;
        }];
    }
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

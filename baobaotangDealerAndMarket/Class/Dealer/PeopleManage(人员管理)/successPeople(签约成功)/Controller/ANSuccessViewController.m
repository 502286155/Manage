//
//  ANSuccessViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/16.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANSuccessViewController.h"
#import "ANPeopleManageViewController.h"

@interface ANSuccessViewController ()<UIAlertViewDelegate>

/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation ANSuccessViewController

- (UIAlertView *)alertView
{
    if (_alertView == nil) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定已帮助市场人员安装好APP并返回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    return _alertView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [MobClick endLogPageView:@"签约成功页"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"签约成功页"];//("PageOne"为页面名称，可自定义)
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];
    self.phoneLabel.text = self.mobile;
}
#pragma mark ---- 自定义方法
// 设置nav
- (void)setNavgation
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"签约成功";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
}
// 返回的点击事件
- (void)returnClick
{
    [self.alertView show];
}
- (IBAction)clickSureBtn:(id)sender {
    [self.alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[ANPeopleManageViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }
}
@end

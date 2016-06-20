//
//  ANCustomerSuccessViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/24.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANCustomerSuccessViewController.h"
#import "ANCustomerManageViewController.h"
#import "ANAreaListViewController.h"

@interface ANCustomerSuccessViewController ()<UIAlertViewDelegate>

/**
 *  二维码图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *barcodeImage;

/**
 *  商家的账号Labe
 */
@property (weak, nonatomic) IBOutlet UILabel *customAccount;

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation ANCustomerSuccessViewController

- (UIAlertView *)alertView
{
    if (_alertView == nil) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定已帮助掌柜安装好APP并返回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    return _alertView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"签约新门店成功页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"签约新门店成功页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];
    
    // 生成的店长的用户名
    self.customAccount.text = self.user_name;
}
#pragma mark ---- 自定义方法
// 设置nav
- (void)setNavgation
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.title = @"签约成功";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
// 返回的点击事件
- (void)returnClick
{
    [self.alertView show];
//    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)clickFinishBtn:(id)sender {
    
    [self.alertView show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[ANCustomerManageViewController class]]) {
                [ANNotificationCenter postNotificationName:@"requestData" object:nil userInfo:nil];
                
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
            if ([vc isKindOfClass:[ANAreaListViewController class]]) {
                [ANNotificationCenter postNotificationName:@"requestListData" object:nil userInfo:nil];
                
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }
}


@end

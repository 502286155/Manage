//
//  ANFirstGuideViewController.m
//  baobaotangDealerAndMarket
//
//  Created by Eric on 16/1/15.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANFirstGuideViewController.h"
#import "ANInventoryCheckViewController.h"
#import "ANPurchasesViewController.h"
#import "ANLoginViewController.h"
#import "ANNavigationController.h"

@interface ANFirstGuideViewController () <UIAlertViewDelegate>

/**
 *  提交按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation ANFirstGuideViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"首次登陆提示页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"首次登陆提示页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 设置导航
    [self setNavgation];
    
    [self.submitButton setTitle:[NSString stringWithFormat:@"%@", self.buttonTitle] forState:UIControlStateNormal];
}

/**
 *  设置navgation
 */
- (void)setNavgation
{
//    // 设置标题
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"初始化设置";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更换账号" style:UIBarButtonItemStylePlain target:self action:@selector(dismissClick)];
    // 设置右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_call_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(clickPhone)];
}

/**
 *  返回的点击事件
 */
- (void)dismissClick
{
//    for (UIViewController *vc in self.navigationController.childViewControllers) {
//        if ([vc isKindOfClass:[ANHomePageViewController class]]) {
//            //            [ANNotificationCenter postNotificationName:@"requestData" object:nil userInfo:nil];
//            [self.navigationController popToViewController:vc animated:YES];
//        }
//    }
    
    ANLoginViewController *login = [[ANLoginViewController alloc] init];
    ANNavigationController *loginNav = [[ANNavigationController alloc] initWithRootViewController:login];
    [self presentViewController:loginNav animated:YES completion:^{
    }];
}

- (void)clickPhone
{
    ANLog(@"打电话");
    [ANCommon setAlertViewWithTitle:@"请联系区域销售助理" andMessage:@"或拨打 4008650003" andVC:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *allString = [NSString stringWithFormat:@"tel:%@", Tel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
    }
}

/**
 *  提交事件
 */
- (IBAction)submitButtonAction:(id)sender {
    
    if ([self.submitButton.currentTitle isEqualToString:@"盘点库存"]) {
        ANInventoryCheckViewController *inventoryCheck = [[ANInventoryCheckViewController alloc] init];
        inventoryCheck.store_id = self.store_id;
        [self.navigationController pushViewController:inventoryCheck animated:YES];
    } else if ([self.submitButton.currentTitle isEqualToString:@"首次进货"]) {
        ANPurchasesViewController *puchases = [[ANPurchasesViewController alloc] init];
        puchases.storeID = self.store_id;
        [self.navigationController pushViewController:puchases animated:YES];
        
    }
    
    
}

@end

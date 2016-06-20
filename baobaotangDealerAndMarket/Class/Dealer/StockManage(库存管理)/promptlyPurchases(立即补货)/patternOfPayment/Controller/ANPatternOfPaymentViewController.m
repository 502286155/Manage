//
//  ANPatternOfPaymentViewController.m
//  baobaotang
//
//  Created by Eric on 15/11/5.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANPatternOfPaymentViewController.h"
#import "ANPaySuccessViewController.h"

@interface ANPatternOfPaymentViewController ()

@property (weak, nonatomic) IBOutlet UIButton *visitBtn;
@property (weak, nonatomic) IBOutlet UIButton *bankBtn;


@property (nonatomic, assign) int selectNum;

@end

@implementation ANPatternOfPaymentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"经销商确认支付页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"经销商确认支付页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectNum = 2;
    
    
    [self.bankBtn setImage:[UIImage imageNamed:@"draw_icon"] forState:UIControlStateNormal];
    // 设置navgation
    [self setNavgation];
    
}

/**
 *  设置navgation
 */
- (void)setNavgation
{
    self.navigationController.navigationBarHidden = NO;
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnSubmitPageClick)];
    // 设置标题
    self.navigationItem.title = @"支付方式";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
}

/**
 *  返回的点击事件
 */
- (void)returnSubmitPageClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 上门收款
- (IBAction)clickVisitBtn:(id)sender {
    self.selectNum = 1;
    [self.visitBtn setImage:[UIImage imageNamed:@"draw_icon"] forState:UIControlStateNormal];
    [self.bankBtn setImage:nil forState:UIControlStateNormal];
}
// 银行卡转账
- (IBAction)clickBankBtn:(id)sender {
    self.selectNum = 2;
    [self.visitBtn setImage:nil forState:UIControlStateNormal];
    [self.bankBtn setImage:[UIImage imageNamed:@"draw_icon"] forState:UIControlStateNormal];
}


/**
 *  确认按钮
 */
- (IBAction)markSureButton:(id)sender {
    
    
//    ANPaySuccessViewController *paySuccessVC = [[ANPaySuccessViewController alloc] init];
//    [self.navigationController pushViewController:paySuccessVC animated:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.selectNum == 1) {
        [dict setObject:@"上门收款" forKey:@"name"];
    }else if (self.selectNum == 2) {
        [dict setObject:@"合伙人银行卡转账" forKey:@"name"];
    }
    [ANNotificationCenter postNotificationName:@"patterm" object:nil userInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end

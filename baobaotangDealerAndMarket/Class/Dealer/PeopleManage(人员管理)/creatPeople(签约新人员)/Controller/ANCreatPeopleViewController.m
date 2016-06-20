//
//  ANCreatPeopleViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/22.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANCreatPeopleViewController.h"
#import "ANSuccessViewController.h"
#import "ANHttpTool.h"

@interface ANCreatPeopleViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneText;
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *qqText;
@property (weak, nonatomic) IBOutlet UITextField *cardText;
@property (weak, nonatomic) IBOutlet UITextField *bankText;
@property (weak, nonatomic) IBOutlet UITextField *bankNameText;
@property (weak, nonatomic) IBOutlet UIImageView *nanImg;
@property (weak, nonatomic) IBOutlet UIImageView *nvImg;
@property (weak, nonatomic) IBOutlet UIButton *nanBtn;
@property (weak, nonatomic) IBOutlet UIButton *nvBtn;
/**
 *  性别  '0' => '女', '1' => '男',
 */
@property (nonatomic, assign) BOOL isSex;

@property (weak, nonatomic) IBOutlet UITextField *weixinText;

@end

@implementation ANCreatPeopleViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"签约新人员"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"签约新人员"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];
    self.sureBtn.layer.cornerRadius = 8;
    self.sureBtn.layer.masksToBounds = YES;
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
    self.navigationItem.title = @"创建员工";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
}
- (IBAction)clickNanBtn:(id)sender {
    self.nanImg.image = [UIImage imageNamed:@"customer_select"];
    self.nvImg.image = [UIImage imageNamed:@"customer_unSelect"];
    self.isSex = @"0";
    
}
- (IBAction)clickNvBtn:(id)sender {
    self.nanImg.image = [UIImage imageNamed:@"customer_unSelect"];
    self.nvImg.image = [UIImage imageNamed:@"customer_select"];
    self.isSex = @"1";
}

// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:self.userPhoneText.text forKey:@"mobile"];
        [parmDict setObject:self.userNameText.text forKey:@"realname"];
        [parmDict setObject:self.bankText.text forKey:@"bank_cardno"];
        [parmDict setObject:self.bankNameText.text forKey:@"bank_name"];
        [parmDict setObject:self.weixinText.text forKey:@"weixin"];
        if (self.isSex) {
            [parmDict setObject:@"0" forKey:@"gender"];
        }else {
            [parmDict setObject:@"1" forKey:@"gender"];
        }
        [parmDict setObject:self.cardText.text forKey:@"idcard"];
        [parmDict setObject:self.qqText.text forKey:@"qq"];
        parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
        [ANHttpTool postWithUrl:@"/api/1/dealers/create_people" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
            [self parseSubStoreData:responseObject];
        } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
            ANLog(@"error:%@",responseObject);
            NSString *str = responseObject[@"message"];
            if ([str isEqualToString:@"此用户已经是市场人员了"]) {
                [ANCommon setAlertViewWithMessage:@"该手机号已注册"];
            }else if ([str isEqualToString:@"此用户已经有其他身份了"]) {
                [ANCommon setAlertViewWithMessage:@"该用户已有其他身份"];
            }else if ([str isEqualToString:@"手机号格式不正确"]) {
                [ANCommon setAlertViewWithMessage:@"手机号格式不正确"];
            }
        } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
            ANLog(@"fail:%@",error);
        }];
    }
}
- (IBAction)clickSureBtn:(id)sender {
    
    if (self.userPhoneText.text.length != 11) {
        [ANCommon setAlertViewWithMessage:@"请输入正确的手机号格式"];
        return;
    }
    if ([self.userNameText.text isEqualToString:@""]) {
        [ANCommon setAlertViewWithMessage:@"请输入员工姓名"];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认创建该市场人员" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}
- (void)parseSubStoreData:(id)data
{
    ANLog(@"%@",data);
    if ([data[@"message"] isEqualToString:@"success"]) {
        ANSuccessViewController *successVC = [[ANSuccessViewController alloc] init];
        successVC.mobile = self.userPhoneText.text;
        [self.navigationController pushViewController:successVC animated:YES];
    }
}


@end

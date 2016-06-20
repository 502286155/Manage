//
//  ANChangePeopleViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/22.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANChangePeopleViewController.h"
#import "ANSuccessViewController.h"
#import "ANHttpTool.h"

@interface ANChangePeopleViewController ()<UIAlertViewDelegate>

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

@implementation ANChangePeopleViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"修改信息"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"修改信息"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];
    self.sureBtn.layer.cornerRadius = 8;
    self.sureBtn.layer.masksToBounds = YES;
    self.userNameText.text = self.model.realname;
    self.userPhoneText.text = self.model.mobile;
    if ([self.model.gender isEqualToString:@"0"]) {
        self.nanImg.image = [UIImage imageNamed:@"customer_unSelect"];
        self.nvImg.image = [UIImage imageNamed:@"customer_select"];
    }else {
        self.nanImg.image = [UIImage imageNamed:@"customer_select"];
        self.nvImg.image = [UIImage imageNamed:@"customer_unSelect"];
    }
    self.qqText.text = self.model.qq;
    self.weixinText.text = self.model.weixin;
    self.cardText.text = self.model.idcard;
    self.bankText.text = self.model.bank_name;
    self.bankNameText.text = self.model.bank_name;
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
    self.navigationItem.title = @"修改信息";
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
        [parmDict setObject:self.marketing_id forKey:@"marketing_id"];
        [parmDict setObject:@"" forKey:@"email"];
        [parmDict setObject:@"" forKey:@"department"];
        [parmDict setObject:@"" forKey:@"job"];
        parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
//        ANLog(@"%@",parmDict);
        [ANHttpTool postWithUrl:@"/api/1/dealers/update_marketing_detail" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
            [self parseSubStoreData:responseObject];
        } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
            ANLog(@"error:%@",responseObject);
            [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
        } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
            ANLog(@"fail:%@",error);
        }];
    }
}
- (void)parseSubStoreData:(id)data
{
    ANLog(@"%@",data);
    [[ANCommon alloc] setAlertView:data[@"message"]];
    if ([self.delegate respondsToSelector:@selector(requestPeopleData)]) {
        [self.delegate requestPeopleData];
    }
    dispatch_time_t time = dispatch_time ( DISPATCH_TIME_NOW , 2ull * NSEC_PER_SEC ) ;
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
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
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认修改该市场人员信息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}


@end

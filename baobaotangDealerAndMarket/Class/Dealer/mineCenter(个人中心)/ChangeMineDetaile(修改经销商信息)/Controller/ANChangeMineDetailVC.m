//
//  ANChangeMineDetailVC.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/4/28.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANChangeMineDetailVC.h"
#import "ANHttpTool.h"

@interface ANChangeMineDetailVC ()

@property (weak, nonatomic) IBOutlet UIView *nameView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField;
@property (weak, nonatomic) IBOutlet UIButton *secondeBtn;

@end

@implementation ANChangeMineDetailVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.nameTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavgation];
    
    self.nameView.layer.borderColor = [UIColor blackColor].CGColor;
    self.nameView.layer.borderWidth = 1;
    self.nameView.layer.cornerRadius = 5;
    self.nameView.layer.masksToBounds = YES;
    
    self.secondView.layer.borderColor = [UIColor blackColor].CGColor;
    self.secondView.layer.borderWidth = 1;
    self.secondView.layer.cornerRadius = 5;
    self.secondView.layer.masksToBounds = YES;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@:",self.nameStr];
    self.nameTextField.text = self.nameValue;
    
    if ([self.nameStr isEqualToString:@"银行"]) {
        self.secondView.hidden = NO;
        self.nameTextField.text = self.model.bank_code;
        self.secondTextField.text = self.model.bank_name;
    }
}
// 设置nav
- (void)setNavgation
{
    
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
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickFristSureBtn:(id)sender {
    if ([self.nameStr isEqualToString:@"姓名"]) {
        self.model.realname = self.nameTextField.text;
    }else if ([self.nameStr isEqualToString:@"微信"]) {
        self.model.weixin = self.nameTextField.text;
    }else if ([self.nameStr isEqualToString:@"银行"]) {
        self.model.bank_code = self.nameTextField.text;
    }
    [self requestData];
}
- (IBAction)clickSecondSureBtn:(id)sender {
    self.model.bank_code = self.nameTextField.text;
    self.model.bank_name = self.secondTextField.text;
    [self requestData];
}
- (void)requestData
{
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:self.model.bank_name forKey:@"bank_name"];  // 银行开户行
    [paramsDict setObject:self.model.bank_code forKey:@"bank_code"];     // 银行卡号
    [paramsDict setObject:self.model.realname forKey:@"realname"];      // 合伙人真实姓名
    [paramsDict setObject:self.model.weixin forKey:@"weixin"];        // 合伙人微信
    paramsDict = (NSMutableDictionary *)[ANCommon dicToSign:paramsDict];
    
    [ANHttpTool postWithUrl:@"/api/1/dealers/update_dealer_detail" params:paramsDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([self.nameStr isEqualToString:@"银行"]) {
            [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
        }else {
            [[ANCommon alloc] setAlertView:responseObject[@"message"]];
            dispatch_time_t time = dispatch_time ( DISPATCH_TIME_NOW , 2ull * NSEC_PER_SEC ) ;
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

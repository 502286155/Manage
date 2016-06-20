//
//  ANRemoveDeviceViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/19.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANRemoveDeviceViewController.h"
#import "ANHttpTool.h"

@interface ANRemoveDeviceViewController ()<UITextViewDelegate, UIAlertViewDelegate>

/**
 *  返回按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
/**
 *  确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/**
 *  隐藏视图
 */
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
/**
 *  备注输入框
 */
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
/**
 *  备注placeLabel
 */
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
/**
 *  弹出视图
 */
@property (nonatomic, strong) UIAlertView *alertView;
/**
 *  是否回收了设备 0是没有  1是有
 */
@property (nonatomic, assign) BOOL isCancel;

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;

@end

@implementation ANRemoveDeviceViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isCancel) {
        [ANNotificationCenter postNotificationName:@"removeDevice" object:nil];
    }
    [MobClick endLogPageView:@"设备登记移除设备页"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"设备登记移除设备页"];//("PageOne"为页面名称，可自定义)
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.remarkTextView.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.oneBtn.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.twoBtn.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.threeBtn.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.fourBtn.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.fiveBtn.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.sixBtn.layer.borderColor = ANColor(206, 206, 206).CGColor;
}

- (IBAction)clickBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---- 确定按钮
- (IBAction)clickSureBtn:(id)sender {
    self.hiddenView.hidden = NO;
}


#pragma mark ---- 备注
- (IBAction)clickOneBtn:(id)sender {
    if ([self.remarkTextView.text isEqualToString:@""]) {
        self.remarkLabel.hidden = YES;
        self.remarkTextView.text = @"门店暂停合作";
    }else {
        self.remarkTextView.text = [self.remarkTextView.text stringByAppendingString:[NSString stringWithFormat:@" 门店暂停合作"]];
    }
    [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.sureBtn.enabled = YES;
}
- (IBAction)clickTwoBtn:(id)sender {
    if ([self.remarkTextView.text isEqualToString:@""]) {
        self.remarkLabel.hidden = YES;
        self.remarkTextView.text = @"设备维护修理";
    }else {
        self.remarkTextView.text = [self.remarkTextView.text stringByAppendingString:[NSString stringWithFormat:@" 设备维护修理"]];
    }
    [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.sureBtn.enabled = YES;
}
- (IBAction)clickThreeBtn:(id)sender {
    if ([self.remarkTextView.text isEqualToString:@""]) {
        self.remarkLabel.hidden = YES;
        self.remarkTextView.text = @"设备更新换代";
    }else {
        self.remarkTextView.text = [self.remarkTextView.text stringByAppendingString:[NSString stringWithFormat:@" 设备更新换代"]];
    }
    [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.sureBtn.enabled = YES;
}
- (IBAction)clickFourBtn:(id)sender {
    if ([self.remarkTextView.text isEqualToString:@""]) {
        self.remarkLabel.hidden = YES;
        self.remarkTextView.text = @"设备停用回收";
    }else {
        self.remarkTextView.text = [self.remarkTextView.text stringByAppendingString:[NSString stringWithFormat:@" 设备停用回收"]];
    }
    [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.sureBtn.enabled = YES;
}
- (IBAction)clickFiveBtn:(id)sender {
    if ([self.remarkTextView.text isEqualToString:@""]) {
        self.remarkLabel.hidden = YES;
        self.remarkTextView.text = @"设备临时借调";
    }else {
        self.remarkTextView.text = [self.remarkTextView.text stringByAppendingString:[NSString stringWithFormat:@" 设备临时借调"]];
    }
    [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.sureBtn.enabled = YES;
}
- (IBAction)clickSixBtn:(id)sender {
    if ([self.remarkTextView.text isEqualToString:@""]) {
        self.remarkLabel.hidden = YES;
        self.remarkTextView.text = @"设备遭窃遗失";
    }else {
        self.remarkTextView.text = [self.remarkTextView.text stringByAppendingString:[NSString stringWithFormat:@" 设备遭窃遗失"]];
    }
    [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.sureBtn.enabled = YES;
}
#pragma mark ---- textFieldDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.remarkLabel.hidden = NO;
        [self.sureBtn setBackgroundColor:ANColor(209, 209, 209)];
        self.sureBtn.enabled = NO;
    }else {
        [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
        self.sureBtn.enabled = YES;
        self.remarkLabel.hidden = YES;
    }
}
#pragma mark ---- alertViewDelegate
- (UIAlertView *)alertView
{
    if (_alertView == nil) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备解绑成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    }
    return _alertView;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.isCancel = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---- 解绑设备
- (IBAction)clickHiddenBtn:(id)sender {
    self.hiddenView.hidden = YES;
}
- (IBAction)clickHiddenSureBtn:(id)sender {
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.deviceNo forKey:@"device_no"];
    [parmDict setObject:self.storeID forKey:@"store_id"];
    [parmDict setObject:self.remarkTextView.text forKey:@"unbind_reason"];
    [parmDict setObject:@"1" forKey:@"status"];
    [parmDict setObject:@"" forKey:@"extra"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    ANLog(@"%@",parmDict);
    [ANHttpTool postWithUrl:@"/api/1/store/bind_store_device" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"success:%@",responseObject);
        self.hiddenView.hidden = YES;
        [self.alertView show];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
        self.hiddenView.hidden = YES;
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
        self.hiddenView.hidden = YES;
    }];   
}


@end

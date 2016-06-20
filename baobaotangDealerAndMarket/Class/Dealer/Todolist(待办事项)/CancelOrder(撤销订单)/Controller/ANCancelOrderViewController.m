//
//  ANCancelOrderViewController.m
//  baobaotang
//
//  Created by 高赛 on 15/12/28.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANCancelOrderViewController.h"
#import "MBProgressHUD.h"
#import "ANHttpTool.h"

@interface ANCancelOrderViewController ()<UITextViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
/**
 *  因误操作下单
 */
@property (weak, nonatomic) IBOutlet UIButton *operationBtn;
/**
 *  取消进货计划
 */
@property (weak, nonatomic) IBOutlet UIButton *planBtn;
/**
 *  进货内容变动
 */
@property (weak, nonatomic) IBOutlet UIButton *contentBtn;
/**
 *  仓库商品缺货
 */
@property (weak, nonatomic) IBOutlet UIButton *warehouseBtn;
/**
 *  收货时间变动
 */
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
/**
 *  收货地址变动
 */
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
/**
 *  确认撤销订单按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/**
 *  返回按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
/**
 *  隐藏视图
 */
@property (weak, nonatomic) IBOutlet UIView *hiddenView;

@end

@implementation ANCancelOrderViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"经销商/商户撤销订单页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"经销商/商户撤销订单页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textView.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.operationBtn.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.planBtn.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.contentBtn.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.warehouseBtn.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.timeBtn.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.addressBtn.layer.borderColor = ANColor(206, 206, 206).CGColor;
}


/**
 *  因误操作下单
 */
- (IBAction)clickOneBtn:(id)sender {
    if ([self.textView.text isEqualToString:@""]) {
        self.placeHolderLabel.hidden = YES;
        self.textView.text = @"因误操作下单";
    }else {
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@" 因误操作下单"]];
    }
    [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.sureBtn.enabled = YES;
}
/**
 *  取消进货计划
 */
- (IBAction)clickTwoBtn:(id)sender {
    if ([self.textView.text isEqualToString:@""]) {
        self.placeHolderLabel.hidden = YES;
        self.textView.text = @"取消进货计划";
    }else {
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@" 取消进货计划"]];
    }
    [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.sureBtn.enabled = YES;
}
/**
 *  进货内容变动
 */
- (IBAction)clickThreeBtn:(id)sender {
    if ([self.textView.text isEqualToString:@""]) {
        self.placeHolderLabel.hidden = YES;
        self.textView.text = @"进货内容变动";
    }else {
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@" 进货内容变动"]];
    }
    [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.sureBtn.enabled = YES;
}
/**
 *  仓库商品缺货
 */
- (IBAction)clickFourBtn:(id)sender {
    if ([self.textView.text isEqualToString:@""]) {
        self.placeHolderLabel.hidden = YES;
        self.textView.text = @"仓库商品缺货";
    }else {
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@" 仓库商品缺货"]];
    }
    [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.sureBtn.enabled = YES;
}
/**
 *  收货时间变动
 */
- (IBAction)clickFiveBtn:(id)sender {
    if ([self.textView.text isEqualToString:@""]) {
        self.placeHolderLabel.hidden = YES;
        self.textView.text = @"收货时间变动";
    }else {
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@" 收货时间变动"]];
    }
    [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.sureBtn.enabled = YES;
}
/**
 *  收货地址变动
 */
- (IBAction)clickSixBtn:(id)sender {
    if ([self.textView.text isEqualToString:@""]) {
        self.placeHolderLabel.hidden = YES;
        self.textView.text = @"收货地址变动";
    }else {
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@" 收货地址变动"]];
    }
    [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.sureBtn.enabled = YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
        [self.sureBtn setBackgroundColor:ANColor(209, 209, 209)];
        self.sureBtn.enabled = NO;
    }else {
        [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.6908 green:0.0 blue:0.0142 alpha:1.0]];
        self.sureBtn.enabled = YES;
        self.placeHolderLabel.hidden = YES;
    }
}
- (IBAction)clickBackBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickSureBtn:(id)sender {
    self.hiddenView.hidden = NO;
}
- (IBAction)clickHiddenSureBtn:(id)sender {
    [self cancleOrSureOrder];
}
- (IBAction)clickHiddenBackBtn:(id)sender {
    self.hiddenView.hidden = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self cancleOrSureOrder];
    }
}
- (void)cancleOrSureOrder
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
    hud.labelText= netStr
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    });
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.storeID forKey:@"store_id"];
    [parmDict setObject:self.order_id forKey:@"order_id"];
    [parmDict setObject:@"15" forKey:@"progress"];
    [parmDict setObject:self.textView.text forKey:@"reason"];
    
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/order/update_order_progress" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
//        ANLog(@"成功%@",responseObject);
        [self parseData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)parseData:(id)data
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    if ([data[@"message"] isEqualToString:@"success"]) {
        [ANNotificationCenter postNotificationName:@"cancle" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end

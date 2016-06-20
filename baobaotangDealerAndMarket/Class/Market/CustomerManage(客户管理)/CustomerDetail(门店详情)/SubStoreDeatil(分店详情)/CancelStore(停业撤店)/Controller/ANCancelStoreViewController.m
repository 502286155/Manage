//
//  ANCancelOrderViewController.m
//  baobaotang
//
//  Created by 高赛 on 15/12/28.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANCancelStoreViewController.h"
#import "MBProgressHUD.h"
#import "ANHttpTool.h"

@interface ANCancelStoreViewController ()<UITextViewDelegate, UIAlertViewDelegate>

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

@implementation ANCancelStoreViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"停业撤店页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"停业撤店页"];
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
        self.textView.text = @"掌柜销量问题";
    }else {
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@" 掌柜销量问题"]];
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
        self.textView.text = @"门店停业转让";
    }else {
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@" 门店停业转让"]];
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
        self.textView.text = @"门店装修迁址";
    }else {
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@" 门店装修迁址"]];
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
        self.textView.text = @"营销无法配合";
    }else {
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@" 营销无法配合"]];
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
        self.textView.text = @"合作资质问题";
    }else {
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@" 合作资质问题"]];
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
        self.textView.text = @"门店销售违规";
    }else {
        self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@" 门店销售违规"]];
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
        [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
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
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    
    [ANHttpTool postWithUrl:@"/api/1/store/stop_store" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
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
//        [ANNotificationCenter postNotificationName:@"cancle" object:nil];
//        [self.popoverPresentationController popViewControllerAnimated:YES];
        [ANNotificationCenter postNotificationName:@"cancle" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}




@end

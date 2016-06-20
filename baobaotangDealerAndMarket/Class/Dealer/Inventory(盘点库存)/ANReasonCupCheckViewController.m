//
//  ANReasonCupCheckViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/20.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANReasonCupCheckViewController.h"
#import "ANHttpTool.h"

@interface ANReasonCupCheckViewController ()<UITextViewDelegate>

/**
 *  顶部视图
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  理由textField
 */
@property (weak, nonatomic) IBOutlet UITextView *reasonTextField;
/**
 *  理由Label
 */
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;
/**
 *  底部视图
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/**
 *  底部按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
/**
 *  隐藏视图
 */
@property (weak, nonatomic) IBOutlet UIView *hiddenView;


@end

@implementation ANReasonCupCheckViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"盘点库存提交页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"盘点库存提交页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.reasonTextField.layer.borderColor = ANColor(206, 206, 206).CGColor;
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

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.reasonLabel.hidden = NO;
        [self.bottomBtn setBackgroundColor:ANColor(209, 209, 209)];
        self.bottomBtn.enabled = NO;
    }else {
        [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
        self.bottomBtn.enabled = YES;
        self.reasonLabel.hidden = YES;
    }
}
- (IBAction)clickOneBtn:(id)sender {
    if ([self.reasonTextField.text isEqualToString:@""]) {
        self.reasonLabel.hidden = YES;
        self.reasonTextField.text = @"上次盘点有误";
    }else {
        self.reasonTextField.text = [self.reasonTextField.text stringByAppendingString:[NSString stringWithFormat:@" 上次盘点有误"]];
    }
    [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.bottomBtn.enabled = YES;
}
- (IBAction)clickTwoBtn:(id)sender {
    if ([self.reasonTextField.text isEqualToString:@""]) {
        self.reasonLabel.hidden = YES;
        self.reasonTextField.text = @"客户礼品赠送";
    }else {
        self.reasonTextField.text = [self.reasonTextField.text stringByAppendingString:[NSString stringWithFormat:@" 客户礼品赠送"]];
    }
    [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.bottomBtn.enabled = YES;
}
- (IBAction)clickThreeBtn:(id)sender {
    if ([self.reasonTextField.text isEqualToString:@""]) {
        self.reasonLabel.hidden = YES;
        self.reasonTextField.text = @"活动礼品赠送";
    }else {
        self.reasonTextField.text = [self.reasonTextField.text stringByAppendingString:[NSString stringWithFormat:@" 活动礼品赠送"]];
    }
    [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.bottomBtn.enabled = YES;
}
- (IBAction)clickFourBtn:(id)sender {
    if ([self.reasonTextField.text isEqualToString:@""]) {
        self.reasonLabel.hidden = YES;
        self.reasonTextField.text = @"货物破损原因";
    }else {
        self.reasonTextField.text = [self.reasonTextField.text stringByAppendingString:[NSString stringWithFormat:@" 货物破损原因"]];
    }
    [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.bottomBtn.enabled = YES;
}
- (IBAction)clickFiveBtn:(id)sender {
    if ([self.reasonTextField.text isEqualToString:@""]) {
        self.reasonLabel.hidden = YES;
        self.reasonTextField.text = @"其它地区调货";
    }else {
        self.reasonTextField.text = [self.reasonTextField.text stringByAppendingString:[NSString stringWithFormat:@" 其它地区调货"]];
    }
    [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.bottomBtn.enabled = YES;
}
- (IBAction)clickSIxBtn:(id)sender {
    if ([self.reasonTextField.text isEqualToString:@""]) {
        self.reasonLabel.hidden = YES;
        self.reasonTextField.text = @"其它原因";
    }else {
        self.reasonTextField.text = [self.reasonTextField.text stringByAppendingString:[NSString stringWithFormat:@" 其它原因"]];
    }
    [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0]];
    self.bottomBtn.enabled = YES;
}

- (IBAction)clickBottomBtn:(id)sender {
    self.hiddenView.hidden = NO;
}

- (IBAction)clickHiddenViewBtn:(id)sender {
    self.hiddenView.hidden = YES;
}
- (IBAction)clickHiddenSureBtn:(id)sender {
    
    ANLog(@"确定");
    [self submitChangedSurplusStockRequest:self.goodsJsonString cupJsonString:self.cupJsonString desc:self.reasonTextField.text];
}

#pragma mark -- 提交库存数量
- (void)submitChangedSurplusStockRequest:(NSString *)goodsJsonString cupJsonString:(NSString *)cupJsonString desc:(NSString *)desc
{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.store_id forKey:@"store_id"];
    [parmDict setObject:goodsJsonString forKey:@"init_goods_list"];
    [parmDict setObject:cupJsonString forKey:@"init_cup_list"];
    
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [parmDict setObject:desc forKey:@"desc"];
    
    ANLog(@"AA : %@", parmDict);
    [ANHttpTool postWithUrl:@"/api/1/dealers/init_stock/" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        
        ANLog(@"BB : %@", responseObject);
        [self dismissViewControllerAnimated:YES completion:^{
            [ANNotificationCenter postNotificationName:@"popToRoot" object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error: %@",responseObject[@"message"]);
        
        ANCommon *alter = [[ANCommon alloc] init];
        [alter setAlertView:responseObject[@"message"]];
        
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail: %@",error);
    }];
}

@end

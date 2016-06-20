//
//  ANCupCheckViewController.m
//  baobaotangDealerAndMarket
//
//  Created by Eric on 16/1/19.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANCupCheckViewController.h"
#import "ANHttpTool.h"
#import "ANReasonCupCheckViewController.h"
#import "ANFirstGuideViewController.h"
#import "ANReasonCupCheckViewController.h"

@interface ANCupCheckViewController () <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *smallCupBoxCountView;
@property (weak, nonatomic) IBOutlet UIView *middleCupBoxCountView;
@property (weak, nonatomic) IBOutlet UIView *bigCupBoxCountView;
@property (weak, nonatomic) IBOutlet UIView *moreCupBoxCountView;
@property (weak, nonatomic) IBOutlet UIView *superCupBoxCountView;
@property (weak, nonatomic) IBOutlet UIView *paperBoxCountView;

/**
 *  前面比例数   杯/件
 */
@property (weak, nonatomic) IBOutlet UILabel *smallCupNumber;
@property (weak, nonatomic) IBOutlet UILabel *middleCupNumber;
@property (weak, nonatomic) IBOutlet UILabel *bigCupNumber;
@property (weak, nonatomic) IBOutlet UILabel *moreCupNumber;
@property (weak, nonatomic) IBOutlet UILabel *superCupNumber;
@property (weak, nonatomic) IBOutlet UILabel *paperBoxNumber;
/**
 *  请求下来的比例数
 */
@property (nonatomic, strong) NSString *smallNumber;
@property (nonatomic, strong) NSString *middleNumber;
@property (nonatomic, strong) NSString *bigNumber;
@property (nonatomic, strong) NSString *moreNumber;
@property (nonatomic, strong) NSString *superNumber;
@property (nonatomic, strong) NSString *paperNumber;


@property (weak, nonatomic) IBOutlet UITextField *smallCupTextField;
@property (weak, nonatomic) IBOutlet UIButton *smallCupButton;
@property (weak, nonatomic) IBOutlet UILabel *smallCupBoxLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallCupLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallCupLargeLabel;




@property (weak, nonatomic) IBOutlet UITextField *middleCupTextField;
@property (weak, nonatomic) IBOutlet UIButton *middleCupButton;
@property (weak, nonatomic) IBOutlet UILabel *middleCupBoxLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleCupLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleCupLargeLabel;



@property (weak, nonatomic) IBOutlet UITextField *bigCupTextField;
@property (weak, nonatomic) IBOutlet UIButton *bigCupButton;
@property (weak, nonatomic) IBOutlet UILabel *bigCupBoxLabel;
@property (weak, nonatomic) IBOutlet UILabel *bigCupLabel;
@property (weak, nonatomic) IBOutlet UILabel *bigCupLargeLabel;

@property (weak, nonatomic) IBOutlet UITextField *moreBigCupTextField;
@property (weak, nonatomic) IBOutlet UIButton *moreBigCupButton;
@property (weak, nonatomic) IBOutlet UILabel *moreBigCupBoxLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreBigCupLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreBigCupLargeLabel;


@property (weak, nonatomic) IBOutlet UITextField *superBigCupTextField;
@property (weak, nonatomic) IBOutlet UIButton *superBigCupButton;
@property (weak, nonatomic) IBOutlet UILabel *superBigCupBoxLabel;
@property (weak, nonatomic) IBOutlet UILabel *superBigCupLabel;
@property (weak, nonatomic) IBOutlet UILabel *superBigCupLargeLabel;

@property (weak, nonatomic) IBOutlet UITextField *paperTextField;
@property (weak, nonatomic) IBOutlet UIButton *paperButton;
@property (weak, nonatomic) IBOutlet UILabel *paperLabel;

/**
 *  杯子
 */
@property (nonatomic, copy) NSString *cupJsonString;


@end

@implementation ANCupCheckViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"盘点库存杯型页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"盘点库存杯型页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ANNotificationCenter addObserver:self selector:@selector(popToRootView) name:@"popToRoot" object:nil];
    
    [self setNavgation];
    
    self.smallCupBoxCountView.layer.borderColor = [UIColor colorWithRed:0.3447 green:0.3447 blue:0.3447 alpha:0.5].CGColor;
    self.middleCupBoxCountView.layer.borderColor = [UIColor colorWithRed:0.3447 green:0.3447 blue:0.3447 alpha:0.5].CGColor;
    self.bigCupBoxCountView.layer.borderColor = [UIColor colorWithRed:0.3447 green:0.3447 blue:0.3447 alpha:0.5].CGColor;
    self.moreCupBoxCountView.layer.borderColor = [UIColor colorWithRed:0.3447 green:0.3447 blue:0.3447 alpha:0.5].CGColor;
    self.superCupBoxCountView.layer.borderColor = [UIColor colorWithRed:0.3447 green:0.3447 blue:0.3447 alpha:0.5].CGColor;
    self.paperBoxCountView.layer.borderColor = [UIColor colorWithRed:0.3447 green:0.3447 blue:0.3447 alpha:0.5].CGColor;
    
    [self getCupSurplusStockRequest];
    
    
}
- (void)popToRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setNavgation
{
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"盘点杯桶";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

/**
 *  返回的点击事件
 */
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)smallCupButtonAction:(UIButton *)sender {
    ANLog(@"小杯");
    [self.smallCupTextField resignFirstResponder];
}

- (IBAction)middleCupButtonAction:(UIButton *)sender {
    ANLog(@"中杯");
    [self.middleCupTextField resignFirstResponder];
}

- (IBAction)bigCupButtonAction:(UIButton *)sender {
    ANLog(@"大杯");
    [self.bigCupTextField resignFirstResponder];
}

- (IBAction)moreBigCupButtonAction:(UIButton *)sender {
    ANLog(@"超大杯");
    [self.moreBigCupTextField resignFirstResponder];
}

- (IBAction)superBigCupButtonAction:(UIButton *)sender {
    ANLog(@"特大杯");
    [self.superBigCupTextField resignFirstResponder];
}

- (IBAction)paperButtonAction:(UIButton *)sender {
    ANLog(@"纸袋杯");
    [self.paperTextField resignFirstResponder];
}

- (IBAction)submitButtonAction:(UIButton *)sender {
    ANLog(@"完成盘点");
    
    NSDictionary *cupDic= @{@"1" : [self.smallCupBoxLabel.text substringToIndex:self.smallCupBoxLabel.text.length - 1],
                            @"2" : [self.middleCupBoxLabel.text substringToIndex:self.middleCupBoxLabel.text.length - 1],
                            @"3" : [self.bigCupBoxLabel.text substringToIndex:self.bigCupBoxLabel.text.length - 1],
                            @"4" : [self.moreBigCupBoxLabel.text substringToIndex:self.moreBigCupBoxLabel.text.length - 1],
                            @"5" : [self.superBigCupBoxLabel.text substringToIndex:self.superBigCupBoxLabel.text.length - 1],
                            @"6" : [self.paperLabel.text substringToIndex:self.paperLabel.text.length - 1]};
    
    ANLog(@"%@", cupDic);
    
    self.cupJsonString = [cupDic mj_JSONString];
    
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[ANFirstGuideViewController class]]) {
            UIAlertView *submitAlterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认盘点无误并完成递交" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [submitAlterView show];
            return;
        } else {
            ANReasonCupCheckViewController *reason = [[ANReasonCupCheckViewController alloc] init];
            [self presentViewController:reason animated:YES completion:^{
                reason.store_id = self.store_id;
                reason.goodsJsonString = self.goodsJsonString;
                reason.cupJsonString = self.cupJsonString;
            }];
            return;
        }
    }    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.smallCupTextField) {
        self.smallCupBoxLabel.text = [NSString stringWithFormat:@"%ld件", [textField.text integerValue]];
        self.smallCupLabel.text = [NSString stringWithFormat:@"%ld杯", [textField.text integerValue] * [self.smallNumber integerValue]];
        self.smallCupLargeLabel.hidden = YES;
    }
    if (textField == self.middleCupTextField) {
        self.middleCupBoxLabel.text = [NSString stringWithFormat:@"%ld件", [textField.text integerValue]];
        self.middleCupLabel.text = [NSString stringWithFormat:@"%ld杯", [textField.text integerValue] * [self.middleNumber integerValue]];
        self.middleCupLargeLabel.hidden = YES;
    }
    if (textField == self.bigCupTextField) {
        self.bigCupBoxLabel.text = [NSString stringWithFormat:@"%ld件", [textField.text integerValue]];
        self.bigCupLabel.text = [NSString stringWithFormat:@"%ld杯", [textField.text integerValue] * [self.bigNumber integerValue]];
        self.bigCupLargeLabel.hidden = YES;
    }
    if (textField == self.moreBigCupTextField) {
        self.moreBigCupBoxLabel.text = [NSString stringWithFormat:@"%ld件", [textField.text integerValue]];
        self.moreBigCupLabel.text = [NSString stringWithFormat:@"%ld杯", [textField.text integerValue] * [self.moreNumber integerValue]];
        self.moreBigCupLargeLabel.hidden = YES;
    }
    if (textField == self.superBigCupTextField) {
        self.superBigCupBoxLabel.text = [NSString stringWithFormat:@"%ld件", [textField.text integerValue]];
        self.superBigCupLabel.text = [NSString stringWithFormat:@"%ld杯", [textField.text integerValue] * [self.superNumber integerValue]];
        self.superBigCupLargeLabel.hidden = YES;
    }
    if (textField == self.paperTextField) {
        self.paperLabel.text = [NSString stringWithFormat:@"%ld个", [textField.text integerValue]];
    }
    textField.text = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 0 && 0 == [string integerValue]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [self submitChangedSurplusStockRequest:self.goodsJsonString cupJsonString:self.cupJsonString];
    }
}

#pragma mark -- 提交库存数量
- (void)submitChangedSurplusStockRequest:(NSString *)goodsJsonString cupJsonString:(NSString *)cupJsonString
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.store_id forKey:@"store_id"];
    [parmDict setObject:goodsJsonString forKey:@"init_goods_list"];
    [parmDict setObject:cupJsonString forKey:@"init_cup_list"];
    
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    
    [ANHttpTool postWithUrl:@"/api/1/dealers/init_stock" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"BB : %@", responseObject);
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error: %@",responseObject[@"message"]);
        ANCommon *alter = [[ANCommon alloc] init];
        [alter setAlertView:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail: %@",error);
    }];
}

#pragma mark -- 获取杯子的库存
- (void)getCupSurplusStockRequest
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.store_id forKey:@"store_id"];
    
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    
    ANLog(@"AA : %@", parmDict);
    [ANHttpTool postWithUrl:@"/api/1/cup/get_app_dealer_stock" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        
        ANLog(@"BB : %@", responseObject);
        [self setCupCount:responseObject[@"response"]];
        
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error: %@",responseObject[@"message"]);
        
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        
        ANLog(@"fail: %@",error);
    }];
}

- (void)setCupCount:(NSArray *)array
{
    if ([array[0][@"box_num"] integerValue] > 0) {
        self.smallCupLargeLabel.hidden = YES;
        self.smallCupBoxLabel.text = [NSString stringWithFormat:@"%@件", array[0][@"box_num"]];
        self.smallCupLabel.text = [NSString stringWithFormat:@"%ld杯", [array[0][@"box_num"] integerValue] * [array[0][@"cup2box_num"] integerValue]];
    }
    if ([array[1][@"box_num"] integerValue] > 0) {
        self.middleCupLargeLabel.hidden = YES;
        self.middleCupBoxLabel.text = [NSString stringWithFormat:@"%@件", array[1][@"box_num"]];
        self.middleCupLabel.text = [NSString stringWithFormat:@"%ld杯", [array[1][@"box_num"] integerValue] * [array[1][@"cup2box_num"] integerValue]];
    }
    if ([array[2][@"box_num"] integerValue] > 0) {
        self.bigCupLargeLabel.hidden = YES;
        self.bigCupBoxLabel.text = [NSString stringWithFormat:@"%@件", array[2][@"box_num"]];
        self.bigCupLabel.text = [NSString stringWithFormat:@"%ld杯", [array[2][@"box_num"] integerValue] * [array[2][@"cup2box_num"] integerValue]];
    }
    if ([array[3][@"box_num"] integerValue] > 0) {
        self.moreBigCupLargeLabel.hidden = YES;
        self.moreBigCupBoxLabel.text = [NSString stringWithFormat:@"%@件", array[3][@"box_num"]];
        self.moreBigCupLabel.text = [NSString stringWithFormat:@"%ld杯", [array[3][@"box_num"] integerValue] * [array[3][@"cup2box_num"] integerValue]];
    }
    if ([array[4][@"box_num"] integerValue] > 0) {
        self.superBigCupLargeLabel.hidden = YES;
        self.superBigCupBoxLabel.text = [NSString stringWithFormat:@"%@件", array[4][@"box_num"]];
        self.superBigCupLabel.text = [NSString stringWithFormat:@"%ld杯", [array[4][@"box_num"] integerValue] * [array[4][@"cup2box_num"] integerValue]];
    }
    if ([array[5][@"box_num"] integerValue] > 0) {
        self.paperLabel.text = [NSString stringWithFormat:@"%ld个", [array[5][@"box_num"] integerValue] * [array[5][@"cup2box_num"] integerValue]];
    }
    
    self.smallNumber = array[0][@"cup2box_num"];
    self.middleNumber = array[1][@"cup2box_num"];
    self.bigNumber = array[2][@"cup2box_num"];
    self.moreNumber = array[3][@"cup2box_num"];
    self.superNumber = array[4][@"cup2box_num"];
    
    self.smallCupNumber.text = [NSString stringWithFormat:@"%@杯/件", array[0][@"cup2box_num"]];
    self.middleCupNumber.text = [NSString stringWithFormat:@"%@杯/件",array[2][@"cup2box_num"]];
    self.bigCupNumber.text = [NSString stringWithFormat:@"%@杯/件",array[2][@"cup2box_num"]];
    self.moreCupNumber.text = [NSString stringWithFormat:@"%@杯/件",array[3][@"cup2box_num"]];
    self.superCupNumber.text = [NSString stringWithFormat:@"%@杯/件",array[4][@"cup2box_num"]];
}


@end

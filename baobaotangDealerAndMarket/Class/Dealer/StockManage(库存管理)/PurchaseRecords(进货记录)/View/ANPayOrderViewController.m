//
//  ANPayOrderViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/4/11.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANPayOrderViewController.h"
#import "ANHttpTool.h"

@interface ANPayOrderViewController ()<UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate>

/**
 *  姓名输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
/**
 *  选择时间按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
/**
 *  备注输入框
 */
@property (weak, nonatomic) IBOutlet UITextView *remarksTextView;
/**
 *  备注Label
 */
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;
/**
 *  确认按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/**
 *  时间选择控件
 */
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
/**
 *  时间视图
 */
@property (weak, nonatomic) IBOutlet UIView *timeView;
/**
 *  实际付款金额
 */
@property (weak, nonatomic) IBOutlet UITextField *payTextField;

@property (nonatomic, copy) NSString *aleartStr;

@end

@implementation ANPayOrderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigation];
    if ([self.model.payoff_person isEqualToString:@"暂无"]) {
        
        self.aleartStr = @"确定要上传凭证";
        
    }else {
        [self.timeBtn setTitle:self.model.payoff_time forState:UIControlStateNormal];
        [self.timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.nameTextField.text = self.model.payoff_person;
        self.payTextField.text = self.model.payoff_money;
        self.aleartStr = @"确定要修改凭证";
        if ([self.model.payoff_extra isEqualToString:@"暂无"]) {
            
        }else {
            self.remarksTextView.text = self.model.payoff_extra;
            self.remarksLabel.hidden = YES;
        }
    }
}

- (void)setNavigation
{
    self.navigationItem.title = @"上传凭证";
    
    // 中间的标题
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attribute];
    // 左边的按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnBtn)];
}
- (void)returnBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setModel:(ANPurchaseRecordsModel *)model
{
    if (_model != model) {
        _model = model;
    }
    if ([model.payoff_person isEqualToString:@"暂无"]) {
        
    }else {
        [self.timeBtn setTitle:model.payoff_time forState:UIControlStateNormal];
        self.nameTextField.text = model.payoff_person;
        if ([model.payoff_extra isEqualToString:@"暂无"]) {
            
        }else {
            self.remarksTextView.text = model.payoff_extra;
        }
    }
    return;
}

- (IBAction)clickTimeBtn:(id)sender {
    [self.nameTextField endEditing:YES];
    [self.remarksTextView endEditing:YES];
    self.timeView.hidden = NO;
}

- (IBAction)clickSureBtn:(id)sender {
    if ([self.nameTextField.text isEqualToString:@""]) {
        [ANCommon setAlertViewWithMessage:@"请填写付款人"];
        return;
    }
    if ([self.timeBtn.titleLabel.text isEqualToString:@"请告知付款时间"]) {
        [ANCommon setAlertViewWithMessage:@"请选择付款时间"];
        return;
    }
    if ([self.payTextField.text isEqualToString:@""]) {
        [ANCommon setAlertViewWithMessage:@"请填写付款金额"];
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:self.aleartStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self performSelector:@selector(commitCertificate) withObject:nil afterDelay:0.3f];
    }
}
- (void)commitCertificate
{
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:self.orderID forKey:@"order_id"];
    [paramsDict setObject:self.remarksTextView.text forKey:@"payoff_extra"];
    [paramsDict setObject:self.nameTextField.text forKey:@"payoff_person"];
    [paramsDict setObject:self.timeBtn.titleLabel.text forKey:@"payoff_time"];
    [paramsDict setObject:self.payTextField.text forKey:@"payoff_money"];
    paramsDict = (NSMutableDictionary *)[ANCommon dicToSign:paramsDict];
    ANLog(@"%@",paramsDict);
    [ANHttpTool postWithUrl:@"/api/1/dealers/trade_payoff_voucher" params:paramsDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [[ANCommon alloc] setAlertView:responseObject[@"message"]];
        [self.navigationController popViewControllerAnimated:YES];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
}
#pragma mark dataPicker
- (IBAction)clickTimeCancleBtn:(id)sender {
    self.timeView.hidden = YES;
    if ([self.timeBtn.titleLabel.text isEqualToString:@"请告知付款时间"]) {
        [self.timeBtn setTitle:@"请告知付款时间" forState:UIControlStateNormal];
        [self.timeBtn setTitleColor:[UIColor colorWithRed:0.7765 green:0.7765 blue:0.7765 alpha:1.0] forState:UIControlStateNormal];
    }
}
- (IBAction)clickTimeSureBtn:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:self.datePicker.date];
    NSLog(@"%@", strDate);
    [self.timeBtn setTitle:strDate forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.timeView.hidden = YES;
}
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.remarksLabel.hidden = YES;
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        self.remarksLabel.hidden = NO;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.nameTextField resignFirstResponder];
    
    [self.remarksTextView resignFirstResponder];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

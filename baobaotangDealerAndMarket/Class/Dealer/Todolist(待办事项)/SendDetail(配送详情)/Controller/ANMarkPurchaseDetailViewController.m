//
//  ANMarkPurchaseDetailViewController.m
//  baobaotang
//
//  Created by 高赛 on 15/12/7.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANMarkPurchaseDetailViewController.h"
#import "ANSubmitOrderesTableViewCell.h"
#import "ANHttpTool.h"
#import "ANPurchaseDetailModel.h"
#import "ANPurchaseOrderListModel.h"
#import "ANCancelOrderViewController.h"
#import "ANPurchaseOrderCupList.h"
#import "ANSelectMarketViewController.h"
#import "ANPeopleManageModel.h"
#import "ANSubStoreDetailViewController.h"
#import "ANPeopleDetailViewController.h"

@interface ANMarkPurchaseDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) ANPurchaseDetailModel *detailModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  支付方式
 */
@property (weak, nonatomic) IBOutlet UILabel *payType;
/**
 *  配送方式
 */
@property (weak, nonatomic) IBOutlet UILabel *deliverTypeLable;
/**
 *  收货人手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *mobileLabel;
/**
 *  积分
 */
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
/**
 *  抱抱币
 */
@property (weak, nonatomic) IBOutlet UILabel *baobaoLabel;
/**
 *  杯数
 */
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
/**
 *  合计
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/**
 *  纸袋的箱量
 */
@property (nonatomic, assign) int paperBagCup;
/**
 *  纸袋的数量
 */
@property (nonatomic, assign) int paperBagNum;
/**
 *  超大杯箱量
 */
@property (nonatomic, assign) int superBigCup;
/**
 *  超大杯数量
 */
@property (nonatomic, assign) int superBigNum;
/**
 *  较大被箱量
 */
@property (nonatomic, assign) int moreBigCup;
/**
 *  较大被数量
 */
@property (nonatomic, assign) int moreBigNum;
/**
 *  大杯箱量
 */
@property (nonatomic, assign) int bigCup;
/**
 *  大杯数量
 */
@property (nonatomic, assign) int bigNum;
/**
 *  中杯箱量
 */
@property (nonatomic, assign) int middleCup;
/**
 *  中杯数量
 */
@property (nonatomic, assign) int middleNum;
/**
 *  小杯箱量
 */
@property (nonatomic, assign) int smallCup;
/**
 *  小杯数量
 */
@property (nonatomic, assign) int smallNum;
/**
 *  hiddenView
 */
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
/**
 *  撤销订单视图
 */
@property (weak, nonatomic) IBOutlet UIView *hiddenTopView;

/**
 *  上面信息
 */
@property (weak, nonatomic) IBOutlet UILabel *topNameLabel;
/**
 *  上面右边信息
 */
@property (weak, nonatomic) IBOutlet UILabel *topLeftLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
/**
 *  杯桶配送按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *clickNumBtn;
/**
 *  小杯箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *boxSmallNum;
/**
 *  小杯杯数
 */
@property (weak, nonatomic) IBOutlet UILabel *cupSmallNum;
/**
 *  中杯箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *boxMiddleNum;
/**
 *  中杯杯数
 */
@property (weak, nonatomic) IBOutlet UILabel *cupMiddleNum;
/**
 *  大杯箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *boxBigNum;
/**
 *  大杯杯数
 */
@property (weak, nonatomic) IBOutlet UILabel *cupBigNum;
/**
 *  较大杯箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *boxMoreBigNum;
/**
 *  较大杯杯数
 */
@property (weak, nonatomic) IBOutlet UILabel *cupMoreBigNum;
/**
 *  超大杯箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *boxSuperBigNum;
/**
 *  超大杯杯数
 */
@property (weak, nonatomic) IBOutlet UILabel *cupSuperBigNum;
/**
 *  纸袋箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *boxPaperNum;
/**
 *  纸袋袋数4
 */
@property (weak, nonatomic) IBOutlet UILabel *cupPaperNum;
/**
 *  备注textField
 */
@property (weak, nonatomic) IBOutlet UITextView *remarksTextField;
/**
 *  是否取消
 */
@property (nonatomic, assign) BOOL isCancel;
/**
 *  据底部按钮的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
/**
 *  据底部视图的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;
/**
 *  底部视图
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/**
 *  确认送达按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sureSendBtn;
@property (weak, nonatomic) IBOutlet UILabel *boxNumLabel;
/**
 *  开始处理按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *beginSolveBtn;
/**
 *  开始处理视图
 */
@property (weak, nonatomic) IBOutlet UIView *sendView;
/**
 *  开始处理视图 取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sendCancelBtn;
/**
 *  开始处理视图 确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sendSureBtn;
/**
 *  默认人员姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *defaultNameLabel;
/**
 *  默认人员打勾视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *defaultImg;
/**
 *  市场人员配送姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *marketNameLabel;
/**
 *  市场人员配送打勾视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *marketImg;
/**
 *  市场人员配送三角视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *marketSanjiaoImg;
/**
 *  市场人员点击按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *marketBtn;
/**
 *  第三方处理打勾视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *otherImg;
/**
 *  处理状态    0为默认 1为其他 2为市场人员
 */
@property (nonatomic, copy) NSString *isSend;
/**
 *  处理其他人视图
 */
@property (weak, nonatomic) IBOutlet UIView *otherView;
/**
 *  第三方姓名
 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
/**
 *  第三方手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
/**
 *  处理状态  0 开始处理   1 确认收货
 */
@property (nonatomic, assign) BOOL arrangeStatus;
/**
 *  是否为等待响应状态,1为是 0为不是
 */
@property (nonatomic, assign) BOOL isPhone;
/**
 *  处理页面
 */
@property (weak, nonatomic) IBOutlet UIView *processView;
/**
 *  处理label
 */
@property (weak, nonatomic) IBOutlet UILabel *processLabel;
/**
 *  是否支配市场人员配送  1为是  0为不是
 */
@property (nonatomic, assign) BOOL isMarket;
/**
 *  市场人员
 */
@property (nonatomic, strong) ANPeopleManageModel *peopleModel;
#pragma mark 支付状态
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UIView *leftPayView;
@property (weak, nonatomic) IBOutlet UIButton *leftPayBtn;
@property (weak, nonatomic) IBOutlet UILabel *leftPayLabel;

@property (weak, nonatomic) IBOutlet UIView *rightPayView;
@property (weak, nonatomic) IBOutlet UILabel *rightPayLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightPayBtn;
/**
 *  收款的提示窗口
 */
@property (nonatomic, strong) UIAlertView *payAlertView;
/**
 *  收款的状态
 */
@property (nonatomic, assign) BOOL requestPayType;
@property (nonatomic, strong) UIWebView *webView;

@property (weak, nonatomic) IBOutlet UITextField *addressLabel;

@end

@implementation ANMarkPurchaseDetailViewController

- (UIAlertView *)payAlertView
{
    if (_payAlertView == nil) {
        _payAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认改变收款状态?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    return _payAlertView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"配送详情页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"配送详情页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isSend = @"0";
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"OtherPerson"];
    if (dict) {
        self.nameTextField.text = dict[@"name"];
        self.phoneTextField.text = dict[@"phone"];
    }
    
    [ANNotificationCenter addObserver:self selector:@selector(selectMarketSend:) name:@"selectPeople" object:nil];
    
    self.defaultNameLabel.text = [NSString stringWithFormat:@"%@签约",self.signedName];
    
#pragma 付款状态模块
    self.rightPayView.layer.cornerRadius = 5;
    self.rightPayView.layer.masksToBounds = YES;
    self.rightPayView.layer.borderWidth = 1;
    self.rightPayView.layer.borderColor = [UIColor colorWithRed:0.8196 green:0.8196 blue:0.8196 alpha:1.0].CGColor;
    self.leftPayView.layer.cornerRadius = 5;
    self.leftPayView.layer.masksToBounds = YES;
    self.leftPayView.layer.borderWidth = 1;
    self.leftPayView.layer.borderColor = [UIColor colorWithRed:0.8196 green:0.8196 blue:0.8196 alpha:1.0].CGColor;
    
    
    
    self.sendCancelBtn.layer.cornerRadius = 5;
    self.sendCancelBtn.layer.masksToBounds = YES;
    self.sendCancelBtn.layer.borderWidth = 1;
    self.sendCancelBtn.layer.borderColor = [UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0].CGColor;
    
    self.sendSureBtn.layer.cornerRadius = 5;
    self.sendSureBtn.layer.masksToBounds = YES;
    self.sendSureBtn.layer.borderWidth = 1;
    self.sendSureBtn.layer.borderColor = [UIColor colorWithRed:0.1521 green:0.0867 blue:0.2218 alpha:1.0].CGColor;
    
    self.sureSendBtn.layer.cornerRadius = 5;
    self.sureSendBtn.layer.masksToBounds = YES;
//    self.sureSendBtn.layer.borderWidth = 1;
//    self.sureSendBtn.layer.borderColor = [UIColor colorWithRed:0.1135 green:0.0617 blue:0.1692 alpha:1.0].CGColor;
    
    self.beginSolveBtn.layer.borderWidth = 1;
    self.beginSolveBtn.layer.borderColor = [UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0].CGColor;
    
    // 设置navgation
    self.topNameLabel.text = [NSString stringWithFormat:@"%@ | %@",self.storeName,self.storePeople];
//    self.topLeftLabel.text = [NSString stringWithFormat:@"签约人:%@>>",self.signedName];
//#warning 记得过来
    if ([self.model.progress isEqualToString:@"15"] || [self.model.progress isEqualToString:@"10"]) { //配送完成或订单取消
//        self.cancleBtn.enabled = NO;
//        [self.cancleBtn setBackgroundColor:[UIColor grayColor]];
        [self.bottomView removeFromSuperview];
//        self.bottomView.hidden = YES;
//        self.cancleBtn.hidden = YES;
//        self.beginSolveBtn.hidden = YES;
        NSLayoutConstraint *bottomviewCon = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
//        [self.view removeConstraint:self.bottomConstraint];
        [self.view addConstraint:bottomviewCon];
    }else if ([self.model.progress isEqualToString:@"5"]) { // 正在配送
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"] isEqualToString:@"10"]) { // 市场人员
            self.sureSendBtn.hidden = NO;
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"] isEqualToString:@"5"]) { // 经销商
            if ([self.model.storeInfo.marketingUserInfo.ID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]]) {  // 指派自己配送
                self.sureSendBtn.hidden = NO;
            }else {// 指派他人配送
                [self.bottomView removeFromSuperview];
                NSLayoutConstraint *bottomviewCon = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
                [self.view addConstraint:bottomviewCon];
            }
        }
        //        [self.view removeConstraint:self.bottomConstraint];
    }
#pragma mark 收款模块
//    if ([self.model.progress isEqualToString:@"10"]) {
//        self.payView.hidden = NO;
//        if ([self.model.is_pay isEqualToString:@"1"]) {
//            self.leftPayBtn.enabled = YES;
//            self.rightPayBtn.enabled = NO;
//        }else {
//            self.leftPayLabel.textColor = [UIColor whiteColor];
//            self.leftPayView.backgroundColor = [UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0];
//            self.leftPayBtn.enabled = NO;
//            self.rightPayLabel.textColor = [UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0];
//            self.rightPayView.backgroundColor = [UIColor whiteColor];
//            self.rightPayBtn.enabled = YES;
//        }
//    }else {
//        self.payView.hidden = YES;
//    }
    
    [self setNavgation];
    [self requestData];
    [ANNotificationCenter addObserver:self selector:@selector(changeCancle) name:@"cancle" object:nil];
}
- (void)changeCancle
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setNavgation
{
    self.navigationItem.title = @"订单详情";
    
    // 中间的标题
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attribute];
    // 左边的按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(navLeftClickedAction:)];
    
    
    // 右边按钮
    //changeOrder
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 80, 30);
//    [rightBtn setImage:[UIImage imageNamed:@"changeOrder"] forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    NSString *str1 = @" 修改订单";
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:str1];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.397988809121622] range:NSMakeRange(0,1)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(1,str1.length - 1)];
//    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 1)];
//    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1, str1.length - 1)];
//    [rightBtn setAttributedTitle:str forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(navRightClickedAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
/**
 *  nav右边的点击事件
 */
- (void)navRightClickedAction:(UIButton *)btn
{
    ANLog(@"修改订单");
}
/**
 *  nav左边的点击事件
 */
- (void)navLeftClickedAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancalButtonAction:(id)sender {
    self.hiddenView.hidden = YES;
}
- (IBAction)clickSureBtn:(id)sender {
    self.hiddenView.hidden = YES;
//    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
//    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
//    [parmDict setObject:self.order_id forKey:@"order_id"];
//    [parmDict setObject:@"15" forKey:@"progress"];
//    [parmDict setObject:@"" forKey:@"store_id"];
}
- (IBAction)clickOrderBtn:(id)sender {
//    self.hiddenView.hidden = NO;
    ANCancelOrderViewController *cancelOrder = [[ANCancelOrderViewController alloc] init];
    cancelOrder.order_id = self.order_id;
    cancelOrder.storeID = self.storeID;
    cancelOrder.viewControllerNum = @"1";
    [self presentViewController:cancelOrder animated:YES completion:nil];
}
#pragma mark ---- SendView
// 配送界面确认按钮
- (IBAction)clickbeginSolveBtn:(id)sender {
    if (self.isPhone) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否对市场人员进行电话催办" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }else {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"] isEqualToString:@"10"]) {
            self.processLabel.text = @"确认处理本单 掌柜将收到通知";
            self.processView.hidden = NO;
            self.arrangeStatus = NO;
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"] isEqualToString:@"5"]) {
            self.sendView.hidden = NO;
        }
    }
}
// 配送界面返回按钮
- (IBAction)clickESCBtn:(id)sender {
    self.sendView.hidden = YES;
}
#pragma mark 收款模块
- (IBAction)clickLeftPayBtn:(id)sender {
    self.payAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认该订单未收款?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [self.payAlertView show];
}
- (IBAction)clickRightPayBtn:(id)sender {
    self.payAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认该订单已收款?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [self.payAlertView show];
}
- (void)changePayType
{
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    if ([self.detailModel.is_pay isEqualToString:@"1"]) {
        [paramsDict setObject:@"0" forKey:@"is_pay"];
        self.requestPayType = NO;
    }else {
        [paramsDict setObject:@"1" forKey:@"is_pay"];
        self.requestPayType = YES;
    }
    [paramsDict setObject:self.detailModel.ID forKey:@"order_id"];
    NSDictionary *params = [ANCommon dicToSign:paramsDict];
    ANLog(@"%@",params);
    [ANHttpTool postWithUrl:@"/api/1/order/change_order_pay_status" params:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        if (self.requestPayType) {
            self.leftPayLabel.textColor = [UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0];
            self.leftPayView.backgroundColor = [UIColor whiteColor];
            self.leftPayBtn.enabled = YES;
            self.rightPayLabel.textColor = [UIColor whiteColor];
            self.rightPayView.backgroundColor = [UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0];
            self.rightPayBtn.enabled = NO;
            self.detailModel.is_pay = @"1";
        }else {
            self.leftPayLabel.textColor = [UIColor whiteColor];
            self.leftPayView.backgroundColor = [UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0];
            self.leftPayBtn.enabled = NO;
            self.rightPayLabel.textColor = [UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0];
            self.rightPayView.backgroundColor = [UIColor whiteColor];
            self.rightPayBtn.enabled = YES;
            self.detailModel.is_pay = @"0";
        }
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
}

// 点击默认签约人员配送
- (IBAction)clickDefaultBtn:(id)sender {
    self.defaultImg.image = [UIImage imageNamed:@"send_select"];
    self.marketSanjiaoImg.hidden = NO;
    self.marketImg.hidden = YES;
    self.otherImg.image = nil;
    self.otherView.hidden = YES;
    self.isSend = @"0";
}
// 点击选择市场人员配送
- (IBAction)clickMarketPeopleBtn:(id)sender {
    ANSelectMarketViewController *selectMarketVC = [[ANSelectMarketViewController alloc] init];
    selectMarketVC.marketing_id = self.model.storeInfo.marketingUserInfo.ID;
    [self.navigationController pushViewController:selectMarketVC animated:YES];
}
// 选择了市场人员
- (void)selectMarketSend:(NSNotification *)notification
{
    self.peopleModel = notification.userInfo[@"selectPeople"];
    self.marketNameLabel.text = [NSString stringWithFormat:@"%@配送",self.peopleModel.realname];
    self.defaultImg.image = nil;
    self.marketSanjiaoImg.hidden = YES;
    self.marketImg.hidden = NO;
    self.otherImg.image = nil;
    self.otherView.hidden = YES;
    self.isSend = @"2";
}
// 点击指派其他人员配送
- (IBAction)clickOtherBtn:(id)sender {
    self.defaultImg.image = nil;
    self.marketSanjiaoImg.hidden = NO;
    self.marketImg.hidden = YES;
    self.otherImg.image = [UIImage imageNamed:@"send_select"];
    self.otherView.hidden = NO;
    self.isSend = @"1";
}
- (IBAction)clickSendSureBtn:(id)sender {
    if ([self.isSend isEqualToString:@"1"]) {
        if ([self.nameTextField.text isEqualToString:@""]) {
            [ANCommon setAlertViewWithMessage:@"请输入姓名"];
            return;
        }
        
        if (self.phoneTextField.text.length != 11) {
            [ANCommon setAlertViewWithMessage:@"请输入正确的手机格式"];
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.nameTextField.text forKey:@"name"];
        [dict setObject:self.phoneTextField.text forKey:@"phone"];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"OtherPerson"];
    }
    if ([self.isSend isEqualToString:@"1"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确认%@开始处理本单配送并告知掌柜",self.nameTextField.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }else if([self.isSend isEqualToString:@"0"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确认%@开始处理本单配送并告知掌柜。", self.signedName] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.phone = self.model.storeInfo.marketingUserInfo.mobile;
        [alertView show];
    }else if ([self.isSend isEqualToString:@"2"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确认%@开始处理本单配送并告知掌柜。", self.peopleModel.realname] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        self.phone = self.peopleModel.mobile;
        [alertView show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.view endEditing:YES];
    if (buttonIndex == 1) {
        if (alertView == self.payAlertView) {
            [self changePayType];
        }else {
            if (self.isPhone) {
                ANLog(@"电话催单");
                [self callTel];
            }else {
                [self sendRequestData];
            }
        }
    }
}
/**
 *  打电话
 */
- (void)callTel
{
    self.webView = [[UIWebView alloc] init];
    NSString *telStr = [NSString stringWithFormat:@"tel://%@", self.phone];
    NSURL *url = [NSURL URLWithString:telStr] ;
    
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestUrl];
}
- (IBAction)clickTelBtn:(id)sender {
    self.webView = [[UIWebView alloc] init];
    NSString *telStr = [NSString stringWithFormat:@"tel://%@", self.mobileLabel.text];
    NSURL *url = [NSURL URLWithString:telStr] ;
    
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestUrl];
}

#pragma mark ----详情跳转
/**
 *  跳转门店
 */
- (IBAction)clickGoToStoreBtn:(id)sender {
    ANSubStoreDetailViewController *subStoreVC = [[ANSubStoreDetailViewController alloc] init];
    
    subStoreVC.storeID = self.model.store_id;
    subStoreVC.owner_id = self.model.storeInfo.owner_id;
    subStoreVC.typeID = self.model.storeInfo.type;
    
    [self.navigationController pushViewController:subStoreVC animated:YES];
}
/**
 *  跳转人员
 */
- (IBAction)clickGoToPeopleBtn:(id)sender {
    NSString *typeID = [[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if ([typeID isEqualToString:@"5"]) {
        if ([self.model.storeInfo.marketingUserInfo.ID isEqualToString:userID]) {
            
        }else {
            ANPeopleDetailViewController *peopleDetailVC = [[ANPeopleDetailViewController alloc] init];
            peopleDetailVC.marketing_id = self.model.storeInfo.marketingUserInfo.ID;
            [self.navigationController pushViewController:peopleDetailVC animated:YES];
        }
    }
}


#pragma mark ----处理方式请求
- (void)sendRequestData
{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.order_id forKey:@"order_no"];
    if ([self.isSend isEqualToString:@"1"]) {
        [parmDict setObject:@"0" forKey:@"assigned_id"];
        [parmDict setObject:self.nameTextField.text forKey:@"other_assigned_name"];
        [parmDict setObject:self.phoneTextField.text forKey:@"other_assigned_mobile"];
    }else if ([self.isSend isEqualToString:@"0"]) {
        [parmDict setObject:self.model.storeInfo.marketingUserInfo.ID forKey:@"assigned_id"];
    }else if ([self.isSend isEqualToString:@"2"]) {
        [parmDict setObject:self.peopleModel.ID forKey:@"assigned_id"];
    }
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    ANLog(@"%@",parmDict);
    [ANHttpTool postWithUrl:@"/api/1/dealers/assigned_order" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self sendParseSubStoreData:responseObject];
        ANLog(@"-------------------------------------------------------------------------指派人员配送");
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
        
        ANLog(@"error:%@",responseObject);
//        if ([responseObject[@"message"] isEqualToString:@"指派人手机号格式不正确"]) {
//            [ANCommon setAlertViewWithMessage:@"指派人手机号格式不正确"];
//        }
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)sendParseSubStoreData:(id)data
{
    ANLog(@"%@",data);
    self.sendView.hidden = YES;
    if (([self.model.storeInfo.marketingUserInfo.ID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]] && [self.isSend isEqualToString:@"0"]) || [self.isSend isEqualToString:@"1"]) {
        //            self.arrangeStatus = YES;
        // 如果签约人是经销商自己或者指派第三方 就立即发货
        [self beginSend];
        return;
    }
    [self requestData];
}
/**
 *  如果签约人是经销商自己 就立即发货
 */
- (void)beginSend
{
    self.hiddenView.hidden = YES;
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.order_id forKey:@"order_id"];
    [parmDict setObject:self.storeID forKey:@"store_id"];
    if (self.arrangeStatus) {
        [parmDict setObject:@"10" forKey:@"progress"];
    }else {
        [parmDict setObject:@"5" forKey:@"progress"];
    }
    ANLog(@"%@",parmDict);
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/order/update_order_progress" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self sureParseSubStoreData:responseObject];
        ANLog(@"-------------------------------------------------------------------------改变订单状态");
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)sureParseSubStoreData:(id)data
{
    self.sendView.hidden = YES;
    NSString *str = data[@"message"];
    if ([str isEqualToString:@"success"]) {
    }
    [self requestData];
}
/**
 *  确认送达点击事件
 */
- (IBAction)clickSureSendView:(id)sender {
    ANLog(@"确认送达");
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"] isEqualToString:@"10"]) {
        self.processLabel.text = @"确认掌柜已经收货 并通知合伙人";
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"] isEqualToString:@"5"]){
        self.processLabel.text = @"确认送达并告知掌柜";
    }
    self.processView.hidden = NO;
    self.arrangeStatus = YES;
}
#pragma mark ---- processView 处理页面

- (IBAction)hiddenProcessView:(id)sender {
    self.processView.hidden = YES;
}

- (IBAction)clickProcessSureBtn:(id)sender {
    [self beginSend];
    self.processView.hidden = YES;
}

#pragma mark ---- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailModel.order_relation_list.count;
//    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANSubmitOrderesTableViewCell *cell = [ANSubmitOrderesTableViewCell submitOrderTableViewCell:tableView];
    ANPurchaseOrderListModel *orderModel = self.detailModel.order_relation_list[indexPath.row];
    cell.orderListModel = orderModel;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

#pragma mark ---- 网络请求
- (void)requestData
{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.storeID forKey:@"store_id"];
    [parmDict setObject:self.order_id forKey:@"order_id"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/order/get_order_detail" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseTaskLoadData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)parseTaskLoadData:(id)data
{
    ANLog(@"%@",data);
    
    self.detailModel = [ANPurchaseDetailModel mj_objectWithKeyValues:data[@"response"]];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *dict in self.detailModel.order_relation_list) {
        ANPurchaseOrderListModel *orderModel = [ANPurchaseOrderListModel mj_objectWithKeyValues:dict];
        [tempArr addObject:orderModel];
    }
    NSMutableArray *cupArr = [NSMutableArray array];
    for (NSDictionary *dict in self.detailModel.order_cup_list) {
        ANPurchaseOrderCupList *cupModel = [ANPurchaseOrderCupList mj_objectWithKeyValues:dict];
        [cupArr addObject:cupModel];
    }
    self.detailModel.order_relation_list = tempArr;
    self.detailModel.order_cup_list = cupArr;
    [self.tableView reloadData];
    [self setData];
    
}
- (void)setData
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"] isEqualToString:@"10"]) {
        if ([self.detailModel.progress isEqualToString:@"10"] || [self.detailModel.progress isEqualToString:@"15"]) {
            [self.bottomView removeFromSuperview];
            //        self.bottomView.hidden = YES;
            //        self.cancleBtn.hidden = YES;
            //        self.beginSolveBtn.hidden = YES;
            NSLayoutConstraint *bottomviewCon = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
            //        [self.view removeConstraint:self.bottomConstraint];
            [self.view addConstraint:bottomviewCon];
        }else if ([self.detailModel.progress isEqualToString:@"1"] && [self.detailModel.is_assigned isEqualToString:@"1"]) {    // 等待响应的状态
            if (![self.detailModel.assigned_id isEqualToString:@"0"]) {
                [self.beginSolveBtn setTitle:@"开始配送" forState:UIControlStateNormal];
            }else {// 让第三方处理
                NSLayoutConstraint *bottomviewCon = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
                //        [self.view removeConstraint:self.bottomConstraint];
                [self.view addConstraint:bottomviewCon];
            }
        }else if ([self.detailModel.progress isEqualToString:@"1"]) {
            self.sureSendBtn.hidden = YES;
        }else if ([self.detailModel.progress isEqualToString:@"5"]) {
            self.sureSendBtn.hidden = NO;
        }
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"] isEqualToString:@"5"]) { // 指派经销商
        if ([self.detailModel.progress isEqualToString:@"10"] || [self.detailModel.progress isEqualToString:@"15"]) {
            // 配送完成或取消订单
            //        self.bottomView.hidden = YES;
            //        self.cancleBtn.hidden = YES;
            //        self.beginSolveBtn.hidden = YES;
            [self.bottomView removeFromSuperview];
            NSLayoutConstraint *bottomviewCon = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
            //        [self.view removeConstraint:self.bottomConstraint];
            [self.view addConstraint:bottomviewCon];
        }else if ([self.detailModel.progress isEqualToString:@"1"] && [self.detailModel.is_assigned isEqualToString:@"1"]) {// 等待响应状态
            if (![self.detailModel.assigned_id isEqualToString:@"0"]) { // 指派的市场人员
                [self.beginSolveBtn setTitle:@"电话催办" forState:UIControlStateNormal];
                [self.beginSolveBtn setTitleColor:[UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0] forState:UIControlStateNormal];
                [self.beginSolveBtn setBackgroundColor:[UIColor whiteColor]];
                if ([self.phone isEqualToString:@""]) {
//                    self.phone = 
                }
//                [self.beginSolveBtn]
                self.isPhone = YES;
            }else {// 指派的第三方 无等待响应状态
                [self.bottomView removeFromSuperview];
                NSLayoutConstraint *bottomviewCon = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
                //        [self.view removeConstraint:self.bottomConstraint];
                [self.view addConstraint:bottomviewCon];
            }
        }else if ([self.detailModel.progress isEqualToString:@"1"]) { // 等待配送状态
            self.sureSendBtn.hidden = YES;
        }else if ([self.detailModel.progress isEqualToString:@"5"]) { // 正在配送状态
            if (![self.detailModel.assigned_id isEqualToString:@"0"]) { // 指派市场人员
                if ([self.model.storeInfo.marketingUserInfo.ID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]] ) { // 如果指派的是经销商自己
                    self.sureSendBtn.hidden = NO;
                }else {
                    [self.bottomView removeFromSuperview];
                    NSLayoutConstraint *bottomviewCon = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
                    [self.view addConstraint:bottomviewCon];
                }
                //        [self.view removeConstraint:self.bottomConstraint];
            }else { // 指派第三方
                [self.bottomView removeFromSuperview];
                NSLayoutConstraint *bottomviewCon = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
                //        [self.view removeConstraint:self.bottomConstraint];
                [self.view addConstraint:bottomviewCon];
            }
        }
    }
    self.addressLabel.text = self.model.storeInfo.address;
    if ([self.detailModel.note isEqualToString:@""]) {
        self.remarksTextField.text = @"暂无备注";
    }else {
        self.remarksTextField.text = [NSString stringWithFormat:@"%@",self.detailModel.note];
    }
    self.remarksTextField.font = [UIFont systemFontOfSize:14];
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",self.detailModel.price];
    if ([self.detailModel.bbcoin isEqualToString:@"0"]) {
        self.integralLabel.text = [NSString stringWithFormat:@"+%@积分",self.detailModel.score];
    }else {
        self.integralLabel.text = [NSString stringWithFormat:@"+%@积分 +%@抱抱币",self.detailModel.score, self.detailModel.bbcoin];
    }
    if ([self.detailModel.pay_type isEqualToString:@"1"]) {
        self.payType.text = @"上门收款";
    }else if ([self.detailModel.pay_type isEqualToString:@"5"]) {
        self.payType.text = @"微信支付";
    }else if ([self.detailModel.pay_type isEqualToString:@"10"]) {
        self.payType.text = @"支付宝支付";
    }else if ([self.detailModel.pay_type isEqualToString:@"15"]) {
        self.payType.text = @"银联在线支付";
    }
    if ([self.detailModel.deliver_type isEqualToString:@"1"]) {
        self.deliverTypeLable.text = @"上门送货";
    }
    self.mobileLabel.text = self.detailModel.mobile;
    
#pragma mark 收款模块
    if ([self.detailModel.progress isEqualToString:@"10"]) {
        self.payView.hidden = NO;
        if ([self.detailModel.is_pay isEqualToString:@"1"]) {
            self.leftPayBtn.enabled = YES;
            self.rightPayBtn.enabled = NO;
        }else {
            self.leftPayLabel.textColor = [UIColor whiteColor];
            self.leftPayView.backgroundColor = [UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0];
            self.leftPayBtn.enabled = NO;
            self.rightPayLabel.textColor = [UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0];
            self.rightPayView.backgroundColor = [UIColor whiteColor];
            self.rightPayBtn.enabled = YES;
        }
    }else {
        self.payView.hidden = YES;
    }
#pragma mark 杯子模块
    int boxNum = 0;
    for (ANPurchaseOrderListModel *model in self.detailModel.order_relation_list) {
        boxNum += [model.goods_num intValue];
    };
    self.boxNumLabel.text = [NSString stringWithFormat:@"(共%d箱)",boxNum];
    for (ANPurchaseOrderCupList *model in self.detailModel.order_cup_list) {
        if ([model.cup_type isEqualToString:@"1"]) {        // 小杯
            self.smallCup = [model.box_num intValue];
            self.smallNum = [model.cup_num intValue];
        }else if ([model.cup_type isEqualToString:@"2"]) {  // 中杯
            self.middleCup = [model.box_num intValue];
            self.middleNum = [model.cup_num intValue];
        }else if ([model.cup_type isEqualToString:@"3"]) {  // 大杯
            self.bigCup = [model.box_num intValue];
            self.bigNum = [model.cup_num intValue];
        }else if ([model.cup_type isEqualToString:@"4"]) {  // 较大杯
            self.moreBigCup = [model.box_num intValue];
            self.moreBigNum = [model.cup_num intValue];
        }else if ([model.cup_type isEqualToString:@"5"]) {  // 超大杯
            self.superBigCup = [model.box_num intValue];
            self.superBigNum = [model.cup_num intValue];
        }else if ([model.cup_type isEqualToString:@"6"]) {  // 纸袋
            self.paperBagCup = [model.box_num intValue];
            self.paperBagNum = [model.cup_num intValue];
        }
    }
    if (self.smallCup == 0 && self.middleCup == 0 && self.bigCup == 0 && self.moreBigCup == 0 && self.superBigCup == 0 && self.paperBagCup == 0) {
        self.numLabel.text = @"没有散装货品无需配送";
    } else {
        self.numLabel.text = @"点击查看配送杯桶详单";
        self.numLabel.textColor = [UIColor redColor];
        self.clickNumBtn.enabled = YES;
    }
}
- (IBAction)clickNumBtns:(id)sender {
    self.boxSmallNum.text = [NSString stringWithFormat:@"%d箱",self.smallCup];
    self.cupSmallNum.text = [NSString stringWithFormat:@"%d杯",self.smallNum];
    
    self.boxMiddleNum.text = [NSString stringWithFormat:@"%d箱",self.middleCup];
    self.cupMiddleNum.text = [NSString stringWithFormat:@"%d杯",self.middleNum];
    
    self.boxBigNum.text = [NSString stringWithFormat:@"%d箱",self.bigCup];
    self.cupBigNum.text = [NSString stringWithFormat:@"%d杯",self.bigNum];
    
    self.boxMoreBigNum.text = [NSString stringWithFormat:@"%d箱",self.moreBigCup];
    self.cupMoreBigNum.text = [NSString stringWithFormat:@"%d杯",self.moreBigNum];
    
    self.boxSuperBigNum.text = [NSString stringWithFormat:@"%d箱",self.superBigCup];
    self.cupSuperBigNum.text = [NSString stringWithFormat:@"%d杯",self.superBigNum];
    
    self.boxPaperNum.text = [NSString stringWithFormat:@"%d箱",self.paperBagCup];
    self.cupPaperNum.text = [NSString stringWithFormat:@"%d袋",self.paperBagNum];
    
    self.hiddenView.hidden = NO;
}
- (void)dealloc
{
    [ANNotificationCenter removeObserver:self name:@"selectPeople" object:nil];
}

@end

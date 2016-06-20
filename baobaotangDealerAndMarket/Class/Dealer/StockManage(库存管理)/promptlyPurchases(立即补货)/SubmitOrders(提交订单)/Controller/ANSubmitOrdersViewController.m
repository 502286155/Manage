//
//  ANSubmitOrdersViewController.m
//  baobaotang
//
//  Created by Eric on 15/11/4.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANSubmitOrdersViewController.h"
#import "ANSubmitOrderesTableViewCell.h"
#import "ANPatternOfPaymentViewController.h"
#import "ANPaySuccessViewController.h"
#import "ANSendMethodViewController.h"
#import "ANPurchasesViewController.h"
#import "ANHttpTool.h"
#import "ANSubmitPurchasesModel.h"
#import "ANSendAddressViewController.h"

@interface ANSubmitOrdersViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, ANSendAddressViewControllerDelegate>

/**
 *  headView间隔
 */
@property (weak, nonatomic) IBOutlet UILabel *headSpacingLabel;
/**
 *  footView间隔
 */
@property (weak, nonatomic) IBOutlet UILabel *footSpacingLabel;
/**
 *  默认的收货电话
 */
@property (weak, nonatomic) IBOutlet UITextField *mobileLabel;
/**
 *  更新手机号按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *upDataMobileButton;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
/**
 *  杯桶配送数量Label
 */
@property (weak, nonatomic) IBOutlet UILabel *cupNumLabel;
/**
 *  杯桶右边的箭头图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *cupRightImg;
/**
 *  杯桶上的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cupButton;


/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UILabel *secondLine;
@property (weak, nonatomic) IBOutlet UILabel *thirdLine;
@property (weak, nonatomic) IBOutlet UILabel *lastLine;
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
@property (weak, nonatomic) IBOutlet UIView *integralView;
/**
 *  配送地址Label
 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
/**
 *  修改电话视图
 */
@property (weak, nonatomic) IBOutlet UIView *phoneView;
/**
 *  修改电话确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *phoneSureBtn;
/**
 *  修改电话输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
/**
 *  备注视图
 */
@property (weak, nonatomic) IBOutlet UIView *remarkView;

/**
 *  特别情况备注Label
 */
@property (weak, nonatomic) IBOutlet UILabel *remarkMessageLabel;

/**
 *  备注视图取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *remarkCancalButton;
/**
 *  备注视图确认按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *remarkSureButton;

/**
 *  备注内容
 */
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;

/**
 *  提示框
 */
@property (weak, nonatomic) IBOutlet UILabel *remarkPlaceHolderlabel;

/**
 *  配送前打电话
 */
@property (weak, nonatomic) IBOutlet UIButton *remarkCallButton;

/**
 *  请多配送杯桶
 */
@property (weak, nonatomic) IBOutlet UIButton *remarkCupButton;

/**
 *  请多配送物料
 */
@property (weak, nonatomic) IBOutlet UIButton *remarkMaterialButton;

/**
 *  期望送货时间
 */
@property (weak, nonatomic) IBOutlet UIButton *remarkTimeButton;

/**
 *  配送地点变更
 */
@property (weak, nonatomic) IBOutlet UIButton *remarkAddressButton;

/**
 *  结款期望方式
 */
@property (weak, nonatomic) IBOutlet UIButton *remarkPayTypeButton;
/**
 *  配送方式
 */
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;
/**
 *  支付方式
 */
@property (weak, nonatomic) IBOutlet UILabel *patternLabel;

@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *bbcoinLabel;

/**
 *  查看更多
 */
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

/**
 *  cell的个数
 */
@property (nonatomic, assign) NSInteger cellCount;

/**
 *  更多按钮的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreButtonConstraint;

/**
 *  箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *totalBoxCount;

/**
 *  地址数组
 */
@property (nonatomic, strong) NSMutableArray *addressArray;
/**
 *  默认经销商地址编号
 */
@property (nonatomic, copy) NSString *dealer_address_id;
/**
 *  收货人姓名
 */
@property (weak, nonatomic) IBOutlet UITextField *addressName;
@property (weak, nonatomic) IBOutlet UITextView *integralTextView;

@end

@implementation ANSubmitOrdersViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"经销商进货提交页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"经销商进货提交页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.moreButton.layer.borderWidth = 1;
    self.moreButton.layer.borderColor = [UIColor colorWithHexString:@"#D1D1D1"].CGColor;
    self.navigationController.navigationBarHidden = NO;
    
    self.dealer_address_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"dealer_address_id"];
    
    // 设置navgation
    [self setNavgation];
    
    [self integralRule];
    
    [self setSubViews];
    [ANNotificationCenter addObserver:self selector:@selector(setSend:) name:@"send" object:nil];
    [ANNotificationCenter addObserver:self selector:@selector(setPatterm:) name:@"patterm" object:nil];
    
    NSString *isBaoEnable = [[NSUserDefaults standardUserDefaults] objectForKey:@"baobaobiEnable"];
    if ([isBaoEnable isEqualToString:@"1"]) {   //打开
        self.bbcoinLabel.text = [NSString stringWithFormat:@"现有%@个抱抱币(开始累积)",[[NSUserDefaults standardUserDefaults] objectForKey:@"bbcoin"]];
    }else {     // 关闭
        self.bbcoinLabel.text = @"现有0个抱抱币(暂未开始)";
    }
#pragma mark 仓库模块
    
    self.mobileLabel.enabled = NO;
    self.addressName.enabled = NO;
    
    self.totalBoxCount.text = [NSString stringWithFormat:@"共%ld箱", self.totalBox];
    
    if (self.isLastOrder) {
        self.cupButton.enabled = NO;
    }
    
    [self requestintegral];
    
    if (self.dataArray.count > 3) {
        self.cellCount = 3;
    } else {
        self.cellCount = self.dataArray.count;
        self.moreButton.hidden = YES;
        
        NSLayoutConstraint *moreButtonConstraint = [NSLayoutConstraint constraintWithItem:self.moreButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        [self.moreButton removeConstraint:self.moreButtonConstraint];
        [self.moreButton addConstraint:moreButtonConstraint];
    }
}

/**
 *  设置navgation
 */
- (void)setNavgation
{
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnPurchViewClick)];
    // 设置标题
    self.navigationItem.title = @"确认订单";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)setSubViews
{
    self.headSpacingLabel.layer.borderColor = ANColor(222, 222, 222).CGColor;
    self.footSpacingLabel.layer.borderColor = ANColor(222, 222, 222).CGColor;
    
    self.upDataMobileButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    NSAttributedString *attrbutStr = [[NSAttributedString alloc] initWithString:@"修改" attributes:@{NSUnderlineStyleAttributeName : @"1"}];
    [self.upDataMobileButton setAttributedTitle:attrbutStr forState:UIControlStateNormal];
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.totalPrice];
    self.mobileLabel.enabled = NO;
    self.remarkTextView.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.remarkCallButton.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.remarkCupButton.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.remarkMaterialButton.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.remarkTimeButton.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.remarkAddressButton.layer.borderColor = ANColor(206, 206, 206).CGColor;
    self.remarkPayTypeButton.layer.borderColor = ANColor(206, 206, 206).CGColor;
    [self setCupNum];
}
- (void)setCupNum
{
    ANLog(@"%ld, %ld, %ld, %ld, %ld, %ld", self.smallCup, self.middleCup, self.bigCup, self.moreBigCup, self.superBigCup, self.paperBagCup);
    
    if (self.smallCup == 0 && self.middleCup == 0 && self.bigCup == 0 && self.moreBigCup == 0 && self.superBigCup == 0 && self.paperBagCup == 0) {
        self.cupNumLabel.text = @"没有散装货品无需配送";
        self.cupButton.enabled = NO;
        self.cupRightImg.image = [UIImage imageNamed:@"sanjiao_gray"];
    } else {
        NSString *cupTypeStr = [NSString string];
        if (self.smallCup != 0) {
            cupTypeStr = [cupTypeStr stringByAppendingString:[NSString stringWithFormat:@"%ld箱配小杯 ", self.smallCup]];
        }
        if (self.middleCup != 0) {
            cupTypeStr = [cupTypeStr stringByAppendingString:[NSString stringWithFormat:@"%ld箱配中杯 ", self.middleCup]];
        }
        if (self.bigCup != 0) {
            cupTypeStr = [cupTypeStr stringByAppendingString:[NSString stringWithFormat:@"%ld箱配大杯 ", self.bigCup]];
        }
        if (self.moreBigCup != 0) {
            cupTypeStr = [cupTypeStr stringByAppendingString:[NSString stringWithFormat:@"%ld箱配超大杯 ", self.moreBigCup]];
        }
        if (self.superBigCup != 0) {
            cupTypeStr = [cupTypeStr stringByAppendingString:[NSString stringWithFormat:@"%ld箱配特大杯 ", self.superBigCup]];
        }
        if (self.paperBagCup!= 0) {
            cupTypeStr = [cupTypeStr stringByAppendingString:[NSString stringWithFormat:@"%ld箱配纸袋", self.paperBagCup]];
        }
        self.cupNumLabel.text = cupTypeStr;
    }
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.secondLine.bounds = CGRectMake(0, 0, WIDTH, 1);
    self.thirdLine.bounds = CGRectMake(0, 0, WIDTH, 1);
    self.lastLine.bounds = CGRectMake(0, 0, WIDTH, 1);
}

/**
 *  返回的点击事件
 */
- (void)returnPurchViewClick
{
    
    for (UIViewController *viewC in self.navigationController.viewControllers) {
        if ([viewC isKindOfClass:[ANPurchasesViewController class]]) {
            [self.navigationController popToViewController:viewC animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANSubmitOrderesTableViewCell *cell = [ANSubmitOrderesTableViewCell submitOrderTableViewCell:tableView];
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellCount;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}
- (void)setSend:(NSNotification *)notification
{
    self.sendLabel.text = notification.userInfo[@"name"];
}
- (void)setPatterm:(NSNotification *)notification
{
    self.patternLabel.text = notification.userInfo[@"name"];
}

/**
 *  查看更多
 */
- (IBAction)moreButtonAction:(UIButton *)sender {
    
    if (sender.selected == YES) {
        sender.transform = CGAffineTransformMakeRotation(M_PI * 2);
        sender.selected = NO;
        self.cellCount = 3;
    } else {
        sender.transform = CGAffineTransformMakeRotation(M_PI * 1);
        sender.selected = YES;
        self.cellCount = self.dataArray.count;
    }
    [self.tableView reloadData];
}

/**
 *  点击杯桶配送
 */
- (IBAction)clickCupTypeBtn:(id)sender {
    ANLog(@"杯桶配送");
    [self.navigationController popViewControllerAnimated:YES];
    [ANNotificationCenter postNotificationName:@"submit" object:nil];
}



/**
 *  点击进货奖励
 */
- (IBAction)clickRewardsBtn:(id)sender {
    ANLog(@"进货奖励");
    [[ANCommon alloc] setAlertView:@"积分将在确认到货后到账"];
}

// 点击抵用币
- (IBAction)clickDiYongBtn:(id)sender {
    ANLog(@"抵用币");
//    [[ANCommon alloc] setAlertView:@"抱抱币抵用系统暂未开放"];
    [self clickShowBtn:nil];
}

// 点击支付方式
- (IBAction)clickPayBtn:(id)sender {
    ANPatternOfPaymentViewController *patternOfPaymentVC = [[ANPatternOfPaymentViewController alloc] init];
    [self.navigationController pushViewController:patternOfPaymentVC animated:YES];
}

// 配送方式的点击事件
- (IBAction)clickSendMethod:(id)sender {
    ANSendMethodViewController *sendMethodVC = [[ANSendMethodViewController alloc] init];
    [self.navigationController pushViewController:sendMethodVC animated:YES];
}
/**
 *  点击了去仓库按钮
 */
- (IBAction)clickAddressBtn:(id)sender {
    ANSendAddressViewController *sendAddressVC = [[ANSendAddressViewController alloc] init];
    
    sendAddressVC.isHaveData = NO;
    
    sendAddressVC.delegate = self;
    [self.navigationController pushViewController:sendAddressVC animated:YES];
}
#pragma mark ANSendAddressViewControllerDelegate
- (void)sendAddressViewController:(ANSendAddressViewController *)sendAddressViewController andDataArr:(NSMutableArray *)dataArr andAddressModel:(ANSendAddressModel *)addressModel
{
    ANLog(@"%@",addressModel);
    [[NSUserDefaults standardUserDefaults] setObject:addressModel.dealer_address forKey:@"dealer_address"];
    [[NSUserDefaults standardUserDefaults] setObject:addressModel.ID forKey:@"dealer_address_id"];
    [[NSUserDefaults standardUserDefaults] setObject:addressModel.dealer_name forKey:@"dealer_name"];
    [[NSUserDefaults standardUserDefaults] setObject:addressModel.dealer_mobile forKey:@"dealer_mobile"];
    self.dealer_address_id = addressModel.ID;
    self.addressArray = dataArr;
    self.addressLabel.text = addressModel.dealer_address;
    self.addressName.text = addressModel.dealer_name;
    self.mobileLabel.text = addressModel.dealer_mobile;
}

/**
 *  点击弹层视图隐藏
 */
- (IBAction)clickHiddenView:(id)sender
{
    if (self.phoneView.hidden && self.remarkView.hidden) {
        
        self.hiddenView.hidden = YES;
        self.integralView.hidden = YES;
        
    } else if (self.remarkView.hidden == NO) {
        [self remarkViewAnimation];
        [self.remarkTextView resignFirstResponder];
    }
}
/**
 *  关闭弹层点击事件
 */
- (IBAction)clickHiddenBtn:(id)sender {
    self.hiddenView.hidden = YES;
    self.integralView.hidden = YES;
    self.phoneView.hidden = YES;
}
/**
 *  备注信息
 */
- (IBAction)remarkButtonClickedAction:(id)sender {
    ANLog(@"备注信息");
    self.hiddenView.hidden = NO;
    [self remarkViewAnimation];
    self.phoneView.hidden = YES;
    self.integralView.hidden = YES;
}
/**
 *  积分显示点击事件
 */
- (IBAction)clickShowBtn:(id)sender {
    self.hiddenView.hidden = NO;
    self.integralView.hidden = NO;
    //其他视图隐藏
    self.phoneView.hidden = YES;
    self.remarkView.hidden = YES;
}
/**
 *  修改电话显示点击事件
 */
- (IBAction)clickChangePhoneBtn:(id)sender {
    self.hiddenView.hidden = NO;
    self.phoneView.hidden = NO;
    // 其他视图隐藏
    self.integralView.hidden = YES;
    self.remarkView.hidden = YES;
}
/**
 *  修改电话确定按钮
 */
- (IBAction)clickPhoneSureBtn:(id)sender {
    if (self.phoneTextField.text.length == 0) {
        [[ANCommon alloc] setAlertView:@"号码不能为空"];
        return;
    }else if (self.phoneTextField.text.length != 11) {
        [[ANCommon alloc] setAlertView:@"手机号格式不对"];
    }else {
        self.mobileLabel.text = self.phoneTextField.text;
        self.hiddenView.hidden = YES;
        self.integralView.hidden = YES;
        self.phoneView.hidden = YES;
        //    self.remarkView.hidden = YES;
        [self remarkViewAnimation];
        [self.remarkTextView resignFirstResponder];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.remarkPlaceHolderlabel.hidden = NO;
    } else {
        self.remarkPlaceHolderlabel.hidden = YES;
    }
}

- (void)remarkViewAnimation
{
    if (self.remarkView.hidden == YES) {
        self.remarkView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.remarkView.y = HIGH - 261 - 64;
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            self.remarkView.y = HIGH;
        } completion:^(BOOL finished) {
            self.remarkView.hidden = YES;
            self.hiddenView.hidden = YES;
        }];
    }
}

/**
 *  备注  取消
 */
- (IBAction)remarkCancalButtonAction:(id)sender {
    
//    self.hiddenView.hidden = YES;
//    self.remarkView.hidden = YES;
    [self remarkViewAnimation];
    [self.remarkTextView resignFirstResponder];
}

/**
 *  备注  确认
 */
- (IBAction)remarkMakeSureAction:(id)sender {
    ANLog(@"确认");
    if (self.remarkTextView.text.length != 0) {
        self.remarkMessageLabel.text = self.remarkTextView.text;
    }
    [self remarkViewAnimation];
    [self.remarkTextView resignFirstResponder];
}

/**
 *  配送前电话沟通
 */
- (IBAction)remarkCallButtonAction:(id)sender {
    if ([self.remarkTextView.text isEqualToString:@""]) {
        self.remarkTextView.text = @"配送前电话沟通：";
        self.remarkPlaceHolderlabel.hidden = YES;
    }else {
        self.remarkTextView.text = [self.remarkTextView.text stringByAppendingString:@"配送前电话沟通："];
    }
}

/**
 *  多配杯桶
 */
- (IBAction)remarkCupButton:(id)sender {
    if ([self.remarkTextView.text isEqualToString:@""]) {
        self.remarkTextView.text = @"多配送杯桶期望数量为：";
        self.remarkPlaceHolderlabel.hidden = YES;
    }else {
        self.remarkTextView.text = [self.remarkTextView.text stringByAppendingString:@"多配送杯桶期望数量为："];
    }
}

/**
 *  多配物料
 */
- (IBAction)remarkMaterialAction:(id)sender {
    if ([self.remarkTextView.text isEqualToString:@""]) {
        self.remarkTextView.text = @"配送物料期望有：";
        self.remarkPlaceHolderlabel.hidden = YES;
    }else {
        self.remarkTextView.text = [self.remarkTextView.text stringByAppendingString:@"配送物料期望有："];
    }
}

/**
 *  期望送货时间
 */
- (IBAction)remarkTimeAction:(id)sender {
    if ([self.remarkTextView.text isEqualToString:@""]) {
        self.remarkTextView.text = @"配送时间希望为：";
        self.remarkPlaceHolderlabel.hidden = YES;
    }else {
        self.remarkTextView.text = [self.remarkTextView.text stringByAppendingString:@"配送时间希望为："];
    }
}

/**
 *  配送地点变更
 */
- (IBAction)remarkAddressAction:(id)sender {
    if ([self.remarkTextView.text isEqualToString:@""]) {
        self.remarkTextView.text = @"配送地点变更为：";
        self.remarkPlaceHolderlabel.hidden = YES;
    }else {
        self.remarkTextView.text = [self.remarkTextView.text stringByAppendingString:@"配送地点变更为："];
    }
}

/**
 *  结款期望方式
 */
- (IBAction)remarkPayTypeButton:(id)sender {
    if ([self.remarkTextView.text isEqualToString:@""]) {
        self.remarkTextView.text = @"本次结款希望：";
        self.remarkPlaceHolderlabel.hidden = YES;
    }else {
        self.remarkTextView.text = [self.remarkTextView.text stringByAppendingString:@"本次结款希望："];
    }
}

/**
 *  提交订单
 */
- (IBAction)submitOrderButtonAction:(id)sender {
    
    if ([self.addressLabel.text isEqualToString:@"请选择配送仓库地址"]) {
        [ANCommon setAlertViewWithMessage:@"请选择仓库地址后在提交"];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认订单无误 递交后系统将为您处理 请耐心等候、如有变更请撤销重新下单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
    ANLog(@"提交订单");
    self.payBtn.enabled = NO;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self postSubmitOrder];
    }else {
        self.payBtn.enabled = YES;
    }
}

#pragma mark ----网络请求
- (void)postSubmitOrder
{
    NSMutableArray *postArray = [NSMutableArray new];
    for (ANSubmitPurchasesModel *subMod in self.dataArray) {
        NSMutableDictionary *dic = [subMod mj_JSONObject];
//        [dic removeObjectForKey:@"cover"];
        [postArray addObject:dic];
    }
    NSString *postString = [postArray mj_JSONString];
    
    NSString *cupListJsonStr = [self.cupListArr mj_JSONString];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"agencyStoreId"] forKey:@"store_id"];                           // 商铺id
    [parmDict setValue:cupListJsonStr forKey:@"cup_list"];                 // 散装杯的类型
    [parmDict setValue:@"1" forKey:@"deliver_type"];                       // 配送方式
    [parmDict setValue:postString forKey:@"order_goods_list"];             // 商品信息    (json格式)
    [parmDict setValue:@"1" forKey:@"order_type"];                         // 订单类型
    [parmDict setValue:@"1" forKey:@"pay_type"];                           // 支付方式  (1 => 上门收款 | 5 => 微信支付 | 10 => 支付宝支付 | 15 => 银联在线支付)
    if (self.remarkTextView.text.length != 0) {
        [parmDict setValue:self.remarkTextView.text forKey:@"note"];
    }else {
        [parmDict setObject:@"" forKey:@"note"];
    }
    [parmDict setValue:[NSString stringWithFormat:@"%.2f", self.totalPrice] forKey:@"price"];  // 订单总价格
    
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    
    [parmDict setObject:self.dealer_address_id forKey:@"dealer_address_id"];
    
    ANLog(@"parmDict : %@", parmDict);
    [ANHttpTool postWithUrl:@"/api/1/dealers/trade_order" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"--%@", responseObject);
        [self parseTaskLoadData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [[ANCommon alloc] setAlertView:responseObject[@"message"]];
        ANLog(@"responseObject:%@",responseObject[@"message"]);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"error:%@",error);
    }];
}

- (void)parseTaskLoadData:(id)data
{
    if (0 == [data[@"flag"] integerValue]) {
        ANPaySuccessViewController *payVC = [[ANPaySuccessViewController alloc] init];
        payVC.order_id = data[@"response"][@"order_id"];
        payVC.store_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"agencyStoreId"];
        [self.navigationController pushViewController:payVC animated:YES];
    } else {
        [[ANCommon alloc] setAlertView:data[@"message"]];
    }
}

- (void)integralRule
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"agency" forKey:@"type"];
    
    [ANHttpTool postWithUrl:@"/api/1/store/get_baobaob_rule_text" params:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        self.integralTextView.text = responseObject[@"message"][@"info"];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
}

- (void)requestintegral
{
    NSInteger boxNum = 0;
    for (ANSubmitPurchasesModel *model in self.dataArray) {
        boxNum += model.goods_num;
    }
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:[NSString stringWithFormat:@"%ld",(long)boxNum] forKey:@"box_num"];
    [parmDict setObject:[NSString stringWithFormat:@"%f",self.totalPrice] forKey:@"price"];
    [parmDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"agencyStoreId"] forKey:@"store_id"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    NSString *isBaoEnable = [[NSUserDefaults standardUserDefaults] objectForKey:@"baobaobiEnable"];
    [parmDict setObject:isBaoEnable forKey:@"is_bbcoin_enable"];
    [ANHttpTool postWithUrl:@"/api/1/score/score_format" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"success:%@",responseObject);
        self.integralLabel.text = [NSString stringWithFormat:@"+%@积分",responseObject[@"response"][@"score"]];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
@end

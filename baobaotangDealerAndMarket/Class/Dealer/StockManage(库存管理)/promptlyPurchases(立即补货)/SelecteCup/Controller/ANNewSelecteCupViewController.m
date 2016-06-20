//
//  ANNewSelecteCupViewController.m
//  baobaotangDealerAndMarket
//
//  Created by Eric on 15/12/26.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANNewSelecteCupViewController.h"
#import "ANHttpTool.h"
#import "ANCupTypeModel.h"
#import "ANSubmitOrdersViewController.h"

@interface ANNewSelecteCupViewController () <UITextFieldDelegate>


/**
 *  散装箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *bulkCountLabel;

/**
 *  选好了, 递交订单
 */
@property (weak, nonatomic) IBOutlet UIButton *immediatelyButton;

#pragma mark -- 小杯
/**
 *  小杯 爆米花箱数
 */
@property (weak, nonatomic) IBOutlet UITextField *smallPopcornCountTextField;
/**
 *  小杯 杯子数
 */
@property (weak, nonatomic) IBOutlet UILabel *smallCupCountLable;
/**
 *  小杯 杯子箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *smallBoxCountLabel;

#pragma mark -- 中杯
/**
 *  中杯 爆米花箱数
 */
@property (weak, nonatomic) IBOutlet UITextField *middlePopcornCountTextField;
/**
 *  中杯 杯子数
 */
@property (weak, nonatomic) IBOutlet UILabel *middleCupCountLable;
/**
 *  中杯 杯子箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *middleBoxCountLabel;

#pragma mark -- 大杯
/**
 *  大杯 爆米花箱数
 */
@property (weak, nonatomic) IBOutlet UITextField *bigPopcornCountTextField;
/**
 *  大杯 杯子数
 */
@property (weak, nonatomic) IBOutlet UILabel *bigCupCountLable;
/**
 *  大杯 杯子箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *bigBoxCountLabel;

#pragma mark -- 较大杯
/**
 *  较大杯 爆米花箱数
 */
@property (weak, nonatomic) IBOutlet UITextField *moreBigPopcornCountTextField;
/**
 *  较大杯 杯子数
 */
@property (weak, nonatomic) IBOutlet UILabel *moreBigCupCountLable;
/**
 *  较大杯 杯子箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *moreBigBoxCountLabel;

#pragma mark -- 超级杯
/**
 *  超级杯 爆米花箱数
 */
@property (weak, nonatomic) IBOutlet UITextField *superBigPopcornCountTextField;
/**
 *  超级杯 杯子数
 */
@property (weak, nonatomic) IBOutlet UILabel *superBigCupCountLable;
/**
 *  超级杯 杯子箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *superBigBoxCountLabel;

#pragma mark -- 纸袋
/**
 *  纸袋 爆米花箱数
 */
@property (weak, nonatomic) IBOutlet UITextField *paperPopcornCountTextField;
/**
 *  纸袋 纸袋数
 */
@property (weak, nonatomic) IBOutlet UILabel *paperCountLable;
/**
 *  纸袋 纸袋箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *paperBoxCountLabel;

/**
 *  小杯数量
 */
@property (nonatomic, assign) NSInteger smallCup;
/**
 *  中杯数量
 */
@property (nonatomic, assign) NSInteger middleCup;
/**
 *  大杯数量
 */
@property (nonatomic, assign) NSInteger bigCup;

/**
 *  较大杯数量
 */
@property (nonatomic, assign) NSInteger moreBigCup;
/**
 *  超大杯数量
 */
@property (nonatomic, assign) NSInteger superBigCup;
/**
 *  纸袋数量
 */
@property (nonatomic, assign) NSInteger paperBagCup;

@property (nonatomic, strong) UIView *errorView;

@property (nonatomic, assign) BOOL isSubmitVC;
@property (weak, nonatomic) IBOutlet UIImageView *cupDefaultImg;

/**
 *  提示Label
 */
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation ANNewSelecteCupViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick beginLogPageView:@"经销商进货选杯型页"];//("PageOne"为页面名称，可自定义)
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick endLogPageView:@"经销商进货选杯型页"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 杯型输入类型标示
    self.smallPopcornCountTextField.tag = UITextFieldCupTypeSmall;
    self.middlePopcornCountTextField.tag = UITextFieldCupTypeMiddle;
    self.bigPopcornCountTextField.tag = UITextFieldCupTypeBig;
    self.moreBigPopcornCountTextField.tag = UITextFieldCupTypeMoreBig;
    self.superBigPopcornCountTextField.tag = UITextFieldCupTypeSupperBig;
    self.paperPopcornCountTextField.tag = UITextFieldCupTypePaperBag;
    
    self.bulkCountLabel.text = [NSString stringWithFormat:@"%ld箱散装货品", self.bulkCount];
    
    [ANNotificationCenter addObserver:self selector:@selector(changeIsSubmitVC) name:@"submit" object:nil];
    
    [self requestCupImg];
    
}
- (void)changeIsSubmitVC
{
    self.isSubmitVC = YES;
}

- (IBAction)cancelButtonAction:(id)sender {

    if (self.isSubmitVC) {
        [self immediatelyButtonAction:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  选好了,递交订单事件
 */
- (IBAction)immediatelyButtonAction:(id)sender {
    
    ANLog(@"选好了,递交订单");
    self.smallCup = [self.smallPopcornCountTextField.text integerValue];
    self.middleCup = [self.middlePopcornCountTextField.text integerValue];
    self.bigCup = [self.bigPopcornCountTextField.text integerValue];
    self.moreBigCup = [self.moreBigPopcornCountTextField.text integerValue];
    self.superBigCup = [self.superBigPopcornCountTextField.text integerValue];
    self.paperBagCup = [self.paperPopcornCountTextField.text integerValue];
    
    NSArray *cupListArr = @[@{@"box_num" : self.smallPopcornCountTextField.text, @"cup_type" : @"1"},
                            @{@"box_num" : self.middlePopcornCountTextField.text, @"cup_type" : @"2"},
                            @{@"box_num" : self.bigPopcornCountTextField.text, @"cup_type" : @"3"},
                            @{@"box_num" : self.moreBigPopcornCountTextField.text, @"cup_type" : @"4"},
                            @{@"box_num" : self.superBigPopcornCountTextField.text, @"cup_type" : @"5"},
                            @{@"box_num" : self.paperPopcornCountTextField.text, @"cup_type" : @"6"}];
    
    ANSubmitOrdersViewController *submitOrders = [[ANSubmitOrdersViewController alloc] init];
    submitOrders.smallCup = self.smallCup;
    submitOrders.middleCup = self.middleCup;
    submitOrders.bigCup = self.bigCup;
    submitOrders.moreBigCup = self.moreBigCup;
    submitOrders.superBigCup = self.superBigCup;
    submitOrders.paperBagCup  = self.paperBagCup;
    submitOrders.dataArray = self.dataArray;
    submitOrders.totalPrice = self.totalPrice;
    submitOrders.cupListArr = cupListArr;
    submitOrders.totalBox = self.totalBox;
    [self.navigationController pushViewController:submitOrders animated:YES];
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{

    
    NSInteger cupBoxCount = [self.smallPopcornCountTextField.text integerValue] + [self.middlePopcornCountTextField.text integerValue] + [self.bigPopcornCountTextField.text integerValue] + [self.moreBigPopcornCountTextField.text integerValue] + [self.superBigPopcornCountTextField.text integerValue] + [self.paperPopcornCountTextField.text integerValue];

    
    if (cupBoxCount < self.bulkCount || cupBoxCount == self.bulkCount) {
        
        [self requestCupCountWithBoxNumber:textField];
        
    } else {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"已超出预订,请重新分配"];
        [self setNavErrorView];
        [self setMarkedWords:textField];
    }
    
    // 提交订单按钮可点
    
    NSInteger tempCount = [self.smallPopcornCountTextField.text integerValue] + [self.middlePopcornCountTextField.text integerValue] + [self.bigPopcornCountTextField.text integerValue] + [self.moreBigPopcornCountTextField.text integerValue] + [self.superBigPopcornCountTextField.text integerValue] + [self.paperPopcornCountTextField.text integerValue];
    self.bulkCountLabel.text = [NSString stringWithFormat:@"%ld箱散装货品", self.bulkCount - tempCount];
    if (tempCount == self.bulkCount) {
        self.immediatelyButton.enabled = YES;
        self.immediatelyButton.backgroundColor = ANColor(62, 37, 88);
    } else {
        self.immediatelyButton.enabled = NO;
        self.immediatelyButton.backgroundColor = ANColor(231, 231, 231);
    }
    
}

- (void)setNavErrorView
{
    [self.view addSubview:self.errorView];
    [UIView animateWithDuration:0.5 animations:^{
        self.errorView.y = -20;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(removeError) withObject:self.errorView afterDelay:1];
    }];
}
- (void)removeError
{
    [UIView animateWithDuration:0.5 animations:^{
        self.errorView.height = -64;
    } completion:^(BOOL finished) {
        [self.errorView removeFromSuperview];
    }];
}

- (void)requestCupCountWithBoxNumber:(UITextField *)textField
{
    
    NSDictionary *scaleDic = @{@"1" : [NSString stringWithFormat:@"%ld",
                                       [self.smallPopcornCountTextField.text integerValue]],
                               @"2" : [NSString stringWithFormat:@"%ld",
                                       [self.middlePopcornCountTextField.text integerValue]],
                               @"3" : [NSString stringWithFormat:@"%ld",
                                       [self.bigPopcornCountTextField.text integerValue]],
                               @"4" : [NSString stringWithFormat:@"%ld",
                                       [self.moreBigPopcornCountTextField.text integerValue]],
                               @"5" : [NSString stringWithFormat:@"%ld",
                                       [self.superBigPopcornCountTextField.text integerValue]],
                               @"6" : [NSString stringWithFormat:@"%ld",
                                       [self.paperPopcornCountTextField.text integerValue]]};
    
    NSString *scaleStr = [scaleDic mj_JSONString];
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:[NSString stringWithFormat:@"%ld", self.bulkCount] forKey:@"box_num"];
    [parmDict setObject:scaleStr forKey:@"scale"];
    [parmDict setObject:self.stordID forKey:@"store_id"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    ANLog(@"%@", parmDict);
    [ANHttpTool postWithUrl:@"/api/1/cup/get_cup_data" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        
        ANLog(@"进校上选杯 : %@", responseObject[@"response"][@"info"]);
        [self parseDataSetCupCount:responseObject[@"response"]  textField:textField];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject[@"message"]);
        
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
    
}
- (void)parseDataSetCupCount:(id)data  textField:(UITextField *)textField
{
    ANCupTypeModel *smallCupModel = [ANCupTypeModel mj_objectWithKeyValues:data[@"1"]];
    self.smallCupCountLable.text = [NSString stringWithFormat:@"%@杯", smallCupModel.cup_num];
    self.smallBoxCountLabel.text = [NSString stringWithFormat:@"%@杯", smallCupModel.true_cup_num];
    
    ANCupTypeModel *middleCupModel = [ANCupTypeModel mj_objectWithKeyValues:data[@"2"]];
    self.middleCupCountLable.text = [NSString stringWithFormat:@"%@杯", middleCupModel.cup_num];
    self.middleBoxCountLabel.text = [NSString stringWithFormat:@"%@杯", middleCupModel.true_cup_num];
    
    
    ANCupTypeModel *bigCupModel = [ANCupTypeModel mj_objectWithKeyValues:data[@"3"]];
    self.bigCupCountLable.text = [NSString stringWithFormat:@"%@杯", bigCupModel.cup_num];
    self.bigBoxCountLabel.text = [NSString stringWithFormat:@"%@杯", bigCupModel.true_cup_num];
    
    ANCupTypeModel *moreBigCupModel = [ANCupTypeModel mj_objectWithKeyValues:data[@"4"]];
    self.moreBigCupCountLable.text = [NSString stringWithFormat:@"%@杯", moreBigCupModel.cup_num];
    self.moreBigBoxCountLabel.text = [NSString stringWithFormat:@"%@杯", moreBigCupModel.true_cup_num];
    
    ANCupTypeModel *superBigCupModel = [ANCupTypeModel mj_objectWithKeyValues:data[@"5"]];
    self.superBigCupCountLable.text = [NSString stringWithFormat:@"%@杯", superBigCupModel.cup_num];
    self.superBigBoxCountLabel.text = [NSString stringWithFormat:@"%@杯", superBigCupModel.true_cup_num];
    
    ANCupTypeModel *paperBagCupModel = [ANCupTypeModel mj_objectWithKeyValues:data[@"6"]];
    self.paperCountLable.text = [NSString stringWithFormat:@"%@袋", paperBagCupModel.cup_num];
    self.paperBoxCountLabel.text = [NSString stringWithFormat:@"%@袋", paperBagCupModel.true_cup_num];
    
}

- (void)setMarkedWords:(UITextField *)textField
{
    textField.text = @"";
    if (textField == self.smallPopcornCountTextField) {
        self.smallCupCountLable.text = @"0杯";
        self.smallBoxCountLabel.text = @"0杯";
    }
    if (textField == self.middlePopcornCountTextField) {
        self.middleCupCountLable.text = @"0杯";
        self.middleBoxCountLabel.text = @"0杯";
    }
    if (textField == self.bigPopcornCountTextField) {
        self.bigCupCountLable.text = @"0杯";
        self.bigBoxCountLabel.text = @"0杯";
    }
    if (textField == self.moreBigPopcornCountTextField) {
        self.moreBigCupCountLable.text = @"0杯";
        self.moreBigBoxCountLabel.text = @"0杯";
    }
    if (textField == self.superBigPopcornCountTextField) {
        self.superBigCupCountLable.text = @"0杯";
        self.superBigBoxCountLabel.text = @"0杯";
    }
    if (textField == self.paperPopcornCountTextField) {
        self.paperCountLable.text = @"0袋";
        self.paperBoxCountLabel.text = @"0袋";
    }
}


- (void)requestCupImg
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"app_trade_cup" forKey:@"res_name"];
    [parmDict setObject:@"1" forKey:@"num"];
    [parmDict setObject:self.stordID forKey:@"store_id"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/focus/get_foucs_info" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"---success:%@",responseObject);
        NSArray *arr = responseObject[@"response"][@"focus_list"];
        [self.cupDefaultImg sd_setImageWithURL:[NSURL URLWithString:arr[0][@"cover"]] placeholderImage:[UIImage imageNamed:@"beizimoren"]];
        self.tipLabel.text = [NSString stringWithFormat:@"%@", responseObject[@"response"][@"text"]];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error message:%@",responseObject[@"message"]);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}

@end

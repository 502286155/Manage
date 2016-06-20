//
//  ANPurchaseDetailViewController.m
//  baobaotang
//
//  Created by 高赛 on 15/12/7.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANPurchaseDetailViewController.h"
#import "ANSubmitOrderesTableViewCell.h"
#import "ANHttpTool.h"
#import "ANPurchaseDetailModel.h"
#import "ANPurchaseOrderListModel.h"
#import "ANCancelOrderViewController.h"
#import "ANPurchaseOrderCupList.h"

@interface ANPurchaseDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

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
 *  地址Labe
 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
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
 *  撤销订单
 */
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
/**
 *  提示信息
 */
@property (nonatomic, strong) UIAlertView *alertView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/**
 * tableView据下的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bootomConstraint;
/**
 *  tableView与下平齐约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


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
 *  杯桶配送视图
 */
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
@property (weak, nonatomic) IBOutlet UIButton *cupBtn;
@property (weak, nonatomic) IBOutlet UILabel *boxNumLabel;
/**
 *  收货人姓名
 */
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
/**
 *  收款人姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *payName;
/**
 *  收款时间
 */
@property (weak, nonatomic) IBOutlet UILabel *payTime;

/**
 *  付款金额
 */
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;

@property (weak, nonatomic) IBOutlet UITextView *payRemarksTextView;


@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ANPurchaseDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"经销商进货记录详情页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"经销商进货记录详情页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 设置navgation
    [self setNavgation];
    [self requestData];
    [ANNotificationCenter addObserver:self selector:@selector(changeCancle) name:@"cancle" object:nil];
    self.mobileLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    

    self.payName.text = [NSString stringWithFormat:@"%@",self.model.payoff_person];
    self.payTime.text = [NSString stringWithFormat:@"%@",self.model.payoff_time];
    self.payMoneyLabel.text = [NSString stringWithFormat:@"%@",self.model.payoff_money];
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
}
/**
 *  nav左边的点击事件
 */
- (void)navLeftClickedAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ---- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailModel.order_relation_list.count;
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
#pragma mark ---- 底部按钮的点击事件
- (IBAction)clickCancleBtn:(id)sender {
    if ([self.detailModel.progress isEqualToString:@"1"]) {
//        self.alertView = [[UIAlertView alloc] initWithTitle:@"撤销订单" message:@"因误操作或进货需求改变取消本订单" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
//        [self.alertView show];
        ANCancelOrderViewController *cancelOrderVC = [[ANCancelOrderViewController alloc] init];
        cancelOrderVC.storeID = self.store_id;
        cancelOrderVC.order_id = self.order_id;
        [self presentViewController:cancelOrderVC animated:YES completion:nil];
    }else if ([self.detailModel.progress isEqualToString:@"5"]) {
        self.alertView = [[UIAlertView alloc] initWithTitle:@"确认收货" message:@"货物无误并完成订单" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        [self.alertView show];
    }else if ([self.detailModel.progress isEqualToString:@"10"]) {
    }else if ([self.detailModel.progress isEqualToString:@"3"]) {
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self cancleOrSureOrder];
    }
}
- (IBAction)clickCellBtn:(id)sender {

    self.webView = [[UIWebView alloc] init];
    NSString *telStr = [NSString stringWithFormat:@"tel://%@", self.mobileLabel.text];
    NSURL *url = [NSURL URLWithString:telStr] ;
    
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestUrl];
    
}

#pragma mark ---- 网络请求
- (void)requestData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.store_id forKey:@"store_id"];
    [parmDict setObject:self.order_id forKey:@"order_id"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/order/get_order_detail" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [self parseTaskLoadData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
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
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",self.detailModel.price];
    NSArray *integral = [self.detailModel.price componentsSeparatedByString:@"."];
    self.integralLabel.text = [NSString stringWithFormat:@"+%@积分",integral[0]];
    if ([self.detailModel.pay_type isEqualToString:@"1"]) {
        self.payType.text = @"上门收款";
    }else if ([self.detailModel.pay_type isEqualToString:@"5"]) {
        self.payType.text = @"微信支付";
    }else if ([self.detailModel.pay_type isEqualToString:@"10"]) {
        self.payType.text = @"支付宝支付";
    }else if ([self.detailModel.pay_type isEqualToString:@"15"]) {
        self.payType.text = @"银联在线支付";
    }
    self.payType.text = @"向总部转账";
    // 备注
    if ([self.detailModel.note isEqualToString:@""]) {
        self.payRemarksTextView.text = @"暂无备注信息";
    }else {
        self.payRemarksTextView.text = self.detailModel.note;
    }
    self.payRemarksTextView.font = [UIFont systemFontOfSize:14];
    
    if ([self.detailModel.deliver_type isEqualToString:@"1"]) {
        self.deliverTypeLable.text = @"上门送货";
    }
    if ([self.detailModel.progress isEqualToString:@"1"]) {
        [self.cancleBtn setTitle:@"撤销订单" forState:UIControlStateNormal];
        [self.cancleBtn setBackgroundColor:[UIColor colorWithRed:0.6908 green:0.0 blue:0.0142 alpha:1.0]];
    }else if ([self.detailModel.progress isEqualToString:@"5"]) {
        [self.cancleBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if ([self.detailModel.progress isEqualToString:@"10"]) {
        self.bottomView.hidden = YES;
        [self.view removeConstraint:self.bootomConstraint];
        [self.view addConstraint:self.bottomConstraint];
        if ([self.model.express_no isEqualToString:@""]) {
            self.deliverTypeLable.text = @"暂无物流信息";
        }else {
            self.deliverTypeLable.text = [NSString stringWithFormat:@"%@:%@",self.model.express_name, self.model.express_no];
        }
    }else if ([self.detailModel.progress isEqualToString:@"3"]) {
        self.bottomView.hidden = YES;
        [self.view removeConstraint:self.bootomConstraint];
        [self.view addConstraint:self.bottomConstraint];
    }
    self.addressLabel.text = self.detailModel.dealer_address;
    self.nameLabel.text = self.detailModel.receiver;
    self.mobileLabel.text = self.detailModel.mobile;
    
    if ([self.model.express_no isEqualToString:@""]) {
        self.deliverTypeLable.text = @"暂无物流信息";
    }else {
        self.deliverTypeLable.text = [NSString stringWithFormat:@"%@:%@",self.model.express_name, self.model.express_no];
    }
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
        self.cupBtn.hidden = NO;
    }
}
#pragma mark ----确认收货 或 取消订单
// 确认或取消订单
- (void)cancleOrSureOrder
{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];

    [parmDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"agencyStoreId"] forKey:@"store_id"];
    [parmDict setObject:self.order_id forKey:@"order_id"];
    if ([self.detailModel.progress isEqualToString:@"1"]) {
        [parmDict setObject:@"15" forKey:@"progress"];
    }else if ([self.detailModel.progress isEqualToString:@"5"]) {
        [parmDict setObject:@"10" forKey:@"progress"];
    }else if ([self.detailModel.progress isEqualToString:@"10"]) {
        return;
    }
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/order/update_order_progress" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"成功%@",responseObject);
        [self parseData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
    
}
- (void)parseData:(id)data
{
    if ([data[@"message"] isEqualToString:@"success"]) {
        if ([self.detailModel.progress isEqualToString:@"1"]) {
            [ANNotificationCenter postNotificationName:@"cancle" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else if([self.detailModel.progress isEqualToString:@"5"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark ---- 杯桶配送详情
- (IBAction)clickCupBtn:(id)sender {
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

- (IBAction)clickDetailSureBtn:(id)sender {
    self.hiddenView.hidden = YES;
    
}
- (IBAction)clickDetailExitBtn:(id)sender {
    self.hiddenView.hidden = YES;
}

@end

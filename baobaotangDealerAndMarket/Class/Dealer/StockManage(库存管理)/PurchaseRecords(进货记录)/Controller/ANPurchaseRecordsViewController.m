//
//  ANPurchaseRecordsViewController.m
//  baobaotang
//
//  Created by Eric on 15/11/5.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANPurchaseRecordsViewController.h"
#import "ANPurchaseRecordsTableViewCell.h"
#import "ANHttpTool.h"
#import "ANPurchaseRecordsModel.h"
#import "MBProgressHUD.h"
#import "ANPurchaseDetailViewController.h"
#import "ANPurchaseDetailModel.h"
#import "ANPurchaseOrderListModel.h"
#import "ANSubmitPurchasesModel.h"
#import "ANSubmitOrdersViewController.h"
#import "ANCancelOrderViewController.h"
#import "MJRefresh.h"
#import "ANFirstGuideViewController.h"
#import "ANInventoryCheckViewController.h"
#import "ANPayOrderViewController.h"

@interface ANPurchaseRecordsViewController () <UITableViewDelegate, UITableViewDataSource, ANPurchaseRecordsTableViewCellDelegate, UIAlertViewDelegate>
/**
 *  选择器
 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;
/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  全部数据
 */
@property (nonatomic, strong) NSMutableArray *allDataArr;
/**
 *  未到货数组
 */
@property (nonatomic, strong) NSArray *noGoodsDataArr;
/**
 *  已到货数组
 */
@property (nonatomic, strong) NSArray *haveGoodsDataArr;
/**
 *  选择的类型
 */
@property (nonatomic, copy) NSString *selectType;
/**
 *  弹窗视图
 */
@property (nonatomic, strong) UIAlertView *alertView;
/**
 *  订单ID
 */
@property (nonatomic, strong) NSString *order_id;
/**
 *  订单状态  1=>等待配送 5=>配送中 10=>配送完成
 */
@property (nonatomic, strong) NSString *orderType;

@property (nonatomic, strong) ANPurchaseDetailModel *detailModel;
/**
 *  大杯数量
 */
@property (nonatomic, assign) NSInteger bigCup;
/**
 *  中杯数量
 */
@property (nonatomic, assign) NSInteger middleCup;
/**
 *  小杯数量
 */
@property (nonatomic, assign) NSInteger smallCup;
/**
 *  总价格
 */
@property (nonatomic, assign) float totalPrices;
/**
 *  再次进货时提交的数组
 */
@property (nonatomic, strong) NSMutableArray *subArr;
/**
 *  是否取消订单
 */
@property (nonatomic, assign) BOOL isCancleOreder;

@property (nonatomic, assign) BOOL isFirst;
/**
 *  隐藏视图
 */
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
/**
 *  物流公司
 */
@property (weak, nonatomic) IBOutlet UITextField *logisticsName;
/**
 *  物流单号
 */
@property (weak, nonatomic) IBOutlet UITextField *logisticsNum;
/**
 *  物流备注
 */
@property (weak, nonatomic) IBOutlet UITextField *logisticsLabel;
/**
 *  没有信息的视图
 */
@property (weak, nonatomic) IBOutlet UIView *noInfoView;
/**
 *  是否有数据
 */
@property (nonatomic, assign) BOOL isHaveData;
/**
 *  没有信息的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *noInfoImg;

@end

@implementation ANPurchaseRecordsViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isFirst == NO) {
        self.isFirst = YES;
    }else {
        [self requestData];
    }
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [MobClick endLogPageView:@"经销商进货列表页"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"经销商进货列表页"];//("PageOne"为页面名称，可自定义)
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.selectType = @"0";
    [ANNotificationCenter addObserver:self selector:@selector(cancle) name:@"cancle" object:nil];
    // 设置navgation
    [self setNavgation];
    
    [self setTableViewRefresh];
}
/**
 *  设置加载刷新
 */
- (void)setTableViewRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)cancle
{
    self.isCancleOreder = YES;
}
- (void)setNavgation
{
    
    self.navigationItem.title = @"进货记录";
    
    // 中间的标题
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attribute];
    // 左边的按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(navLeftClickedAction:)];
}

- (IBAction)clickSegment:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        ANLog(@"全部");
        self.selectType = @"0";
    }else if (sender.selectedSegmentIndex == 1) {
        ANLog(@"未到货");
        self.selectType = @"1,3,5";
    }else {
        ANLog(@"已到货");
        self.selectType = @"10";
    }
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  nav左边的点击事件
 */
- (void)navLeftClickedAction:(UIButton *)btn
{
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[ANFirstGuideViewController class]]) {
            
            if (self.isPurchesPush == YES) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark ----UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANPurchaseRecordsTableViewCell *cell = [ANPurchaseRecordsTableViewCell purchaseRecordsTableViewCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.allDataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANPurchaseDetailViewController *purchaseDeatailVC = [[ANPurchaseDetailViewController alloc] init];
    ANPurchaseRecordsModel *model = self.allDataArr[indexPath.row];
    purchaseDeatailVC.order_id = model.ID;
    purchaseDeatailVC.store_id = self.store_id;
    purchaseDeatailVC.model = model;
    [self.navigationController pushViewController:purchaseDeatailVC animated:YES];
}

#pragma mark ---- ANPurchaseRecordsTableViewCellDelegate
- (void)purchaseRecordsCell:(ANPurchaseRecordsTableViewCell *)cell clickBtn:(UIButton *)btn orderType:(int)orderType orderID:(NSString *)orderID
{
    self.order_id = orderID;
    //订单的状态   1=>等待配送 5=>配送中 10=>配送完成
    if (orderType == 1) {
        ANCancelOrderViewController *cancelOrderVC = [[ANCancelOrderViewController alloc] init];
        cancelOrderVC.order_id = self.order_id;
        cancelOrderVC.storeID = self.store_id;
        [self presentViewController:cancelOrderVC animated:YES completion:nil];
    }else if (orderType == 5) {
        self.orderType = @"5";
        self.alertView = [[UIAlertView alloc] initWithTitle:@"确认收货并结束订单" message:@"如遇到货物问题、请联系销售助理" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        [self.alertView show];
    }else if (orderType == 10) {
        ANLog(@"按上次进货");
    }
    btn.enabled = YES;
}
- (void)purchaseRecordsCell:(ANPurchaseRecordsTableViewCell *)cell clickLogisticsBtn:(UIButton *)btn withModel:(ANPurchaseRecordsModel *)model
{
#pragma mark 编辑凭证
    if ([model.progress isEqualToString:@"1"]) {
        ANPayOrderViewController *payOrderVC = [[ANPayOrderViewController alloc] init];
        payOrderVC.orderID = model.ID;
        payOrderVC.model = model;
        [self.navigationController pushViewController:payOrderVC animated:YES];
    }else {
#pragma mark 查看物流
        if (![model.express_name isEqualToString:@""]) {
            self.logisticsName.text = [NSString stringWithFormat:@"物流公司:%@",model.express_name];
        }
        if (![model.express_no isEqualToString:@""]) {
            self.logisticsNum.text = [NSString stringWithFormat:@"物流单号:%@",model.express_no];
        }
        if (![model.express_note isEqualToString:@""]) {
            self.logisticsLabel.text = [NSString stringWithFormat:@"备注:%@",model.express_note];
        }
        self.hiddenView.hidden = NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self cancleOrSureOrder];
    }
}
// 确认或取消订单
- (void)cancleOrSureOrder
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
    hud.labelText= netStr
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    });
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.store_id forKey:@"store_id"];
    [parmDict setObject:self.order_id forKey:@"order_id"];
    if ([self.orderType isEqualToString:@"1"]) {
        [parmDict setObject:@"15" forKey:@"progress"];
    }else if ([self.orderType isEqualToString:@"5"]) {
        [parmDict setObject:@"10" forKey:@"progress"];
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
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    if ([data[@"message"] isEqualToString:@"success"]) {
        [self requestData];
        if ([self.orderType isEqualToString:@"1"]) {
            self.isCancleOreder = YES;
        }
    }
}


#pragma mark ----网络请求
- (void)requestData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
    hud.labelText= netStr
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    });
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"0" forKey:@"page_no"];
    [parmDict setObject:self.selectType forKey:@"progress"];
    [parmDict setObject:self.store_id forKey:@"store_id"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/order/get_store_order_list" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseTaskLoadData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
        [self.tableView.mj_header endRefreshing];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)parseTaskLoadData:(id)data
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    NSArray *tempArr = data[@"response"][@"order_list"];
    
    if (tempArr.count == 0 && [self.selectType isEqualToString:@"0"]) {
        self.isHaveData = NO;
    }else if (tempArr.count != 0 && [self.selectType isEqualToString:@"0"]) {
        self.isHaveData = YES;
    }
    if (self.isHaveData) {
        self.noInfoImg.image = [UIImage imageNamed:@"noInfo"];
    }else {
        self.noInfoImg.image = [UIImage imageNamed:@"jilu"];
    }
    
    if (tempArr.count == 0) {
        self.noInfoView.hidden = NO;
    }else {
        self.noInfoView.hidden = YES;
        self.allDataArr = [NSMutableArray array];
        for (NSDictionary *dict in tempArr) {
            [self.allDataArr addObject:[ANPurchaseRecordsModel mj_objectWithKeyValues:dict]];
        }
        [self.tableView reloadData];
    }
    [self.tableView.mj_header endRefreshing];
}
#pragma mark ---- 请求订单信息
- (void)getOrderDetail:(NSString *)orderID
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.store_id forKey:@"store_id"];
    [parmDict setObject:self.order_id forKey:@"order_id"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/order/get_order_detail" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseOrderDtail:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)parseOrderDtail:(id)data
{
    self.detailModel = [ANPurchaseDetailModel mj_objectWithKeyValues:data[@"response"]];
    NSMutableArray *tempArr = [NSMutableArray array];
    self.subArr = [NSMutableArray array];
    for (NSDictionary *dict in self.detailModel.order_relation_list) {
        ANPurchaseOrderListModel *orderModel = [ANPurchaseOrderListModel mj_objectWithKeyValues:dict];
        [tempArr addObject:orderModel];
        self.totalPrices = 0;
        self.bigCup = 0;
        self.middleCup = 0;
        self.smallCup = 0;
        if ([orderModel.goods_info[@"is_sale"] intValue] == 1) {
            self.bigCup += [dict[@"big_cup"] integerValue];
            self.middleCup += [dict[@"middle_cup"] integerValue];
            self.smallCup += [dict[@"small_cup"] integerValue];
            self.totalPrices += [orderModel.goods_num integerValue] * [orderModel.goods_info[@"sku_list"][0][@"price"] floatValue];
        }
        ANSubmitPurchasesModel *subModel = [[ANSubmitPurchasesModel alloc] init];
        subModel.goods_id = orderModel.goods_id;
        subModel.goods_num = [orderModel.goods_num integerValue];
        subModel.sku_id = orderModel.sku_id;
        subModel.category_id = orderModel.goods_info[@"category_id"];
        subModel.cover = orderModel.goods_info[@"cover"];
        subModel.title = orderModel.goods_info[@"title"];
        subModel.intro = orderModel.goods_info[@"intro"];
        subModel.price = orderModel.goods_info[@"sku_list"][0][@"price"];
        [self.subArr addObject:subModel];
    }
    self.detailModel.order_relation_list = tempArr;
    [self pushSubOrder];
}
- (void)pushSubOrder
{
    ANSubmitOrdersViewController *subVC = [[ANSubmitOrdersViewController alloc] init];
    subVC.dataArray = self.subArr;
    subVC.totalPrice = self.totalPrices;
    subVC.bigCup = self.bigCup;
    subVC.middleCup = self.middleCup;
    subVC.smallCup = self.smallCup;
    subVC.isLastOrder = YES;
    [self.navigationController pushViewController:subVC animated:YES];
}


- (IBAction)clickHiddenBtn:(id)sender {
    self.hiddenView.hidden = YES;
}


@end

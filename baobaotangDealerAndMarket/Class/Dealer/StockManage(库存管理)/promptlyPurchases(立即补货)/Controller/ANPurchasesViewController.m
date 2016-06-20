//
//  ANPurchasesViewController.m
//  baobaotang
//
//  Created by Eric on 15/11/3.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANPurchasesViewController.h"
#import "ANPurchasesTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ANHttpTool.h"
#import "ANPurchasesModel.h"
#import "ANSubmitPurchasesModel.h"
#import "ANSubmitOrdersViewController.h"
#import "MBProgressHUD.h"
#import "ANNewSelecteCupViewController.h"
#import "ANPurchaseRecordsViewController.h"
#import "MJRefresh.h"

@interface ANPurchasesViewController ()<UITableViewDelegate, UITableViewDataSource, ANPurchasesTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  总价
 */
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 *  选定的商品
 */
@property (nonatomic, strong) NSArray *submitArray;

/**
 *  错误界面
 */
@property (nonatomic, strong) UIView *errorView;

@property (nonatomic, assign) float totalPrices;
@property (nonatomic, assign) NSInteger totalBoxCount;
/**
 *  隐藏视图
 */
@property (weak, nonatomic) IBOutlet UIView *hiddView;
/**
 *  提示语
 */
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
/**
 *  取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
/**
 *  确认按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/**
 *  立即进货按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *immediatelyBtn;
/**
 *  是否push
 */
@property (nonatomic, assign) BOOL isPush;
/**
 *  杯型
 */
@property (nonatomic, assign) NSInteger cup_type;
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
 *  商品的总箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *boxCountLable;
/**
 *  当前上传的页码
 */
@property (nonatomic, copy) NSString *page_no;
/**
 *  总页数
 */
@property (nonatomic, copy) NSString *pages;
/**
 *  是否需要刷新
 */
@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation ANPurchasesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.immediatelyBtn.enabled = YES;
    // 设置navgation
    [self setNavgation];
    [MobClick beginLogPageView:@"经销商进货页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"经销商进货页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.submitArray = [NSMutableArray array];
    self.boxCountLable.layer.cornerRadius = 10;
    self.page_no = @"1";
    self.isRefresh = YES;
    [self setTableViewRefresh];
    [self setTableViewLoadData];
}

/**
 *  设置navgation
 */
- (void)setNavgation
{
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"我要进货";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
//     设置右边按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 18);
    [button setTitle:@"进货记录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button addTarget:self action:@selector(clickCargoListBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationController.navigationBar addSubview:self.errorView];
}

/**
 *  返回的点击事件
 */
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  点击进货记录按钮
 */
- (void)clickCargoListBtn:(id)sender {
    ANLog(@"进货记录");
    ANPurchaseRecordsViewController *purchaseRecord = [[ANPurchaseRecordsViewController alloc] init];
    purchaseRecord.store_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"agencyStoreId"];
    purchaseRecord.isPurchesPush = YES;
    [self.navigationController pushViewController:purchaseRecord animated:YES];
    
    
}
/**
 *  立即进货事件
 */
- (IBAction)ImmediatelyButtonAction:(id)sender {
    
    ANLog(@"立即进货");
    self.immediatelyBtn.enabled = NO;
    // 散装的箱数
    NSInteger bulkCount = 0;
    
    // 判断 散装两箱起订
    NSMutableArray *array = [NSMutableArray array];
    for (ANPurchasesModel *model in self.dataArray) {
        if (model.puchasesCount != 0) {
            
            ANSubmitPurchasesModel *subMod = [[ANSubmitPurchasesModel alloc] init];
            subMod.goods_id = model.ID;
            subMod.goods_num = model.puchasesCount;
            subMod.sku_id = model.sku_id;
            subMod.category_id = model.category_id;
            subMod.cover = model.cover;
            subMod.title = model.title;
            subMod.intro = model.intro;
            subMod.price = model.price;
            [array addObject:subMod];
        }
    }
    self.submitArray = array;
    
    // 算出散装的箱数
    for (ANSubmitPurchasesModel *submitM in self.submitArray) {
        if ([submitM.category_id integerValue] == 1) {
            bulkCount += submitM.goods_num;
        }
    }
    
    if (bulkCount == 1) {
        // 弹出提示动画
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"散装进货最低2箱起订,谢谢."];
        [self setNavErrorView];
        return;
    }
    
    // 跳转视图
    if (self.submitArray.count == 0) { // 没有选择任何商品
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"请选择商品后再进货,谢谢."];
        [self setNavErrorView];
        return;
    } else if (self.totalBoxCount < 10) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"起订合计不得低于10箱,特殊需求请联系助理."];
        [self setNavErrorView];
        return;
    } else if(self.totalBoxCount > 9999) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"进货量不得超过9999箱,如有特殊需求请联系总部."];
        [self setNavErrorView];
        return;
    } else {
        if (bulkCount != 0) { // 如果有散装商品时
            // 这是新版的选杯
            ANNewSelecteCupViewController *newSelectCup = [[ANNewSelecteCupViewController alloc] init];
            newSelectCup.bulkCount = bulkCount;
            newSelectCup.dataArray = self.submitArray;
            newSelectCup.totalPrice = self.totalPrices;
            newSelectCup.stordID = self.storeID;
            newSelectCup.totalBox = self.totalBoxCount;
            [self.navigationController pushViewController:newSelectCup animated:NO];
        } else { // 全部是零售商品
            ANSubmitOrdersViewController *submitOrder = [[ANSubmitOrdersViewController alloc] init];
            submitOrder.dataArray = self.submitArray;
            submitOrder.totalPrice = self.totalPrices;
            submitOrder.totalBox = self.totalBoxCount;
            [self.navigationController pushViewController:submitOrder animated:YES];
        }
    }
}

- (void)setNavErrorView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.immediatelyBtn.enabled = YES;
    });
    [self.navigationController.navigationBar addSubview:self.errorView];
    [UIView animateWithDuration:0.5 animations:^{
        self.errorView.y = -20;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(removeError) withObject:self.errorView afterDelay:1];
    }];
}
- (void)removeError
{
    [UIView animateWithDuration:0.5 animations:^{
        self.errorView.height = - 64;
    } completion:^(BOOL finished) {
        [self.errorView removeFromSuperview];
    }];
}
#pragma mark -- tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANPurchasesModel *purchasesModel = [[ANPurchasesModel alloc] init];
    purchasesModel = self.dataArray[indexPath.row];
    purchasesModel.indexPath = indexPath;
    
    ANPurchasesTableViewCell *cell = [ANPurchasesTableViewCell purchasesTableView:tableView];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.purchasesModel = purchasesModel;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HIGH * 0.18342;
}

/**
 *  设置刷新
 */
- (void)setTableViewRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [self.tableView.mj_header beginRefreshing];
}
- (void)setTableViewLoadData
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}
- (void)headerRefresh
{
    self.isRefresh = 1;
    self.page_no = @"1";
    self.totalPrices = 0;
    self.totalBoxCount = 0;
    [self requestData];
}
- (void)footerRefresh
{
    self.isRefresh = 0;
    [self requestData];
}


/**
 *  数据请求
 */
- (void)requestData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setValue:self.page_no forKey:@"page_no"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/dealers/get_goods_list" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"--%@", responseObject);
        [self parseTaskLoadData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
        ANLog(@"responseObject:%@",responseObject[@"message"]);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        ANLog(@"error:%@",error);
    }];
}

- (void)parseTaskLoadData:(id)data
{
    NSMutableArray *array = [ANPurchasesModel mj_objectArrayWithKeyValuesArray:data[@"response"][@"data_list"]];
    if (self.isRefresh) {
        self.dataArray = array;
    }else {
        [self.dataArray addObjectsFromArray:array];
    }
    [self judgePages:data[@"response"][@"pages"]];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}
/**
 *  判断页码
 */
- (void)judgePages:(NSDictionary *)dict
{
    self.page_no = dict[@"page_no"];
    self.pages = dict[@"pages"];
    if ([self.page_no intValue] < [self.pages intValue]) {
        self.page_no = [NSString stringWithFormat:@"%d",[self.page_no intValue] + 1];
        [self.tableView.mj_footer endRefreshing];
    }else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - cell 的代理方法
- (void)purchasesTableViewCell:(UIView *)view button:(UIButton *)button indexPath:(NSIndexPath *)indexPath
{
    ANPurchasesModel *model = self.dataArray[indexPath.row];
    
    if (button.tag == ButtonTypeAdd) {
        model.puchasesCount = model.puchasesCount + 10;
        self.totalBoxCount = self.totalBoxCount + 10;
        self.totalPrices += [model.price floatValue] * 10;
    }
    if (button.tag == ButtonTypeSubtract && model.puchasesCount > 0) {
        if (model.puchasesCount < 10) {
            self.totalBoxCount = self.totalBoxCount - model.puchasesCount;
            self.totalPrices -= [model.price floatValue] * model.puchasesCount;
            model.puchasesCount = model.puchasesCount - model.puchasesCount;
        } else {
            model.puchasesCount = model.puchasesCount - 10;
            self.totalBoxCount = self.totalBoxCount - 10;
            self.totalPrices -= [model.price floatValue] * 10;
        }
    }
    [self.tableView reloadData];
}
//编辑完成
- (void)purchasesEditFinshedTextField:(UITextField *)textField indexPath:(NSIndexPath *)indexPath
{
    [self resignFirstResponder];
    
    ANPurchasesModel *model = self.dataArray[indexPath.row];
    model.puchasesCount = [textField.text integerValue];
    
    self.totalPrices = 0;
    self.totalBoxCount = 0;
    for (model in self.dataArray) {
        self.totalPrices += [model.price floatValue] * model.puchasesCount;
        self.totalBoxCount += model.puchasesCount;
    }
    NSArray *indexArr = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationNone];
}

/**
 *  总价格赋值
 */
- (void)setTotalPrices:(float)totalPrices
{
    if (_totalPrices != totalPrices) {
        _totalPrices = totalPrices;
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.1f", _totalPrices];
}
- (void)setTotalBoxCount:(NSInteger)totalBoxCount
{
    if (_totalBoxCount != totalBoxCount) {
        _totalBoxCount = totalBoxCount;
    }
    
    self.boxCountLable.text = [NSString stringWithFormat:@"共%ld箱", _totalBoxCount];

}

@end

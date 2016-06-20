//
//  ANPurchasesViewController.m
//  baobaotang
//
//  Created by Eric on 15/11/3.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANSubPriceAdjustmentViewController.h"
#import "ANSubPriceAdjustmentCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ANHttpTool.h"
#import "ANPurchasesModel.h"
#import "ANPriceAdjustmentViewController.h"
#import "ANNewPurchasesModel.h"
#import "ANSkuList.h"
#import "MJRefresh.h"

@interface ANSubPriceAdjustmentViewController ()<UITableViewDelegate, UITableViewDataSource, ANSubPriceAdjustmentCellDelegate, UIAlertViewDelegate, ANPriceAdjustmentViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


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
 *  修改后的价格
 */
@property (nonatomic, copy) NSString *changedPrice;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *sku_id;
/**
 *  底部视图
 */
@property (weak, nonatomic) IBOutlet UIView *selectBottomView;
@property (weak, nonatomic) IBOutlet UIButton *changePriceBtn;

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;
@property (weak, nonatomic) IBOutlet UIView *changeBottomView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, assign) BOOL isAllSelect;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) ANPriceAdjustmentViewController *priceAdjustmentView;

/**
 *  是否第一次进入
 */
@property (nonatomic, assign) BOOL isFrist;
/**
 *  要请求的页码
 */
@property (nonatomic, copy) NSString *page_no;
/**
 *  总页数
 */
@property (nonatomic, copy) NSString *pages;
/**
 *  刷新状态
 */
@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation ANSubPriceAdjustmentViewController

- (ANPriceAdjustmentViewController *)priceAdjustmentView
{
    if (_priceAdjustmentView == nil) {
        _priceAdjustmentView = [[ANPriceAdjustmentViewController alloc] init];
        _priceAdjustmentView.view.frame = CGRectMake(0, -64, WIDTH, HIGH);
        _priceAdjustmentView.view.hidden = YES;
        _priceAdjustmentView.delegate = self;
        [self.view addSubview:_priceAdjustmentView.view];
    }
    return _priceAdjustmentView;
}

- (NSMutableArray *)selectArr
{
    if (_selectArr == nil) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"单独改价页"];//("PageOne"为页面名称，可自定义)
    
    if (self.isFrist) {
        self.page_no = @"1";
        [self requestData];
    }else {
        self.isFrist = YES;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"单独改价页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.submitArray = [NSMutableArray array];
    
    self.navigationController.navigationBarHidden = NO;
    // 设置navgation
    [self setNavgation];
    [self setTableViewRefresh];
}
/**
 *  设置加载刷新
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
    [self requestData];
}
- (void)footerRefresh
{
    self.isRefresh = 0;
    [self requestData];
}
/**
 *  设置navgation
 */
- (void)setNavgation
{
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"单独改价";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    // 设置右边按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 105, 18);
    [button setTitle:@"批量改价" forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button addTarget:self action:@selector(chargeRecordClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.rightBtn = button;
    
    [self.navigationController.navigationBar addSubview:self.errorView];
}

/**
 *  返回的点击事件
 */
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setNavErrorView
{
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
#pragma mark -- 批量改价
/**
 *  右上角点击事件
 */
- (void)chargeRecordClick:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"批量改价"]) {
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [self.tableView setEditing:YES animated:YES];
        self.changeBottomView.hidden = YES;
    }else {
        self.priceAdjustmentView.view.hidden = YES;
        [btn setTitle:@"批量改价" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
        self.changeBottomView.hidden = NO;
        self.navigationItem.title = @"单独改价";
        self.selectImageView.image = [UIImage imageNamed:@"unSelect"];
        [self.selectArr removeAllObjects];
    }
    ANLog(@"统一调价");
}
/**
 *  选中批量改价后底部按钮的点击事件
 */
- (IBAction)clickChangePriceBtn:(id)sender
{
    if (self.isAllSelect) {
        
    }else {
        if (self.selectArr.count == 0) {
            [ANCommon setAlertViewWithMessage:@"请先选择要改价的商品"];
            return;
        }
    }
    self.priceAdjustmentView.store_id = self.store_id;
    self.priceAdjustmentView.storeName = self.storeName;
    if (self.isAllSelect) {
        self.priceAdjustmentView.dataArray = self.dataArray;
        self.priceAdjustmentView.storeCount = self.storeCount;
        self.priceAdjustmentView.goodsCount = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count];
    }else {
        self.priceAdjustmentView.dataArray = self.selectArr;
        self.priceAdjustmentView.storeCount = self.storeCount;
        self.priceAdjustmentView.goodsCount = [NSString stringWithFormat:@"%lu",(unsigned long)self.selectArr.count];
    }
    [self.priceAdjustmentView setValue];
    self.priceAdjustmentView.view.hidden = NO;
    self.navigationItem.title = @"批量改价";
}
/**
 *  底部批量改价点击事件
 */
- (IBAction)clickStartChangePriceBtn:(id)sender {
    [self.tableView setEditing:YES animated:YES];
    [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.changeBottomView.hidden = YES;
}
/**
 *  全选按钮的点击事件
 */
- (IBAction)clickAllSelectBtn:(id)sender {
    self.isAllSelect = !self.isAllSelect;
    for (int i = 0 ; i < self.dataArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        if (self.isAllSelect) {
            [self.selectArr removeAllObjects];
            self.selectImageView.image = [UIImage imageNamed:@"select"];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }else {
            [self.selectArr removeAllObjects];
            self.selectImageView.image = [UIImage imageNamed:@"unSelect"];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
}
/**
 *  批量改价点击空白处的点击事件（通过代理执行）
 *  如果str为1，是点击了底部完成按钮的点击事件，要重新请求接口
 */
- (void)refreshData:(NSString *)str
{
    self.selectImageView.image = [UIImage imageNamed:@"unSelect"];
    self.priceAdjustmentView.view.hidden = YES;
    [self.tableView setEditing:NO animated:YES];
    self.isAllSelect = NO;
    [self.selectArr removeAllObjects];
    self.changeBottomView.hidden = NO;
    [self.rightBtn setTitle:@"批量改价" forState:UIControlStateNormal];
    if ([str isEqualToString:@"1"]) {
        self.isRefresh = YES;
        self.page_no = @"1";
        [self requestData];
    }
}

#pragma mark -- tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANNewPurchasesModel *purchasesModel = [[ANNewPurchasesModel alloc] init];
    purchasesModel = self.dataArray[indexPath.row];
    purchasesModel.indexPath = indexPath;
    
    ANSubPriceAdjustmentCell *cell = [ANSubPriceAdjustmentCell subPriceAdjustmentCellTableView:tableView];
    cell.delegate = self;
    cell.purchasesNewModel = purchasesModel;
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
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        [self.selectArr addObject:self.dataArray[indexPath.row]];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        [self.selectArr removeObject:self.dataArray[indexPath.row]];
    }
}

/**
 *  数据请求
 */
- (void)requestData
{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.store_id forKey:@"store_id"];
    [parmDict setObject:self.page_no forKey:@"page_no"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    ANLog(@"asdf : %@", parmDict);
    [ANHttpTool postWithUrl:@"/api/1/goods/get_store_goods_list" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"--%@", responseObject);
        [self parseTaskLoadData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        
        ANLog(@"responseObject:%@",responseObject[@"message"]);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        
        ANLog(@"error:%@",error);
    }];
}

- (void)parseTaskLoadData:(id)data
{
    NSArray *array = [ANPurchasesModel mj_objectArrayWithKeyValuesArray:data[@"response"][@"data_list"]];
    NSMutableArray *tempArray = [NSMutableArray array];
    if (array.count == 0) {
        [[ANCommon alloc] setAlertView:@"您还未向总部进货,请先进货"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }else {
        for (NSDictionary *dict in data[@"response"][@"data_list"]) {
            NSArray *arr = dict[@"sku_list"];
            for (NSDictionary *dic in arr) {
                ANNewPurchasesModel *newPurchasesModel = [ANNewPurchasesModel mj_objectWithKeyValues:dict];
                ANSkuList *skuList = [ANSkuList mj_objectWithKeyValues:dic];
                newPurchasesModel.skuList = skuList;
                if ([newPurchasesModel.is_sale integerValue] == 1) {
                    [tempArray addObject:newPurchasesModel];
                }
            }
        }
        [self.tableView.mj_header endRefreshing];
        
        if (self.isRefresh) {
            self.dataArray = tempArray;
            [self setTableViewLoadData];
        }else {
            [self.dataArray addObjectsFromArray:tempArray];
        }
        [self.tableView reloadData];
        [self judgePages:data[@"response"][@"pages"]];
    }
}
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
- (void)subPriceAdjustmentTableViewCell:(UIView *)view button:(UIButton *)button priceText:(NSString *)priceText indexPath:(NSIndexPath *)indexPath
{
    [self resignFirstResponder];
    if (priceText.length != 0) {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:@"确认改价并立即显示在掌柜端" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterView show];
        self.changedPrice = priceText;
        self.indexPath = indexPath;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        ANNewPurchasesModel *model = self.dataArray[self.indexPath.row];
        model.skuList.price = [NSString stringWithFormat:@"%.2f", [self.changedPrice floatValue]];
        
        self.goods_id = model.skuList.goods_id;
        self.sku_id = model.skuList.sku_id;
    
        [self changeSubGoodsPriceRequest];
    }
}
- (void)changeSubGoodsPriceRequest
{
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
    [jsonDic setObject:self.changedPrice forKey:@"edit_price"];
    [jsonDic setObject:self.goods_id forKey:@"goods_id"];
    [jsonDic setObject:self.sku_id forKey:@"sku_id"];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:jsonDic];
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.store_id forKey:@"store_id"];
    [parmDict setObject:[array mj_JSONString] forKey:@"goods_list"];

    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/dealers/edit_goods_price" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        
        [self.tableView reloadData];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"responseObject:%@",responseObject[@"message"]);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        
        ANLog(@"error:%@",error);
    }];
}


@end

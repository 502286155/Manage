//
//  ANPurchasesViewController.m
//  baobaotang
//
//  Created by Eric on 15/11/3.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANInventoryCheckViewController.h"
#import "ANInventoryCheckCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ANHttpTool.h"
#import "ANPurchasesModel.h"
#import "ANPriceAdjustmentViewController.h"
#import "ANCupCheckViewController.h"
#import "MJRefresh.h"

@interface ANInventoryCheckViewController ()<UITableViewDelegate, UITableViewDataSource, ANInventoryCheckCellDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  总箱数
 */
@property (weak, nonatomic) IBOutlet UILabel *totalBoxCountLabel;

/**
 *  总价
 */
@property (weak, nonatomic) IBOutlet UILabel *totalStyleLabel;

/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 *  选定的商品
 */
@property (nonatomic, strong) NSMutableArray *submitArray;

/**
 *  错误界面
 */
@property (nonatomic, strong) UIView *errorView;

/**
 *  总的箱数
 */
@property (nonatomic, assign) NSInteger totalStork;
/**
 *  总的款式
 */
@property (nonatomic, assign) NSInteger totalStyle;

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
 *  修改后的库存
 */
@property (nonatomic, copy) NSString *changedStock;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *sku_id;

/**
 *  修改价格的提示框
 */
@property (nonatomic, weak) UIAlertView *changePriceAlertView;
/**
 *  提交库存的
 */
@property (nonatomic, weak) UIAlertView *submitStorkAlertView;
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

@implementation ANInventoryCheckViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.immediatelyBtn.enabled = YES;
    [MobClick beginLogPageView:@"盘点库存商品页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"盘点库存商品页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.submitArray = [NSMutableArray array];
    
    // 设置navgation
    [self setNavgation];
    
    [self setTableViewRefresh];
    [self setTableViewLoadData];
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
    self.navigationItem.title = @"盘点商品";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
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
 *  提交库存
 */
- (IBAction)ImmediatelyButtonAction:(id)sender {
    
    UIAlertView *subAlter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认盘点商品库存无误并进行下一步" delegate:self cancelButtonTitle:@"继续盘点" otherButtonTitles:@"确认无误", nil];
    self.submitStorkAlertView = subAlter;
    [subAlter show];
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
#pragma mark -- 统一调价
/**
 *  统一调价
 */
- (void)dismissNav
{
    ANLog(@"消失");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
// 取消按钮
- (IBAction)clickCancelBtn:(id)sender {
    ANLog(@"取消");
    self.hiddView.hidden = YES;
}

#pragma mark -- tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANPurchasesModel *purchasesModel = [[ANPurchasesModel alloc] init];
    purchasesModel = self.dataArray[indexPath.row];
    purchasesModel.indexPath = indexPath;
    
    ANInventoryCheckCell *cell = [ANInventoryCheckCell inventoryCheckCellTableView:tableView];
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
 *  数据请求
 */
- (void)requestData
{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.page_no forKey:@"page_no"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [parmDict setObject:@"init_stock" forKey:@"type"];
    ANLog(@"asdf : %@", parmDict);
    [ANHttpTool postWithUrl:@"/api/1/dealers/get_goods_list" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"--%@", responseObject);
        [self parseTaskLoadData:responseObject[@"response"]];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        
        ANLog(@"responseObject:%@",responseObject[@"message"]);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        
        ANLog(@"error:%@",error);
    }];
}

- (void)parseTaskLoadData:(id)data
{
    NSMutableArray *array = [ANPurchasesModel mj_objectArrayWithKeyValuesArray:data[@"data_list"]];
    
    if (self.isRefresh) {
        self.dataArray = array;
    }else {
        [self.dataArray addObjectsFromArray:array];
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
    [self judgePages:data[@"pages"]];
    
   [self setStorkData];
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
- (void)inventoryCheckTableViewCell:(UIView *)view button:(UIButton *)button priceText:(UITextField *)priceText indexPath:(NSIndexPath *)indexPath
{
    [priceText resignFirstResponder];
    if (priceText.text.length != 0) {
//        1564601000
        self.changedStock = priceText.text;
        self.indexPath = indexPath;
    }
}
- (void)inventoryCheckTableviewcell:(UIView *)view textField:(UITextField *)textField indexPath:(NSIndexPath *)indexPath
{
    if (textField.text.length != 0) {
        self.changedStock = textField.text;
        self.indexPath = indexPath;
        [self setSurplusStock:indexPath];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.submitStorkAlertView) {
        if (buttonIndex == 1) {
            for (ANPurchasesModel *model in self.dataArray) {
                if (model.stock != 0) {
                    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
                    [jsonDic setObject:model.goods_id forKey:@"goods_id"];
                    [jsonDic setObject:[NSString stringWithFormat:@"%ld", [model.stock integerValue]] forKey:@"goods_num"];
                    [jsonDic setObject:model.sku_id forKey:@"sku_id"];
                    [self.submitArray addObject:jsonDic];
                }
            }
            NSString *jsonString = [self.submitArray mj_JSONString];
            
            ANCupCheckViewController *cupCheck = [[ANCupCheckViewController alloc] init];
            cupCheck.store_id = self.store_id;
            cupCheck.goodsJsonString = jsonString;
            [self.navigationController pushViewController:cupCheck animated:YES];
        }
    }
    
}

- (void)setSurplusStock:(NSIndexPath *)indexPath
{
    ANPurchasesModel *model = self.dataArray[indexPath.row];
    model.stock = self.changedStock;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self setStorkData];
    
}

- (void)setStorkData
{
    NSInteger totalStork = 0; // 总箱数
    NSInteger totalStyle = 0; // 总款式
    for (ANPurchasesModel *model in self.dataArray) {
        
        totalStork += [model.stock integerValue];
        if (![model.stock isEqualToString:@"0"]) {
            totalStyle++;
        }
    }
    self.totalStork = totalStork;
    self.totalStyle = totalStyle;
}

- (void)setTotalStork:(NSInteger)totalStork
{
    if (_totalStork != totalStork) {
        _totalStork = totalStork;
    }
    self.totalBoxCountLabel.text = [NSString stringWithFormat:@"%ld箱", _totalStork];
}
- (void)setTotalStyle:(NSInteger)totalStyle
{
    if (_totalStyle != totalStyle) {
        _totalStyle = totalStyle;
    }
    self.totalStyleLabel.text = [NSString stringWithFormat:@"共%ld款", _totalStyle];
}

@end

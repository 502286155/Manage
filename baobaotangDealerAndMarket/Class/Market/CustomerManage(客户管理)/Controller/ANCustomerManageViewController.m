//
//  ANCustomerManageViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/24.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANCustomerManageViewController.h"
#import "ANCustomerManageCell.h"
#import "ANSignedViewController.h"
#import <CoreData/CoreData.h>
#import "ANHttpTool.h"
#import "ANSubPriceAdjustmentViewController.h"
#import "ANCustomerModel.h"     //总店model
#import "ANSubStoreModel.h"     //分店model
#import "ANAreaDetailViewController.h"
#import "MJRefresh.h"
#import "ANHelpHFiveViewController.h"
#import "ANNewCheckInViewController.h"
#import "ANSelectDeviceViewController.h"
#import "ANCheckInModel.h"
#import "sys/utsname.h"
#import "ANSearchStoreVC.h"

@interface ANCustomerManageViewController ()<UITableViewDataSource, UITableViewDelegate, ANCustomerManageCell, UIViewControllerPreviewingDelegate, ANAreaDetailViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *status;

/**
 *  没有信息视图
 */
@property (weak, nonatomic) IBOutlet UIView *noInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *noInfoImg;
/**
 *  是否是第一次进入
 */
@property (nonatomic, assign) BOOL isFirst;
/**
 *  是否有数据
 */
@property (nonatomic, assign) BOOL isHaveData;

@property (nonatomic, assign) BOOL isRefresh;

@property (nonatomic, copy) NSString *page_no;

@property (nonatomic, copy) NSString *pages;

@property (nonatomic, assign) BOOL is3DTouch;

@property (weak, nonatomic) IBOutlet UIView *topPromptView;
@property (weak, nonatomic) IBOutlet UIButton *topPromptBtn;
@property (weak, nonatomic) IBOutlet UILabel *topPromptLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;
/**
 *  未绑定设备的门店数量
 */
@property (nonatomic, copy) NSString *unset_device_store_num;
/**
 *  未调整价格的门店数量
 */
@property (nonatomic, copy) NSString *unset_price_store_num;


@end

@implementation ANCustomerManageViewController

#pragma mark ---- 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    if (self.isFirst == NO) {
//        self.isFirst = YES;
//    }else {
//        [self.tableView.mj_header beginRefreshing];
//    }
    [MobClick beginLogPageView:@"市场人员门店列表页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"市场人员门店列表页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.status = @"-1";
    self.page_no = @"1";
    self.isRefresh = 1;
    [self setNavgation];
    [self setTableViewRefresh];
    // 刷新数据的通知
    [ANNotificationCenter addObserver:self selector:@selector(requestData) name:@"requestData" object:nil];
}
- (void)notificationRequest
{
    self.page_no = @"1";
    [self requestData];
}
/**
 *  设置加载刷新
 */
- (void)setTableViewRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
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
- (void)dealloc
{
    [ANNotificationCenter removeObserver:self];
}

#pragma mark ---- 自定义方法
// 设置nav
- (void)setNavgation
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    if ([self.unset isEqualToString:@"1"]) {
        self.title = @"筛选结果";
    }else {
        self.title = @"我的客户";
    }
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(clickRightBtn)];
}
- (void)clickRightBtn
{
    ANLog(@"地点");
    ANSearchStoreVC *searchStoreVC = [[ANSearchStoreVC alloc] init];
    searchStoreVC.isMarking = YES;
    [self.navigationController pushViewController:searchStoreVC animated:YES];
}
// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickSignedBtn:(id)sender {
    ANLog(@"立即签约");
    ANSignedViewController *signedVC = [[ANSignedViewController alloc] initWithNibName:@"ANSignedViewController" bundle:nil];
    [self.navigationController pushViewController:signedVC animated:YES];
}

#pragma mark ---- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANCustomerManageCell *cell = [ANCustomerManageCell customermanageTabelView:tableView];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.modelDic = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    ANLog(@"%@",deviceString);
    if ([deviceString containsString:@"iPhone8"]) {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            //        NSLog(@"3D Touch  可用!");
            //给cell注册3DTouch的peek（预览）和pop功能
            [self registerForPreviewingWithDelegate:self sourceView:cell];
        } else {
            //        NSLog(@"3D Touch 无效");
        }
    }
    
    return cell;
}
#pragma mark UIViewControllerPreviewingDelegate
//peek(预览)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    
    //设定预览的界面
    ANAreaDetailViewController *areaDetailVC = [[ANAreaDetailViewController alloc] init];
    ANCustomerModel *model = self.dataArr[indexPath.row][@"user_store"];
    ANSubStoreModel *subStoreModel = self.dataArr[indexPath.row][@"store"];
    areaDetailVC.subStoreID = subStoreModel.store_id;
    areaDetailVC.owner_id = model.owner_id;
    areaDetailVC.status = self.status;
    areaDetailVC.delegate = self;
    //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    CGRect rect = CGRectMake(0, 0, WIDTH, HIGH * 82 / 736);
    previewingContext.sourceRect = rect;
    //返回预览界面
    return areaDetailVC;
}

//pop（按用点力进入）
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}
- (void)pushViewController:(UIViewController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 189;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANAreaDetailViewController *areaListVC = [[ANAreaDetailViewController alloc] init];
    ANCustomerModel *model = [[ANCustomerModel alloc] init];
    ANSubStoreModel *subStoreModel = self.dataArr[indexPath.row][@"store"];
    model = self.dataArr[indexPath.row][@"user_store"];
    areaListVC.status = self.status;
    areaListVC.owner_id = model.owner_id;
    areaListVC.subStoreID = subStoreModel.store_id;
    
    [self.navigationController pushViewController:areaListVC animated:YES];
}
- (IBAction)clickSegmented:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.status = @"-1";
    }else if (sender.selectedSegmentIndex == 1) {
        self.status = @"2";
    }else if (sender.selectedSegmentIndex == 2) {
        self.status = @"1";
    }else if (sender.selectedSegmentIndex == 3) {
        self.status = @"3";
    }
    self.page_no = @"1";
    self.isRefresh = 1;
    [self requestData];
}

#pragma mark ----ANCustomerManageCellDelegate
- (void)customerManageCell:(ANCustomerManageCell *)cell clickCheckInBtn:(UIButton *)btn
{
    if ([self.status isEqualToString:@"3"]) {
        [ANCommon setAlertViewWithMessage:@"撤店状态下无法操作。"];
        return;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = self.dataArr[indexPath.row];
    ANCustomerModel *model = dict[@"user_store"];
    ANSubStoreModel *subStoreModel = dict[@"store"];
    int storeNum = [model.store_num intValue];
    int stopNum = [model.stop_store_num intValue];
    if ((storeNum == 1) || ((storeNum - stopNum) == 1)) {
        [self getCheckModelWith:subStoreModel.store_id];
        return;
    }else if (storeNum == stopNum) {
        [ANCommon setAlertViewWithMessage:@"已撤店的门店无法绑定设备"];
        return;
    }
    ANLog(@"设备登记");
    ANNewCheckInViewController *newCheckInVC = [[ANNewCheckInViewController alloc] init];
    newCheckInVC.storeID = subStoreModel.store_id;
    [self.navigationController pushViewController:newCheckInVC animated:YES];
}
- (void)getCheckModelWith:(NSString *)storeID
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:storeID forKey:@"store_id"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    
    [ANHttpTool postWithUrl:@"/api/1/store/get_store_device_num_list" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"success:%@",responseObject);
        [self parseCheckModel:responseObject withStoreID:storeID];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)parseCheckModel:(id)data withStoreID:(NSString *)storeID
{
    NSArray *tempArr = data[@"response"];
    ANCheckInModel *model = [ANCheckInModel mj_objectWithKeyValues:tempArr[0]];
    ANSelectDeviceViewController *selectDeviceVC = [[ANSelectDeviceViewController alloc] init];
    selectDeviceVC.storeName = model.store_title;
    selectDeviceVC.storeID = storeID;
    [self.navigationController pushViewController:selectDeviceVC animated:YES];
}

- (void)customerManageCell:(ANCustomerManageCell *)cell clickPhoneBtn:(UIButton *)btn withPhone:(NSString *)phone indexPath:(NSIndexPath *)indexPath
{
    
    if ([self.status isEqualToString:@"3"]) {
        [ANCommon setAlertViewWithMessage:@"撤店状态下无法操作。"];
        return;
    }
    ANLog(@"价格调整");
    ANSubPriceAdjustmentViewController *priceAdjustment = [[ANSubPriceAdjustmentViewController alloc] init];

    NSDictionary *dic = self.dataArr[indexPath.row];
    ANSubStoreModel *model = dic[@"store"];
    ANCustomerModel *custModel = dic[@"user_store"];
    priceAdjustment.store_id = model.store_id;
    priceAdjustment.storeCount = custModel.store_num;
    priceAdjustment.storeName = model.title;
    [self.navigationController pushViewController:priceAdjustment animated:YES];
}


- (IBAction)clickHFiveBtn:(id)sender {
    if (self.noInfoImg.image == [UIImage imageNamed:@"noInfo"]) {
        ANLog(@"不跳转");
    }else {
        ANLog(@"跳转");
        ANHelpHFiveViewController *helpVC = [[ANHelpHFiveViewController alloc] init];
        [self.navigationController pushViewController:helpVC animated:YES];
    }
}
#pragma mark ---- 网络请求
- (void)requestData
{
//    self.noInfoView.hidden = NO;
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:@"0" forKey:@"only_chain_shop"];
    [parmDic setObject:self.page_no forKey:@"page_no"];
    [parmDic setObject:@"0" forKey:@"page_size"];
    [parmDic setObject:self.status forKey:@"status"];
    [parmDic setObject:@"0" forKey:@"type"];
    parmDic = (NSMutableDictionary *)[ANCommon dicToSign:parmDic];
    
    [ANHttpTool postWithUrl:@"/api/1/store/list_agency_user_stores" params:parmDic successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self parseOrderDtail:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
        if (self.isRefresh) {
            self.noInfoView.hidden = NO;
            if (self.isHaveData == YES) {
                self.noInfoImg.image = [UIImage imageNamed:@"noInfo"];
            }else {
                self.noInfoImg.image = [UIImage imageNamed:@"mendian"];
            }
        }else{
            
        }
        [self.tableView.mj_header endRefreshing];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)parseOrderDtail:(id)data
{
    NSArray *tempArr = data[@"response"][@"data_list"];
    
    if ([self.status isEqualToString:@"-1"] && tempArr.count == 0) {
        self.isHaveData = NO;
    }else if ([self.status isEqualToString:@"-1"] && tempArr.count != 0){
        self.isHaveData = YES;
    }
    if (tempArr.count == 0) {
        if (self.isHaveData == YES) {
            self.noInfoImg.image = [UIImage imageNamed:@"noInfo"];
        }else {
            self.noInfoImg.image = [UIImage imageNamed:@"mendian"];
        }
    }
    
    
//    if ([self.status integerValue] == -1 && tempArr.count == 0) {
//        self.noInfoImg.image = [UIImage imageNamed:@"mendian"];
//    } else {
//        self.noInfoImg.image = [UIImage imageNamed:@"noInfo"];
//    }
        ANLog(@"我的客户 : %@", data);
    if (tempArr) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in tempArr) {
            ANCustomerModel *model = [ANCustomerModel mj_objectWithKeyValues:dic[@"user_store"]];
            model.storeStateType = self.status;
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
            ANSubStoreModel *subModel = [ANSubStoreModel mj_objectWithKeyValues:dic[@"store"]];
            [tempDic setObject:model forKey:@"user_store"];
            [tempDic setObject:subModel forKey:@"store"];
            [array addObject:tempDic];
        }
        
        if (self.isRefresh) {
            self.dataArr = array;
            [self setTableViewLoadData];
        }else {
            [self.dataArr addObjectsFromArray:array];
        }
        // 判断页码
        [self judgePages:data[@"response"][@"pages"]];
        
        // 判断未绑定设备与未调整价格的门店数量
        self.unset_device_store_num = data[@"response"][@"unset_device_store_num"];
        self.unset_price_store_num = data[@"response"][@"unset_price_store_num"];
        if ([self.unset isEqualToString:@"1"]) {
            
        }else {
            if ([self.unset_device_store_num isEqualToString:@"0"]) {
                // 未绑定设备门店数量为0
                if ([self.unset_price_store_num isEqualToString:@"0"]) {
                    // 未调整价格门店数量为0
                    self.unset = @"0";
                }else {
                    self.topPromptLabel.text = [NSString stringWithFormat:@"您目前有%@家门店未调整价格.>>",self.unset_price_store_num];
                    [self.view removeConstraint:self.topConstraint];
                    [self.view addConstraint:self.topViewConstraint];
                }
            }else {
                // 未绑定设备门店数量不为0
                if ([self.unset_price_store_num isEqualToString:@"0"]) {
                    // 未调整价格门店数量为0
                    self.topPromptLabel.text = [NSString stringWithFormat:@"您目前有%@家门店未绑定设备.>>",self.unset_device_store_num];
                    [self.view removeConstraint:self.topConstraint];
                    [self.view addConstraint:self.topViewConstraint];
                }else {
                    // 未调整价格门店数量不为0
                    self.topPromptLabel.text = [NSString stringWithFormat:@"您目前有%@家门店未绑定设备,%@家门店未调整价格.>>",self.unset_device_store_num,self.unset_price_store_num];
                    [self.view removeConstraint:self.topConstraint];
                    [self.view addConstraint:self.topViewConstraint];
                }
            }
        }
        
        self.noInfoView.hidden = YES;
        [self.tableView reloadData];
    }else {
        self.noInfoView.hidden = NO;
    }
}
- (void)judgePages:(NSDictionary *)dict
{
    NSNumber *page_no = dict[@"page_no"];
    NSNumber *pages = dict[@"pages"];
    self.page_no = [page_no stringValue];
    self.pages = [pages stringValue];
    if ([self.page_no intValue] < [self.pages intValue]) {
        self.page_no = [NSString stringWithFormat:@"%d",[self.page_no intValue] + 1];
        [self.tableView.mj_footer endRefreshing];
    }else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}
- (IBAction)clickTopBtn:(id)sender {
    if ([self.unset isEqualToString:@"1"]) {
        
    }else {
        ANCustomerManageViewController *areaListVC = [[ANCustomerManageViewController alloc] init];
        areaListVC.unset = @"1";
        [self.navigationController pushViewController:areaListVC animated:YES];
    }
}


@end

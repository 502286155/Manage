//
//  ANAreaListViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/19.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANAreaListViewController.h"
#import "ANAreaListTableViewCell.h"
#import "ANAreaDetailViewController.h"
#import "ANHttpTool.h"
#import "ANCustomerModel.h"
#import "ANSubStoreModel.h"
#import "ANSignedViewController.h"
#import "MJRefresh.h"
#import "ANHelpHFiveViewController.h"
#import "sys/utsname.h"
#import "ANSearchStoreVC.h"

typedef void (^JumpBlock)(ANAreaListViewController *);

@interface ANAreaListViewController ()<UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate, ANAreaDetailViewControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *status;
@property (weak, nonatomic) IBOutlet UIView *noInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *noInfoImg;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isHaveData;
/**
 *  顶部提示视图
 */
@property (weak, nonatomic) IBOutlet UIView *topPromptView;
/**
 *  顶部提示Label
 */
@property (weak, nonatomic) IBOutlet UILabel *topPromptLabel;
/**
 *  顶部提示按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *topPromptBtn;
/**
 *  顶部选择视图
 */
@property (weak, nonatomic) IBOutlet UIView *topSelectView;
/**
 *  距离顶部约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
/**
 *  距离view约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;
/**
 *  未绑定设备的门店数量
 */
@property (nonatomic, copy) NSString *unset_device_store_num;
/**
 *  未调整价格的门店数量
 */
@property (nonatomic, copy) NSString *unset_price_store_num;
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
/**
 *  是否支持3DTouch
 */
@property (nonatomic, assign) BOOL is3DTouch;
/**
 *  要删除的门店ID
 */
@property (nonatomic, copy) NSString *ownerID;
/**
 *  选择的要删除的门店的indexPath
 */
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@end

@implementation ANAreaListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"区域列表页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"区域列表页"];
}

#pragma mark --- 生命周期
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (self.isFirst == NO) {
        self.isFirst = YES;
    }else {
//        [self.tableView reloadData];
//        self.isRefresh = 1;
//        self.page_no = @"1";
//        [self requestListData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.status = @"-1";
    self.page_no = @"1";
//    [self requestListData];
    [self setNavgation];
    // 刷新数据的通知
    [ANNotificationCenter addObserver:self selector:@selector(notificationRequest) name:@"requestListData" object:nil];
    [self setTableViewRefresh];
}
- (void)notificationRequest
{
    self.page_no = @"1";
    [self requestListData];
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
    [self requestListData];
}
- (void)footerRefresh
{
    self.isRefresh = 0;
    [self requestListData];
}
- (void)dealloc
{
    [ANNotificationCenter removeObserver:self];
}

- (IBAction)clickSegmented:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.status = @"-1";
        self.isRefresh = 1;
        self.page_no = @"1";
    }else if (sender.selectedSegmentIndex == 1) {
        self.status = @"2";
        self.isRefresh = 1;
        self.page_no = @"1";
    }else if (sender.selectedSegmentIndex == 2) {
        self.status = @"1";
        self.isRefresh = 1;
        self.page_no = @"1";
    }else if (sender.selectedSegmentIndex == 3) {
        self.status = @"3";
        self.isRefresh = 1;
        self.page_no = @"1";
    }
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  立即签约
 */
- (IBAction)immediatelySignedAction:(id)sender {
    
    
    ANSignedViewController *signedVC = [[ANSignedViewController alloc] init];
    [self.navigationController pushViewController:signedVC animated:YES];
    
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
        self.navigationItem.title = @"筛选结果";
    }else {
        self.navigationItem.title = @"我的门店";
    }
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    // 设置右边按钮
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_location_white"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBtn)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(clickRightBtn)];
    
}
// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)editCell
{
    [self.tableView setEditing:YES animated:YES];
}
// 核销记录的点击事件
- (void)clickRightBtn
{
    ANLog(@"地点");
    ANSearchStoreVC *searchStoreVC = [[ANSearchStoreVC alloc] init];
    [self.navigationController pushViewController:searchStoreVC animated:YES];
}
#pragma mark ----UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANAreaListTableViewCell *cell = [ANAreaListTableViewCell areaListTableView:tableView];
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.modelDic = self.dataArray[indexPath.row];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HIGH * 82 / 736;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANAreaDetailViewController *areaDetailVC = [[ANAreaDetailViewController alloc] init];
    ANCustomerModel *model = self.dataArray[indexPath.row][@"user_store"];
    ANSubStoreModel *subStoreModel = self.dataArray[indexPath.row][@"store"];
    areaDetailVC.delegate = self;
    areaDetailVC.subStoreID = subStoreModel.store_id;
    areaDetailVC.owner_id = model.owner_id;
    areaDetailVC.status = self.status;
    areaDetailVC.indexPath = indexPath;
    [self.navigationController pushViewController:areaDetailVC animated:YES];
}
#pragma mark UIViewControllerPreviewingDelegate
//peek(预览)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    self.selectIndexPath = indexPath;
    //设定预览的界面
    ANAreaDetailViewController *areaDetailVC = [[ANAreaDetailViewController alloc] init];
    ANCustomerModel *model = self.dataArray[indexPath.row][@"user_store"];
    ANSubStoreModel *subStoreModel = self.dataArray[indexPath.row][@"store"];
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
- (void)deleteStore:(NSString *)ownerID
{
    self.ownerID = ownerID;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该门店,删除后将无法恢复!\n该账号将被停用,如需重签请联系客服!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)deleteStoreSuccess:(NSIndexPath *)indexPath
{
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self clickDeleteStore];
    }
}


- (IBAction)clickNoInfoImg:(id)sender {
    if (self.noInfoImg.image == [UIImage imageNamed:@"noInfo"]) {
        
    }else {
        ANHelpHFiveViewController *helpVC = [[ANHelpHFiveViewController alloc] init];
        [self.navigationController pushViewController:helpVC animated:YES];
    }
}

#pragma mark -- 网络请求
- (void)requestListData
{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:@"0" forKey:@"only_chain_shop"];
    [parmDic setObject:self.page_no forKey:@"page_no"];
    [parmDic setObject:@"0" forKey:@"page_size"];
    [parmDic setObject:self.status forKey:@"status"];
    [parmDic setObject:@"0" forKey:@"type"];
    parmDic = (NSMutableDictionary *)[ANCommon dicToSign:parmDic];
    [parmDic setObject:self.unset forKey:@"unset"];
//    ANLog(@"%@",parmDic);
    [ANHttpTool postWithUrl:@"/api/1/store/list_agency_user_stores" params:parmDic successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
//        ANLog(@"%@",responseObject);
        [self parseOrderDtail:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
        if (self.isRefresh) {
            if ([responseObject[@"message"] isEqualToString:@"暂无门店信息"]) {
                self.noInfoView.hidden = NO;
                if (self.isHaveData) {
                    self.noInfoImg.image = [UIImage imageNamed:@"noInfo"];
                }else {
                    self.noInfoImg.image = [UIImage imageNamed:@"mendian"];
                }
            }
        }else {
            
        }
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_header endRefreshing];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)parseOrderDtail:(id)data
{
    self.noInfoView.hidden = NO;
    
    NSArray *tempArr = data[@"response"][@"data_list"];
    
    if ([self.status integerValue] == -1 && tempArr.count == 0) {
        self.isHaveData = NO;
    } else if ([self.status integerValue] == -1 && tempArr.count != 0) {
        self.isHaveData = YES;
    }
    if (tempArr.count == 0) {
        if (self.isHaveData) {
            self.noInfoImg.image = [UIImage imageNamed:@"noInfo"];
        }else {
            self.noInfoImg.image = [UIImage imageNamed:@"mendian"];
        }
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    NSMutableArray *dataArr = [NSMutableArray array];
    
    for (NSDictionary *dic in tempArr) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        ANCustomerModel *model = [ANCustomerModel mj_objectWithKeyValues:dic[@"user_store"]];
        model.storeStateType = self.status;
        ANSubStoreModel *subModel = [ANSubStoreModel mj_objectWithKeyValues:dic[@"store"]];
        [tempDic setObject:model forKey:
         @"user_store"];
        [tempDic setObject:subModel forKey:@"store"];
        [dataArr addObject:tempDic];
    }
    [self.tableView.mj_header endRefreshing];
    if (self.isRefresh) {
        self.dataArray = dataArr;
        [self setTableViewLoadData];
    }else {
        [self.dataArray addObjectsFromArray:dataArr];
    }
    if (data[@"response"]) {
        self.noInfoView.hidden = YES;
    }
    [self.tableView reloadData];

    
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
                self.topPromptLabel.text = [NSString stringWithFormat:@"您目前有%@家门店未调整价格,%@家门店未绑定设备.>>",self.unset_price_store_num,self.unset_device_store_num];
                [self.view removeConstraint:self.topConstraint];
                [self.view addConstraint:self.topViewConstraint];
            }
        }
    }
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
-  (void)clickDeleteStore
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.ownerID forKey:@"owner_id"];
    params = (NSMutableDictionary *)[ANCommon dicToSign:params];
    [ANHttpTool postWithUrl:@"/api/1/store/del_user_store" params:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
//        ANLog(@"%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
        [self.dataArray removeObjectAtIndex:self.selectIndexPath.row];
        [self.tableView reloadData];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
//        ANLog(@"%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
}
- (IBAction)clickTopBtn:(id)sender {
    
    if ([self.unset isEqualToString:@"1"]) {
        
    }else {
        ANAreaListViewController *areaListVC = [[ANAreaListViewController alloc] init];
        areaListVC.unset = @"1";
        [self.navigationController pushViewController:areaListVC animated:YES];
    }
}

@end

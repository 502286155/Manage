//
//  ANPeopleStoreListVC.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/19.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANPeopleStoreListVC.h"
#import "ANAreaListTableViewCell.h"
#import "ANAreaDetailViewController.h"
#import "ANHttpTool.h"
#import "ANCustomerModel.h"
#import "ANSubStoreModel.h"
#import "ANSignedViewController.h"
#import "MJRefresh.h"
#import "ANHelpHFiveViewController.h"
#import "ANStoreSelectPeopleVC.h"

@interface ANPeopleStoreListVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *status;
@property (weak, nonatomic) IBOutlet UIView *noInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *noInfoImg;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isHaveData;

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (weak, nonatomic) IBOutlet UIView *selectBottomView;
/**
 *  是否全选
 */
@property (nonatomic, assign) BOOL isSelect;
@property (weak, nonatomic) IBOutlet UIView *bottomSelectView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

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

@implementation ANPeopleStoreListVC

- (NSMutableArray *)selectArr
{
    if (_selectArr == nil) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (UIButton *)rightBtn
{
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0, 0, 50, 30);
        [_rightBtn setTitle:@"迁移" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

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
    [ANNotificationCenter addObserver:self selector:@selector(requestListData) name:@"requestListData" object:nil];
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
    }else if (sender.selectedSegmentIndex == 1) {
        self.status = @"2";
    }else if (sender.selectedSegmentIndex == 2) {
        self.status = @"1";
    }else if (sender.selectedSegmentIndex == 3) {
        self.status = @"3";
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
    self.navigationItem.title = @"门店列表";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    // 设置右边按钮
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_location_white"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBtn)];
    
}
// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickRightBtn:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"迁移"]) {
        [self.tableView setEditing:YES animated:YES];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        self.selectBottomView.hidden = NO;
        self.bottomSelectView.hidden = YES;
    }else {
        [self.tableView setEditing:NO animated:YES];
        [btn setTitle:@"迁移" forState:UIControlStateNormal];
        self.selectBottomView.hidden = YES;
        self.bottomSelectView.hidden = NO;
    }
}
- (IBAction)clickStartChangeBtn:(id)sender {
    [self.tableView setEditing:YES animated:YES];
    [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.selectBottomView.hidden = NO;
    self.bottomSelectView.hidden = YES;
}

// 核销记录的点击事件
- (void)clickRightBtn
{
    ANLog(@"地点");
}
/**
 *  全选
 */
- (IBAction)clickAllSelectBtn:(id)sender {
    self.isSelect = !self.isSelect;
    [self.selectArr removeAllObjects];
    for (int i = 0; i < self.dataArray.count ; i++) {
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        if (self.isSelect) {
            self.selectImageView.image = [UIImage imageNamed:@"select"];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }else {
            self.selectImageView.image = [UIImage imageNamed:@"unSelect"];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

/**
 *  指派人员
 */
- (IBAction)reassignBtn:(id)sender {
    ANStoreSelectPeopleVC *selectMarketVC = [[ANStoreSelectPeopleVC alloc] init];
    selectMarketVC.sourceVC = @"1";
    selectMarketVC.marketing_id = self.marketing_id;
    NSMutableArray *arr = [NSMutableArray array];
    if (self.isSelect) {
        for (NSDictionary *dict in self.dataArray) {
            ANCustomerModel *model = dict[@"user_store"];
            [arr addObject:model.owner_id];
        }
    }else {
        if (self.selectArr.count == 0) {
            [ANCommon setAlertViewWithMessage:@"请先选择要迁移的掌柜"];
            return;
        }
        for (ANCustomerModel *model in self.selectArr) {
            [arr addObject:model.owner_id];
        }
    }
    selectMarketVC.ownerIDArr = arr;
//    [self.tableView setEditing:NO animated:YES];
//    [self.rightBtn setTitle:@"迁移" forState:UIControlStateNormal];
    [self.navigationController pushViewController:selectMarketVC animated:YES];
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
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.modelDic = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HIGH * 82 / 736;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANCustomerModel *model = self.dataArray[indexPath.row][@"user_store"];
    ANSubStoreModel *subStoreModel = self.dataArray[indexPath.row][@"store"];
    if (tableView.editing) {
        [self.selectArr addObject:model];
    }else {
        ANAreaDetailViewController *areaDetailVC = [[ANAreaDetailViewController alloc] init];
        areaDetailVC.subStoreID = subStoreModel.store_id;
        areaDetailVC.owner_id = model.owner_id;
        areaDetailVC.status = self.status;
        [self.navigationController pushViewController:areaDetailVC animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        ANCustomerModel *model = self.dataArray[indexPath.row][@"user_store"];
        [self.selectArr removeObject:model];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
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
    [parmDic setObject:self.marketing_id forKey:@"marketing_id"];
    ANLog(@"%@",parmDic);
    
    [ANHttpTool postWithUrl:@"/api/1/store/list_agency_user_stores" params:parmDic successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseOrderDtail:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
        [self.tableView.mj_header endRefreshing];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)parseOrderDtail:(id)data
{
    self.noInfoView.hidden = NO;
    ANLog(@"区域管理 : data : %@", data);
    
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

@end

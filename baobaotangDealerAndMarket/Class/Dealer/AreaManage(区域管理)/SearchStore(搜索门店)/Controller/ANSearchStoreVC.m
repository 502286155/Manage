//
//  ANSearchStoreVC.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/5/13.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANSearchStoreVC.h"
#import "ANAreaListTableViewCell.h"
#import "ANHttpTool.h"
#import "ANAreaDetailViewController.h"
#import "ANCustomerModel.h"
#import "MJRefresh.h"
#import "ANCustomerManageCell.h"
#import "ANCheckInModel.h"
#import "ANNewCheckInViewController.h"
#import "ANSelectDeviceViewController.h"
#import "ANSubPriceAdjustmentViewController.h"

@interface ANSearchStoreVC ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, ANCustomerManageCell>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (nonatomic, assign) BOOL isRefresh;
/**
 *  要请求的页码
 */
@property (nonatomic, copy) NSString *page_no;
/**
 *  总页数
 */
@property (nonatomic, copy) NSString *pages;
@property (weak, nonatomic) IBOutlet UIView *noInfoView;

@end

@implementation ANSearchStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNav];
    [self.searchBar becomeFirstResponder];
    self.isRefresh = YES;
}

- (void)setNav
{
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    
    self.navigationItem.title = @"搜索门店";
}
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
    if (self.isMarking) {
        ANCustomerManageCell *cell = [ANCustomerManageCell customermanageTabelView:tableView];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.modelDic = self.dataArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        ANAreaListTableViewCell *cell = [ANAreaListTableViewCell areaListTableView:tableView];
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.modelDic = self.dataArray[indexPath.row];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isMarking) {
        return 189;
    }else {
        return HIGH * 82 / 736;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANAreaDetailViewController *areaDetailVC = [[ANAreaDetailViewController alloc] init];
    ANCustomerModel *model = self.dataArray[indexPath.row][@"user_store"];
    ANSubStoreModel *subStoreModel = self.dataArray[indexPath.row][@"store"];
//    areaDetailVC.delegate = self;
    areaDetailVC.subStoreID = subStoreModel.store_id;
    areaDetailVC.owner_id = model.owner_id;
    areaDetailVC.status = @"-1";
    areaDetailVC.indexPath = indexPath;
    [self.navigationController pushViewController:areaDetailVC animated:YES];
}

#pragma mark ----ANCustomerManageCellDelegate
- (void)customerManageCell:(ANCustomerManageCell *)cell clickCheckInBtn:(UIButton *)btn
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = self.dataArray[indexPath.row];
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
    ANSubPriceAdjustmentViewController *priceAdjustment = [[ANSubPriceAdjustmentViewController alloc] init];
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    ANSubStoreModel *model = dic[@"store"];
    ANCustomerModel *custModel = dic[@"user_store"];
    priceAdjustment.store_id = model.store_id;
    priceAdjustment.storeCount = custModel.store_num;
    priceAdjustment.storeName = model.title;
    [self.navigationController pushViewController:priceAdjustment animated:YES];
}

- (IBAction)clickSearchBtn:(id)sender {
    [self.searchBar resignFirstResponder];
    self.isRefresh = YES;
    [self requestData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.isRefresh = YES;
    [self requestData];
}

- (void)setTableViewLoadData
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}
- (void)footerRefresh
{
    self.isRefresh = 0;
    [self requestData];
}

- (void)requestData
{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:@"0" forKey:@"only_chain_shop"];
    [parmDic setObject:@"1" forKey:@"page_no"];
    [parmDic setObject:@"0" forKey:@"page_size"];
    [parmDic setObject:@"-1" forKey:@"status"];
    [parmDic setObject:@"0" forKey:@"type"];
    parmDic = (NSMutableDictionary *)[ANCommon dicToSign:parmDic];
    [parmDic setObject:self.searchBar.text forKey:@"realname_or_title"];
    
    [ANHttpTool postWithUrl:@"/api/1/store/list_agency_user_stores" params:parmDic successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [self parseOrderDtail:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
        if (self.isRefresh) {
            if ([responseObject[@"message"] isEqualToString:@"暂无门店信息"]) {
                self.noInfoView.hidden = NO;
            }
        }else {
            self.noInfoView.hidden = YES;
        }
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
}

- (void)parseOrderDtail:(id)data
{
    
    NSArray *tempArr = data[@"response"][@"data_list"];

    NSMutableArray *dataArr = [NSMutableArray array];
    
    for (NSDictionary *dic in tempArr) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        ANCustomerModel *model = [ANCustomerModel mj_objectWithKeyValues:dic[@"user_store"]];
        model.storeStateType = @"-1";
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
    [self.tableView reloadData];
    if (self.isRefresh) {
        self.tableView.mj_footer = nil;
        [self setTableViewLoadData];
    }
    // 判断页码
    [self judgePages:data[@"response"][@"pages"]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  ANNewCheckInViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/18.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANNewCheckInViewController.h"
#import "ANCheckInCell.h"
#import "ANSelectDeviceViewController.h"
#import "ANHttpTool.h"
#import "ANCheckInModel.h"

@interface ANNewCheckInViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ANNewCheckInViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
    [MobClick beginLogPageView:@"设备登记门店列表页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"设备登记门店列表页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];
    [self requestData];
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
    self.navigationItem.title = @"设备绑定";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
// 返回的点击事件
- (void)returnClick
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
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANCheckInCell *cell = [ANCheckInCell checkInTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANSelectDeviceViewController *selectDeviceVC = [[ANSelectDeviceViewController alloc] init];
    ANCheckInModel *model = self.dataArr[indexPath.row];
    selectDeviceVC.model = model;
    selectDeviceVC.storeName = model.store_title;
    selectDeviceVC.storeID = model.ID;
    [self.navigationController pushViewController:selectDeviceVC animated:YES];
}

#pragma mark ---- 网络请求
- (void)requestData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.storeID forKey:@"store_id"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    ANLog(@"%@",parmDict);
    [ANHttpTool postWithUrl:@"/api/1/store/get_store_device_num_list" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"success:%@",responseObject);
        [self parseSuperStoreData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)parseSuperStoreData:(id)data
{
    NSArray *tempArr = data[@"response"];
    self.dataArr = [NSMutableArray array];
    for (NSDictionary *dict in tempArr) {
        ANCheckInModel *model = [ANCheckInModel mj_objectWithKeyValues:dict];
        [self.dataArr addObject:model];
    }
    [self.tableView reloadData];
}

@end

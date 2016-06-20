//
//  ANSelectDeviceViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/18.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANSelectDeviceViewController.h"
#import "ANSelectCheckInCell.h"
#import "ANHttpTool.h"
#import "ANSelectCheckInModel.h"
#import "ANDeviceDetailViewController.h"

@interface ANSelectDeviceViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@end

@implementation ANSelectDeviceViewController

- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
    [MobClick beginLogPageView:@"设备登记设备列表页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"设备登记设备列表页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.topLabel.text = [NSString stringWithFormat:@"正在操作:%@",self.storeName];
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.13858696 * HIGH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANSelectCheckInCell *cell = [ANSelectCheckInCell selectCheckInCell:tableView];
    cell.model = self.dataArr[indexPath.row];
//    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ANSelectCheckInModel *selectModel = self.dataArr[indexPath.row];
    
    ANDeviceDetailViewController *deviceDetailVC = [[ANDeviceDetailViewController alloc] init];
    
    if ([selectModel.res_name isEqualToString:@"old_machine"]) {
        deviceDetailVC.deviceName = @"Ⅰ代保温箱";
        deviceDetailVC.deviceNo = @"1";
    }else if ([selectModel.res_name isEqualToString:@"machine"]) {
        deviceDetailVC.deviceName = @"Ⅱ代保温箱";
        deviceDetailVC.deviceNo = @"2";
    }else if ([selectModel.res_name isEqualToString:@"adbox"]) {
        deviceDetailVC.deviceName = @"液晶屏";
        deviceDetailVC.deviceNo = @"3";
    }else if ([selectModel.res_name isEqualToString:@"ibeacon"]) {
        deviceDetailVC.deviceName = @"摇一摇";
        deviceDetailVC.deviceNo = @"4";
    }else if ([selectModel.res_name isEqualToString:@"game_table"]) {
        deviceDetailVC.deviceName = @"游戏娱乐桌";
        deviceDetailVC.deviceNo = @"5";
    }
    deviceDetailVC.model = selectModel;
//    if (![selectModel.status isEqualToString:@""] && ![selectModel.status isEqualToString:@"1"]) {
//        deviceDetailVC.isDevice = YES;
//        deviceDetailVC.deviceNum = selectModel.device_no;
//    }
    deviceDetailVC.res_name = selectModel.res_name;
    deviceDetailVC.storeID = self.storeID;
    [self.navigationController pushViewController:deviceDetailVC animated:YES];
}

#pragma mark ----网络请求
- (void)requestData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.storeID forKey:@"store_id"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    //老接口 /api/1/store/get_store_device
    [ANHttpTool postWithUrl:@"/api/1/store/get_store_device_info_list" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [self parseSuperStoreData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
}
- (void)parseSuperStoreData:(id)data
{
    ANLog(@"%@",data);
    NSArray *tempArr = [ANSelectCheckInModel mj_objectArrayWithKeyValuesArray:data[@"response"]];
    
    [self sortData:tempArr];
}
- (void)sortData:(NSArray *)arr
{
    [self.dataArr removeAllObjects];
    for (ANSelectCheckInModel *model in arr) {
        if ([model.res_name isEqualToString:@"old_machine"]) {
            [self.dataArr addObject:model];
        }
    }
    for (ANSelectCheckInModel *model in arr) {
        if ([model.res_name isEqualToString:@"machine"]) {
            [self.dataArr addObject:model];
        }
    }
    for (ANSelectCheckInModel *model in arr) {
        if ([model.res_name isEqualToString:@"adbox"]) {
            [self.dataArr addObject:model];
        }
    }
    for (ANSelectCheckInModel *model in arr) {
        if ([model.res_name isEqualToString:@"ibeacon"]) {
            [self.dataArr addObject:model];
        }
    }
    for (ANSelectCheckInModel *model in arr) {
        if ([model.res_name isEqualToString:@"game_table"]) {
            [self.dataArr addObject:model];
        }
    }
    [self.tableView reloadData];
}



@end

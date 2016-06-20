//
//  ANStoreSelectPeopleVC.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/21.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANStoreSelectPeopleVC.h"
#import "ANStoreSelectPeopleCell.h"
#import "ANHttpTool.h"
#import "ANPeopleManageModel.h"

@interface ANStoreSelectPeopleVC ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ANPeopleManageModel *selectModel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic , assign) NSInteger selectNum;

@end

@implementation ANStoreSelectPeopleVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"选择其他市场人员配送页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"选择其他市场人员配送页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];
    [self requestData];
    self.selectNum = 0;
    self.returnBtn.layer.borderColor = [UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0].CGColor;
    self.returnBtn.layer.borderWidth = 1;
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
    self.navigationItem.title = @"选择人员";
    if ([self.sourceVC isEqualToString:@"1"]) {
        self.navigationItem.title = @"迁移掌柜";
        self.topLabel.text = @"请选择要接收您选择掌柜的人员";
        self.bottomLabel.text = @"确认迁移后所选掌柜将更换至新的管理人员。";
    }
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickReturnBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickSureBtn:(id)sender {
    self.selectModel = self.dataArray[self.selectNum];
    
    UIAlertView *aleartView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定要把所选门店迁移给%@进行管理吗?",self.selectModel.realname] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [aleartView show];
}

#pragma mark ---- UITableViewDelegate
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
    ANStoreSelectPeopleCell *cell = [ANStoreSelectPeopleCell selectMarketTabelView:tableView];
    if (indexPath.row == self.selectNum) {
        cell.isSelect = YES;
    }else {
        cell.isSelect = NO;
    }
    cell.peopleModel = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectNum = indexPath.row;
    [self.tableView reloadData];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self performSelector:@selector(requestMoveStore) withObject:nil afterDelay:0.5f];
    }
}
- (void)requestMoveStore
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[self.ownerIDArr mj_JSONString] forKey:@"owner_ids"];
    if ([self.selectModel.ID isEqualToString:@"-1"]) {
        [dict setObject:@"-1" forKey:@"to_agency"];
        [dict setObject:@"0" forKey:@"market_id"];
    }else {
        [dict setObject:self.selectModel.ID forKey:@"market_id"];
        [dict setObject:@"0" forKey:@"to_agency"];
    }
    NSDictionary *params = [ANCommon dicToSign:dict];
    ANLog(@"%@",params);
    [ANHttpTool postWithUrl:@"/api/1/dealers/store_to_market" params:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [[ANCommon alloc] setAlertView:responseObject[@"response"][@"info"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (UIViewController *vc in self.navigationController.childViewControllers) {
                ANLog(@"%@",[vc class]);
            }
            [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3] animated:YES];
            return ;
        });
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
}
#pragma mark --- 网络请求
- (void)requestData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [parmDict setObject:self.marketing_id forKey:@"marketing_id"];
    if ([self.sourceVC isEqualToString:@"1"]) {
        if ([self.marketing_id isEqualToString:@"0"]) {
            [parmDict setObject:@"2" forKey:@"t"];
        }else {
            [parmDict setObject:@"1" forKey:@"t"];
        }
    }

    [ANHttpTool postWithUrl:@"/api/1/dealers/get_people_list" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseSubStoreData:responseObject];
        ANLog(@"%@", responseObject);
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)parseSubStoreData:(id)data
{
    NSDictionary *dict = data[@"response"];
    self.dataArray = [NSMutableArray array];
    if (dict) {
        NSMutableArray *tempArr = [ANPeopleManageModel mj_objectArrayWithKeyValuesArray:data[@"response"]];
        self.dataArray = tempArr;
        [self.tableView reloadData];
    }else {
        [[ANCommon alloc] setAlertView:@"您还没有员工可以指派 请新建后再试。"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}


@end

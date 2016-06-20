//
//  ANPeopleManageViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/17.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANPeopleManageViewController.h"
#import "ANMyPeopleCell.h"
#import "ANDevelopingTableViewCell.h"
#import "ANPeopleDetailViewController.h"
#import "ANCreatPeopleViewController.h"
#import "ANHttpTool.h"
#import "ANPeopleManageModel.h"
#import "MJRefresh.h"
#import "ANHelpHFiveViewController.h"
#import "ANPeopleStoreListVC.h"

@interface ANPeopleManageViewController ()<UITableViewDataSource, UITableViewDelegate, ANMyPeopleCellDelegate>

/**
 *  我的成员按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *myPeopleBtn;
/**
 *  正在开发按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *developingBtn;
/**
 *  新建按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *creatBtn;
/**
 *  选择标志(1,我的成员 2,正在开发)
 */
@property (nonatomic, assign) BOOL isSelect;
/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  数据数组
 */
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIView *noInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *noInfoImg;
@property (nonatomic, assign) BOOL isFirest;

@end

@implementation ANPeopleManageViewController

#pragma mark ----生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (self.isFirest == NO) {
        self.isFirest = YES;
    }else {
        [self requestData];
    }
    [MobClick beginLogPageView:@"人员管理列表页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"人员管理列表页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];
    self.dataArr = [NSMutableArray array];
    self.myPeopleBtn.layer.cornerRadius = 5;
    self.myPeopleBtn.layer.masksToBounds = YES;
    [self setTableViewRefresh];
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
    self.navigationItem.title = @"人员管理";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    // 设置右边按钮
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"people_fiflter"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBtn)];
    
}
// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 筛选的点击事件
//- (void)clickRightBtn
//{
//    ANLog(@"筛选");
//}
/**
 *  设置加载刷新
 */
- (void)setTableViewRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self.tableView.mj_header beginRefreshing];
}
// 我的人员的点击事件
- (IBAction)clickMyPeopleBtn:(id)sender {
    ANLog(@"我的人员");
    [self.developingBtn setBackgroundColor:ANColor(223, 223, 223)];
    [self.myPeopleBtn setBackgroundColor:[UIColor whiteColor]];
    [self.creatBtn setTitle:@"新建人员" forState:UIControlStateNormal];
    self.isSelect = NO;
    [self.tableView reloadData];
}
// 正在开发人员的点击事件
- (IBAction)clickDevelopingBtn:(id)sender {
    ANLog(@"正在发开");
    [self.developingBtn setBackgroundColor:[UIColor whiteColor]];
    [self.myPeopleBtn setBackgroundColor:ANColor(223, 223, 223) ];
    [self.creatBtn setTitle:@"新建客户" forState:UIControlStateNormal];
    self.isSelect = YES;
    [self.tableView reloadData];
}
// 新建人员的点击事件
- (IBAction)clickNewPeopleBtn:(id)sender {
    ANLog(@"新建人员");
    ANCreatPeopleViewController *creatPVC = [[ANCreatPeopleViewController alloc] init];
    [self.navigationController pushViewController:creatPVC animated:YES];
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
//    if (self.isSelect) {
//        ANDevelopingTableViewCell *cell = [ANDevelopingTableViewCell developingTableView:tableView];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }else {
    ANMyPeopleCell *cell = [ANMyPeopleCell myPeopleTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.model = self.dataArr[indexPath.row];
    return cell;
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 152;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANPeopleManageModel *peopleModel = self.dataArr[indexPath.row];
    ANPeopleDetailViewController *peopleVC = [[ANPeopleDetailViewController alloc] init];
    peopleVC.marketing_id = peopleModel.ID;
    [self.navigationController pushViewController:peopleVC animated:YES];
}

- (IBAction)clickNoInfoView:(id)sender {
    
    ANHelpHFiveViewController *helpVC = [[ANHelpHFiveViewController alloc] init];
    [self.navigationController pushViewController:helpVC animated:YES];
}
#pragma mark MyPeopleCellDelegate
- (void)myPeopleCell:(ANMyPeopleCell *)cell clickPeopleStoreListBtn:(UIButton *)btn withPeopleModel:(ANPeopleManageModel *)peopleModel
{
    ANPeopleStoreListVC *peopleStoreListVC = [[ANPeopleStoreListVC alloc] init];
    peopleStoreListVC.marketing_id = peopleModel.ID;
    [self.navigationController pushViewController:peopleStoreListVC animated:YES];
}

#pragma mark ----网络请求
- (void)requestData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/dealers/get_people_list" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseSubStoreData:responseObject];
        ANLog(@"%@", responseObject);
        [self.tableView.mj_header endRefreshing];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
        [self.tableView.mj_header endRefreshing];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)parseSubStoreData:(id)data
{
    NSDictionary *dict = data[@"response"];
    
    if (dict) {
        NSMutableArray *tempArr = [ANPeopleManageModel mj_objectArrayWithKeyValuesArray:data[@"response"]];
        self.dataArr = tempArr;
        [self.tableView reloadData];
        self.noInfoView.hidden = YES;
    }else {
        self.noInfoView.hidden = NO;
    }
}

@end

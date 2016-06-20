//
//  ANDistributionViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/23.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANDistributionViewController.h"
#import "ANDistributionCell.h"
#import "ANMarkPurchaseDetailViewController.h"
#import "ANHttpTool.h"
#import "ANDistributionListModel.h"         //第一级列表model
#import "ANStoreInfoModel.h"                //第二级店铺信息model
#import "ANUserInfoModel.h"                 //第三级人员信息model
#import "ANAssignUserModel.h"               //指派人员信息
#import "ANHelpHFiveViewController.h"
#import "MJRefresh.h"

@interface ANDistributionViewController ()<UITableViewDataSource, UITableViewDelegate, ANDistributionCellDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *hiddenView;

@property (weak, nonatomic) IBOutlet UILabel *hiddenTextLabel;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  没有信息的视图
 */
@property (weak, nonatomic) IBOutlet UIView *noInfoView;
/**
 *  处理视图
 */
@property (weak, nonatomic) IBOutlet UIView *sendView;
/**
 *  默认人员姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *defaultNameLabel;
/**
 *  默认人员图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *defaultImg;
/**
 *  指派他人图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *otherImg;
/**
 *  处理视图取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sendCancelBtn;
/**
 *  处理视图确认按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sendSureBtn;
/**
 *  姓名text
 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
/**
 *  电话text
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
/**
 *  处理视图其他人视图
 */
@property (weak, nonatomic) IBOutlet UIView *otherView;
/**
 *  处理状态    0为默认 1为其他
 */
@property (nonatomic, assign) BOOL isSend;
/**
 *  订单编号
 */
@property (nonatomic, copy) NSString *order_no;
/**
 *  门店id
 */
@property (nonatomic, copy) NSString *store_id;
/**
 *  默认人员id
 */
@property (nonatomic, copy) NSString *defaultID;
/**
 *  处理状态  0 开始处理   1 确认收货
 */
@property (nonatomic, assign) BOOL arrangeStatus;
/**
 *  订单状态    0=>全部 1=>等待配送 5=>配送中 10=>配送完成 15=>取消订单
 */
@property (nonatomic, copy) NSString *progress;
@property (weak, nonatomic) IBOutlet UIImageView *noInfoImg;
@property (nonatomic, strong) ANDistributionListModel *distributionModel;
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, assign) BOOL isHaveData;

/**
 *  要上传的页码
 */
@property (nonatomic, copy) NSString *page_no;
/**
 *  总的页码
 */
@property (nonatomic, copy) NSString *pages;
/**
 *  是否刷新
 */
@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation ANDistributionViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"配送处理列表页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isFirst == NO) {
        self.isFirst = YES;
    }else {
//        [self.tableView reloadData];
        self.page_no = @"1";
        self.isRefresh = YES;
        [self requestData];
    }
    [MobClick endLogPageView:@"配送处理列表页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.sendCancelBtn.layer.cornerRadius = 5;
    self.sendSureBtn.layer.cornerRadius = 5;
    self.sendSureBtn.layer.masksToBounds = YES;
    self.sendCancelBtn.layer.masksToBounds = YES;
    self.sendCancelBtn.layer.borderWidth = 1;
    self.sendCancelBtn.layer.borderColor = [UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0].CGColor;
    self.sendSureBtn.layer.borderWidth = 1;
    self.sendSureBtn.layer.borderColor = [UIColor colorWithRed:0.2039 green:0.1255 blue:0.2863 alpha:1.0].CGColor;
    
    self.progress = @"0";
    self.page_no = @"1";
    self.isRefresh = YES;
    
    [self setNavgation];
//    [self requestData];
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
#pragma mark ---- 自定义方法
// 设置nav
- (void)setNavgation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"配送中心";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickSureBtn:(id)sender {
    self.hiddenView.hidden = YES;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.order_no forKey:@"order_id"];
    [parmDict setObject:self.store_id forKey:@"store_id"];
    if (self.arrangeStatus) {
        [parmDict setObject:@"10" forKey:@"progress"];
    }else {
        [parmDict setObject:@"5" forKey:@"progress"];
    }
    ANLog(@"%@",parmDict);
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/order/update_order_progress" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self sureParseSubStoreData:responseObject];
        ANLog(@"-------------------------------------------------------------------------改变订单状态");
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)sureParseSubStoreData:(id)data
{
    self.sendView.hidden = YES;
    NSString *str = data[@"message"];
    if ([str isEqualToString:@"success"]) {
    }
    [self requestData];
}
- (IBAction)clickHiddenViewBtn:(id)sender {
    self.hiddenView.hidden = YES;
}
- (IBAction)clickSegmented:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.progress = @"0";
        self.isRefresh = 1;
        self.page_no = @"1";
        self.noInfoView.hidden = YES;
    }else if (sender.selectedSegmentIndex == 1) {
        self.progress = @"1";
        self.isRefresh = 1;
        self.page_no = @"1";
        self.noInfoView.hidden = YES;
    }else if (sender.selectedSegmentIndex == 2) {
        self.progress = @"5,10";
        self.isRefresh = 1;
        self.page_no = @"1";
        self.noInfoView.hidden = YES;
    }else if (sender.selectedSegmentIndex == 3) {
        self.progress = @"15";
        self.isRefresh = 1;
        self.page_no = @"1";
        self.noInfoView.hidden = YES;   
    }
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ----UITableViewDelegate
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
    ANDistributionCell *cell = [ANDistributionCell distributionTableView:tableView];
//    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANDistributionListModel *model = self.dataArr[indexPath.row];
    ANMarkPurchaseDetailViewController *purchaseVC = [[ANMarkPurchaseDetailViewController alloc] init];
    purchaseVC.order_id = model.order_no;
    purchaseVC.storeName = [NSString stringWithFormat:@"%@·%@",model.storeInfo.title,model.storeInfo.title_branch];
    purchaseVC.storeID = model.store_id;
    purchaseVC.storePeople = model.storeInfo.storeUserInfo.realname;
    purchaseVC.signedName = model.storeInfo.marketingUserInfo.realname;
    purchaseVC.phone = model.assignUserModel.mobile;
    purchaseVC.model = model;
    [self.navigationController pushViewController:purchaseVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 123;
}
#pragma mark ---- 处理方式
// 选择默认人员
- (IBAction)clickDefaultBtn:(id)sender {
    self.defaultImg.image = [UIImage imageNamed:@"send_select"];
    self.otherImg.image = nil;
    self.otherView.hidden = YES;
    self.isSend = NO;
}
// 选择其他人员
- (IBAction)clickOtherBtn:(id)sender {
    self.defaultImg.image = nil;
    self.otherImg.image = [UIImage imageNamed:@"send_select"];
    self.otherView.hidden = NO;
    self.isSend = YES;
}
// 点击确认
- (IBAction)clickSendSureBtn:(id)sender {
    if (self.isSend) {
        if ([self.nameTextField.text isEqualToString:@""]) {
            [ANCommon setAlertViewWithMessage:@"请输入姓名"];
            return;
        }
        if (self.phoneTextField.text.length != 11) {
            [ANCommon setAlertViewWithMessage:@"请输入正确的手机格式"];
            return;
        }
    }
    if (self.isSend) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确认%@开始处理本单配送并告知掌柜",self.nameTextField.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认开始处理本单配送并告知掌柜。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self sendRequestData];
    }
}
// 点击取消
- (IBAction)clicksendCancelBTN:(id)sender {
    self.sendView.hidden = YES;
}
#pragma mark ----处理方式请求
- (void)sendRequestData
{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.order_no forKey:@"order_no"];
    if (self.isSend) {
        [parmDict setObject:@"0" forKey:@"assigned_id"];
        [parmDict setObject:self.nameTextField.text forKey:@"other_assigned_name"];
        [parmDict setObject:self.phoneTextField.text forKey:@"other_assigned_mobile"];
    }else {
        [parmDict setObject:self.defaultID forKey:@"assigned_id"];
    }
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/dealers/assigned_order" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self sendParseSubStoreData:responseObject];
        ANLog(@"-------------------------------------------------------------------------指派人员配送");
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)sendParseSubStoreData:(id)data
{
    ANLog(@"%@",data);
    self.sendView.hidden = YES;
    if ([self.distributionModel.storeInfo.marketingUserInfo.ID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]] && self.isSend == NO) {
        //            self.arrangeStatus = YES;
        [self clickSureBtn:nil];
        return;
    }
    [self requestData];
}
- (IBAction)clickH5Btn:(id)sender {
    if (self.noInfoImg.image == [UIImage imageNamed:@"noInfo"]) {
        
    }else {
        ANHelpHFiveViewController *helpVC = [[ANHelpHFiveViewController alloc] init];
        [self.navigationController pushViewController:helpVC animated:YES];
    }
}

#pragma mark ----ANDistributionCellDelegate
- (void)distributioncell:(ANDistributionCell *)cell clickEndSendBtn:(UIButton *)btn
{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ANDistributionListModel *model = self.dataArr[indexPath.row];
    self.distributionModel = model;
    self.defaultNameLabel.text = [NSString stringWithFormat:@"%@处理",model.storeInfo.marketingUserInfo.realname];
    self.order_no = model.order_no;
    self.defaultID = model.storeInfo.marketingUserInfo.ID;
    self.store_id = model.store_id;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"] isEqualToString:@"5"]) {
        
        if ([self.distributionModel.storeInfo.marketingUserInfo.ID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]] && [self.distributionModel.progress isEqualToString:@"5"]) {
            if ([btn.titleLabel.text isEqualToString:@"确认送达"]) {
                self.hiddenTextLabel.text = @"确认送达并告知掌柜";
                self.hiddenView.hidden = NO;
                self.arrangeStatus = YES;
            }
        }else {
//            self.sendView.hidden = NO;
            [self distributioncell:cell clickSeeDetailBtn:nil];
        }
        
        
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"] isEqualToString:@"10"]) {
        if ([btn.titleLabel.text isEqualToString:@"开始配送"]) {
            [self distributioncell:cell clickSeeDetailBtn:nil];
//            self.hiddenTextLabel.text = @"确认处理本单 商家将收到通知";
//            self.hiddenView.hidden = NO;
//            self.arrangeStatus = NO;
        }else if ([btn.titleLabel.text isEqualToString:@"确认送达"]) {
#warning 文字要修改
            self.hiddenTextLabel.text = @"确认掌柜已经收货 并通知合伙人";
            self.hiddenView.hidden = NO;
            self.arrangeStatus = YES;
        }
    }
}
- (void)distributioncell:(ANDistributionCell *)cell clickSeeDetailBtn:(UIButton *)btn
{
    ANLog(@"查看详情");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ANDistributionListModel *model = self.dataArr[indexPath.row];
    ANMarkPurchaseDetailViewController *purchaseVC = [[ANMarkPurchaseDetailViewController alloc] init];
    purchaseVC.order_id = model.order_no;
    purchaseVC.storeName = model.storeInfo.title;
    purchaseVC.storeID = model.store_id;
    purchaseVC.storePeople = model.storeInfo.storeUserInfo.realname;
    purchaseVC.signedName = model.storeInfo.marketingUserInfo.realname;
    purchaseVC.phone = model.assignUserModel.mobile;
    purchaseVC.model = model;
    [self.navigationController pushViewController:purchaseVC animated:YES];
}
#pragma mark ---- 网络请求
- (void)requestData
{
//    self.noInfoView.hidden = NO;
    
    NSString *urlStr = @"";
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    urlStr = @"/api/1/dealers/get_delivery_list";
    [parmDict setObject:self.page_no forKey:@"page"];
    [parmDict setObject:self.progress forKey:@"progress"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    ANLog(@"%@",parmDict);
    [ANHttpTool postWithUrl:urlStr params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseSubStoreData:responseObject];
        [self.tableView.mj_header endRefreshing];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
        self.noInfoView.hidden = NO;
        if (self.isHaveData == YES) {
            self.noInfoImg.image = [UIImage imageNamed:@"noInfo"];
        }else {
            self.noInfoImg.image = [UIImage imageNamed:@"daiban"];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)parseSubStoreData:(id)data
{
    ANLog(@"%@",data);
    NSArray *parmDict = data[@"response"][@"data_list"];
    
    if ([self.progress isEqualToString:@"0"] && parmDict.count == 0) {
        self.isHaveData = NO;
    }else if ([self.progress isEqualToString:@"0"] && parmDict.count != 0){
        self.isHaveData = YES;
    }
    if (parmDict.count == 0) {
        if (self.isHaveData == YES) {
            self.noInfoImg.image = [UIImage imageNamed:@"noInfo"];
        }else {
            self.noInfoImg.image = [UIImage imageNamed:@"daiban"];
        }
    }
    
    if (parmDict) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict in parmDict) {
            ANDistributionListModel *listModel = [ANDistributionListModel mj_objectWithKeyValues:dict];
            
            ANStoreInfoModel *storeInfoModel = [[ANStoreInfoModel alloc] init];
            ANUserInfoModel *markModel = [[ANUserInfoModel alloc] init];
            ANUserInfoModel *storeModel = [[ANUserInfoModel alloc] init];
            ANAssignUserModel *assignUserModel = [ANAssignUserModel mj_objectWithKeyValues:dict[@"assign_user_info"]];
            if (dict[@"store_info"]) {
                
                storeInfoModel = [ANStoreInfoModel mj_objectWithKeyValues:dict[@"store_info"]];
                markModel = [ANUserInfoModel mj_objectWithKeyValues:dict[@"store_info"][@"marketing_user_info"]];
                storeModel = [ANUserInfoModel mj_objectWithKeyValues:dict[@"store_info"][@"store_user_info"]];
            }else {
            }
            storeInfoModel.marketingUserInfo = markModel;
            storeInfoModel.storeUserInfo = storeModel;
            listModel.assignUserModel = assignUserModel;
            listModel.storeInfo = storeInfoModel;
            
            NSString *typeID = [[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"];
            if ([typeID isEqualToString:@"10"]) {
                if ([listModel.progress isEqualToString:@"1"] && [listModel.is_assigned isEqualToString:@"0"]) {
                }else {
                    [tempArr addObject:listModel];
                }
            }else {
                [tempArr addObject:listModel];
            }
        }
        if (self.isRefresh) {
            self.dataArr = tempArr;
        }else {
            [self.dataArr addObjectsFromArray:tempArr];
        }
        [self.tableView reloadData];
        self.noInfoView.hidden = YES;
    }else {
        self.noInfoView.hidden = NO;
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

@end

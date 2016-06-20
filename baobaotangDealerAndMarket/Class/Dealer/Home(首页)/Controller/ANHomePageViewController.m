//
//  ANHomePageViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/16.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANHomePageViewController.h"
#import "ANAreaListViewController.h"        //区域管理
#import "ANPurchasesViewController.h"
#import "ANPeopleManageViewController.h"    //人员管理
#import "ANDistributionViewController.h"    //送货中心
#import "ANMessageViewController.h"         //消息中心
#import "ANHttpTool.h"
#import "ANMineCenterViewController.h"
#import "ANDealerHomeModel.h"
#import "ANEmptyViewController.h"
#import "UpdateVersion.h"
#import "ANPaySuccessViewController.h"
#import "ANFirstGuideViewController.h"
#import "ANNavigationController.h"
#import "JPUSHService.h"

@interface ANHomePageViewController ()

#pragma mark --- navgation
/**
 *  左边按钮
 */
@property (weak, nonatomic) UIButton *leftButton;

#pragma mark ---- 顶部额度视图
/**
 *  顶部视图
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 *  顶部本月额度Label
 */
@property (weak, nonatomic) IBOutlet UILabel *totalSaleLabel;

/**
 *  总出货量
 */
@property (weak, nonatomic) IBOutlet UILabel *totalSalesVolumeLabel;

/**
 *  总积分量
 */
@property (weak, nonatomic) IBOutlet UILabel *totalIntegerLabel;


#pragma mark ---- 中部箱数视图
/**
 *  中部视图
 */
@property (weak, nonatomic) IBOutlet UIView *middleView;
/**
 *  月销(箱)Label
 */
@property (weak, nonatomic) IBOutlet UILabel *numOfMonthLabel;
/**
 *  库存(箱)Label
 */
@property (weak, nonatomic) IBOutlet UILabel *numOfStockLabel;
#pragma mark ---- 底部销量视图
/**
 *  底部视图
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/**
 *  今日销量Label
 */
@property (weak, nonatomic) IBOutlet UILabel *numOfTodayLabel;
/**
 *  昨天销量Label
 */
@property (weak, nonatomic) IBOutlet UILabel *numOfYesterdayLabel;
#pragma mark ---- 按钮视图
/**
 *  按钮视图
 */
@property (weak, nonatomic) IBOutlet UIView *btnsView;
/**
 *  区域按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
/**
 *  区域数量Label
 */
@property (weak, nonatomic) IBOutlet UILabel *areaNumLabel;
/**
 *  人员按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *peopleBtn;
/**
 *  人数Label
 */
@property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;
/**
 *  送货中心按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
/**
 *  送货数量Label
 */
@property (weak, nonatomic) IBOutlet UILabel *sendNumLabel;
/**
 *  库存按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *stockBtn;
/**
 *  库存数量Label
 */
@property (weak, nonatomic) IBOutlet UILabel *stockNumLabel;
/**
 *  积分有奖按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *awardBtn;
/**
 *  积分数量Label
 */
@property (weak, nonatomic) IBOutlet UILabel *awardNumLabel;
/**
 *  待办事项按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *todolistBtn;
/**
 *  待办事项数量Label
 */
@property (weak, nonatomic) IBOutlet UILabel *todolistNumLabel;
/**
 *  红点
 */
@property (nonatomic, strong) UILabel *numRedLabel;

@property (nonatomic, strong) ANDealerHomeModel *model;

/**
 *  提示版本更新类
 */
@property (nonatomic, strong) UpdateVersion *updateV;


@end

@implementation ANHomePageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestHomeData];
    [MobClick beginLogPageView:@"经销商首页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"经销商首页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubView];
    
    [self setNavigation];
    
    // 提示版本更新
    UpdateVersion *UpdateV = [[UpdateVersion alloc] init];
    self.updateV = UpdateV;
    [UpdateV checkUpdateVersionWith:@"dealer"];
    
    // 请求经销商的store_id，判断有无初始化
    [self requestAgency_store_info];
}

- (void)setNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 添加上这一句，可以去掉导航条下边的shadowImage，就可以正常显示了
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = NO;
    
    // 设置左边按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 110, 44);
    [leftButton setImage:[UIImage imageNamed:@"nav_headImge"] forState:UIControlStateNormal];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 90)];
    [leftButton setTitle:@" " forState:UIControlStateNormal];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.leftButton = leftButton;
    
    // 右边按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 31, 27);
    [button setImage:[UIImage imageNamed:@"message_icon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    // 红色圆点Label
    self.numRedLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, -3, 16, 16)];
    self.numRedLabel.layer.cornerRadius = 8;
    self.numRedLabel.layer.masksToBounds = YES;
    self.numRedLabel.text = @"0";
    self.numRedLabel.textColor = [UIColor whiteColor];
    self.numRedLabel.textAlignment = NSTextAlignmentCenter;
    self.numRedLabel.font = [UIFont systemFontOfSize:12];
    self.numRedLabel.backgroundColor = [UIColor redColor];
    [button addSubview:self.numRedLabel];
    self.numRedLabel.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    // 设置标题
    self.navigationItem.title = @"你好,合伙人";
    UIColor * color = [UIColor whiteColor];
    NSMutableDictionary * dict=[NSMutableDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
#pragma mark ---- 自定义方法
- (void)setSubView
{
    self.topView.backgroundColor = ANColor(52, 32, 73);
    self.middleView.backgroundColor = ANColor(52, 32, 73);
    self.bottomView.backgroundColor = ANColor(231, 77, 110);
}
- (void)leftButtonAction
{
    ANLog(@"左边按钮");
    ANMineCenterViewController *mine = [[ANMineCenterViewController alloc] init];
//    // 创建动画
//    CATransition* transition = [CATransition animation];
//    // 修改动画的方式
//    transition.type = kCATransitionPush;//可更改为其他方式
//    // 设置动画的方向
//    transition.subtype = kCATransitionFromLeft;//可更改为其他方式
//    // 修改nav
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:mine animated:NO];
}

- (void)rightButtonAction
{
    ANLog(@"右边按钮");
    ANMessageViewController *messageVC = [[ANMessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (IBAction)clcikAreaBtn:(id)sender {
    ANLog(@"区域管理");
    ANAreaListViewController *areaVC = [[ANAreaListViewController alloc] init];
    areaVC.unset = @"0";
    [self.navigationController pushViewController:areaVC animated:YES];
}
- (IBAction)clickPeopleBtn:(id)sender {
    ANLog(@"人员管理");
    ANPeopleManageViewController *peopleVC = [[ANPeopleManageViewController alloc] init];
    [self.navigationController pushViewController:peopleVC animated:YES];
}
- (IBAction)clickSendBtn:(id)sender {
    ANLog(@"送货中心");
    ANDistributionViewController *distributionVC = [[ANDistributionViewController alloc] init];
    [self.navigationController pushViewController:distributionVC animated:YES];
}
- (IBAction)clickStockBtn:(id)sender {
    ANLog(@"库存管理");
    [self requestCheckOrder];
}

// 检查是否有未完成的订单（已取消该功能）
- (void)requestCheckOrder
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"agencyStoreId"] forKey:@"store_id"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/order/check_order" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseTaskLoadData:responseObject[@"response"]];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"error:%@",error);
    }];
}
// 解析是否有未完成的订单
- (void)parseTaskLoadData:(id)data
{
    if (1 == [data[@"is_order_ing"] integerValue]) { // 有未完成订单
        ANPaySuccessViewController *paySuccess = [[ANPaySuccessViewController alloc] init];
        paySuccess.isHomeVC = YES;
        paySuccess.store_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"agencyStoreId"];
        [self.navigationController pushViewController:paySuccess animated:YES];
    } else {  // 没有未完成的订单
        NSString *storeID = [[NSUserDefaults standardUserDefaults] objectForKey:@"agencyStoreId"];
        if (storeID.length != 0) {
            ANPurchasesViewController *stockVC = [[ANPurchasesViewController alloc] init];
            stockVC.storeID = storeID;
            [self.navigationController pushViewController:stockVC animated:YES];
        }
    }
}
- (IBAction)clickAwardBtn:(id)sender {
    ANLog(@"积分有奖");
    
    ANEmptyViewController *empty = [[ANEmptyViewController alloc] init];
    empty.title = @"我的积分";
    [self.navigationController pushViewController:empty animated:YES];
}
- (IBAction)clickTodolistBtn:(id)sender {
    ANLog(@"拍照任务");
    ANEmptyViewController *empty = [[ANEmptyViewController alloc] init];
    empty.title = @"拍照任务";
    [self.navigationController pushViewController:empty animated:YES];
    
}

/**
 *  获取经销商的商铺id
 */
- (void)requestAgency_store_info
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/store/get_agency_store_info" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"response"][@"id"] forKey:@"agencyStoreId"];
        NSString *is_old = responseObject[@"response"][@"is_old"];  // 是否为老经销商 1为是 0为不是
        NSString *is_init = responseObject[@"response"][@"is_init"]; // 是否初始化过   1为有 0为没有
        if ([is_init integerValue] == 0) {
            ANFirstGuideViewController *first = [[ANFirstGuideViewController alloc] init];
            ANNavigationController *nav = [[ANNavigationController alloc] initWithRootViewController:first];
            first.store_id = responseObject[@"response"][@"id"];
            if ([is_old integerValue] == 1) { // 老经销商
                first.buttonTitle = @"盘点库存";
            } else {  // 新经销商
                first.buttonTitle = @"首次进货";
            }
            [self presentViewController:nav animated:YES completion:nil];
        }
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"error:%@",error);
    }];
}

/**
 *  经销商首页
 */
- (void)requestHomeData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    
    NSString *registrationID = [JPUSHService registrationID];
    if (registrationID) {
        if ([registrationID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]]) {
            [parmDict setValue:registrationID forKey:@"device_id"];
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
            [parmDict setValue:registrationID forKey:@"device_id"];
        }
    }else {
        [parmDict setValue:registrationID forKey:@"device_id"];
    }
    ANLog(@"%@",parmDict);
    [ANHttpTool postWithUrl:@"/api/1/user/agency_index" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseDealerHomeData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        
        ANLog(@"=-error:%@",error);
    }];
}

- (void)parseDealerHomeData:(id)data
{
    ANDealerHomeModel *model = [ANDealerHomeModel mj_objectWithKeyValues:data[@"response"]];
    self.model = model;
}

- (void)setModel:(ANDealerHomeModel *)model
{
    if (_model != model) {
        _model = model;
    }
    
    self.totalSaleLabel.text = [NSString stringWithFormat:@"%.2f",[_model.sale_money_all floatValue]];
    self.totalSalesVolumeLabel.text = _model.sale_num_all;
    self.totalIntegerLabel.text = _model.score;
    
    [self.leftButton setTitle:model.name forState:UIControlStateNormal];
    self.leftButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.leftButton setImage:[UIImage imageNamed:@"nav_headImge"] forState:UIControlStateNormal];
    
    self.numOfMonthLabel.text = [NSString stringWithFormat:@"%@/%@", _model.sale_money_month, _model.sale_num_month];
    self.numOfStockLabel.text = [NSString stringWithFormat:@"%@/%@", _model.store_goods_category_num, _model.stock_num];
    self.numOfTodayLabel.text = [NSString stringWithFormat:@"%@/%@", _model.sale_money_today, _model.sale_num_today];
    self.numOfYesterdayLabel.text = [NSString stringWithFormat:@"%@/%@", _model.sale_money_yesterday, _model.sale_num_yesterday];
    self.areaNumLabel.text = _model.store_num;
    self.peopleNumLabel.text = _model.marketing_num;
    self.sendNumLabel.text = [NSString stringWithFormat:@"%@/%@",model.unassigned_num,_model.no_deliver_num];
    // 我要进货 all_store_goods_category_num
    self.stockNumLabel.text = [NSString stringWithFormat:@"%@/%@",_model.store_goods_category_num,_model.all_store_goods_category_num];
    self.awardNumLabel.text = _model.score;
    self.todolistNumLabel.text = _model.todo_num;
    if ([model.unread_msg_num isEqualToString:@"0"]) {
        self.numRedLabel.hidden = YES;
    }else {
        self.numRedLabel.text = model.unread_msg_num;
        self.numRedLabel.hidden = NO;
    }
#pragma mark 经销商ID
    [[NSUserDefaults standardUserDefaults] setObject:model.user_id forKey:@"user_id"];
#pragma mark 仓库地址
    [[NSUserDefaults standardUserDefaults] setObject:model.store_house forKey:@"store_house"];
    [[NSUserDefaults standardUserDefaults] setObject:model.dealer_name forKey:@"dealer_name"];
    [[NSUserDefaults standardUserDefaults] setObject:model.dealer_mobile forKey:@"dealer_mobile"];
    [[NSUserDefaults standardUserDefaults] setObject:model.dealer_address_id forKey:@"dealer_address_id"];
#pragma mark 抱抱币
    [[NSUserDefaults standardUserDefaults] setObject:model.bbcoin forKey:@"bbcoin"];
    [[NSUserDefaults standardUserDefaults] setObject:model.is_bbcoin_enable forKey:@"baobaobiEnable"];
}


@end

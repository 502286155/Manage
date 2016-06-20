//
//  ANMarketHomepageViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/16.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANMarketHomepageViewController.h"
#import "ANMessageViewController.h"             //消息中心
#import "ANDistributionViewController.h"        //配送中心
#import "ANMarkingMineCenterVC.h"          //个人中心
#import "ANCameraInfoViewController.h"          //拍照信息
#import "ANCustomerManageViewController.h"      //客户管理
#import "ANHttpTool.h"
#import "ANMarkHomeModel.h"
#import "ANEmptyViewController.h"
#import "UpdateVersion.h"
#import "JPUSHService.h"

@interface ANMarketHomepageViewController ()
#pragma mark ----导航条视图
// 导航父视图
@property (weak, nonatomic) IBOutlet UIView *navView;
// 消息按钮
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
#pragma mark ----头部紫色视图
// 头部父视图
@property (weak, nonatomic) IBOutlet UIView *headView;
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
// 姓名Label
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
// 部门Label
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
// 工号Label
@property (weak, nonatomic) IBOutlet UILabel *jobNumLabel;
// 地点Label
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
#pragma mark ----上部红色视图
@property (weak, nonatomic) IBOutlet UIView *topView;
// 客户Label
@property (weak, nonatomic) IBOutlet UILabel *customersLabel;
// 消息Label
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
// 待办Label
@property (weak, nonatomic) IBOutlet UILabel *gtasksLabel;
#pragma mark ----中部红色视图
@property (weak, nonatomic) IBOutlet UIView *middleView;
// 客户管理按钮
@property (weak, nonatomic) IBOutlet UIButton *customersBtn;
// 任务待办按钮
@property (weak, nonatomic) IBOutlet UIButton *gtasksBtn;
// 拍照信息按钮
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
#pragma marl ----底部紫色视图
// 底部紫色父视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;
// 本月销售额Label(大)
@property (weak, nonatomic) IBOutlet UILabel *salesMonthBigLabel;
// 本月任务Label(大)
@property (weak, nonatomic) IBOutlet UILabel *taskMonthBigLabel;
// 本月销售额Label(小)
@property (weak, nonatomic) IBOutlet UILabel *salesMonthSmallLabel;
// 本月任务Label(小)
@property (weak, nonatomic) IBOutlet UILabel *taskMonthSmallLabel;
// 白色进度条
@property (weak, nonatomic) IBOutlet UIView *whiteProgressView;
// 红色进度条
@property (weak, nonatomic) IBOutlet UIImageView *redProgressImg;
// 个人中心按钮
@property (weak, nonatomic) IBOutlet UIButton *mineCenterBtn;

@property (nonatomic, strong) ANMarkHomeModel *model;
/**
 *  提示版本更新类
 */
@property (nonatomic, strong) UpdateVersion *updateV;

@end

@implementation ANMarketHomepageViewController

#pragma mark ----生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self requestHomeData];
    [MobClick beginLogPageView:@"市场人员首页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"市场人员首页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setSubView];
    
    // 提示版本更新
    UpdateVersion *UpdateV = [[UpdateVersion alloc] init];
    self.updateV = UpdateV;
    [UpdateV checkUpdateVersionWith:@"market"];
    
    
    [self requestHomeData];
}


#pragma mark ----自定义方法
- (void)setSubView
{
    self.whiteProgressView.layer.cornerRadius = 5;
    self.whiteProgressView.layer.masksToBounds = YES;
}


#pragma mark ---- 导航栏点击事件
- (IBAction)clickMessageBtn:(id)sender {
    ANLog(@"消息");
    ANMessageViewController *messageVC = [[ANMessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}


#pragma mark ---- 头部的点击事件
- (IBAction)clickMineBtn:(id)sender {
    ANLog(@"点击了我的");
}



#pragma mark ---- 头部红色视图点击事件
- (IBAction)clickCustomersBtn:(id)sender {
    ANLog(@"点击了客户");
}
- (IBAction)clickCustomersMessageBtn:(id)sender {
    ANLog(@"点击了消息");
}
- (IBAction)clickAbeyanceBtn:(id)sender {
    ANLog(@"点击了待办");
}


#pragma mark ---- 中间视图点击事件
- (IBAction)clickCustomersManageBtn:(id)sender {
    ANLog(@"点击了客户管理");
    ANCustomerManageViewController *customerManage = [[ANCustomerManageViewController alloc] init];
    [self.navigationController pushViewController:customerManage animated:YES];
}
- (IBAction)clickGtasksBtn:(id)sender {
    ANLog(@"点击了任务待办");
    ANDistributionViewController *distributionVC = [[ANDistributionViewController alloc] init];
    [self.navigationController pushViewController:distributionVC animated:YES];}
- (IBAction)clickCameraBtn:(id)sender {
    ANLog(@"点击了拍照信息");
    
    /***
    ANCameraInfoViewController *cameraInfoVC = [[ANCameraInfoViewController alloc] init];
    [self.navigationController pushViewController:cameraInfoVC animated:YES];
     */
    
    ANEmptyViewController *empty = [[ANEmptyViewController alloc] init];
    empty.title = @"拍照任务";
    [self.navigationController pushViewController:empty animated:YES];
    
    
}
- (IBAction)clickMineCenterBtn:(id)sender {
    ANLog(@"个人中心");
    ANMarkingMineCenterVC *mineVC = [[ANMarkingMineCenterVC alloc] init];
    mineVC.isMarkPeople = YES;
    [self.navigationController pushViewController:mineVC animated:YES];
}

#pragma mark ---- 网络请求
- (void)requestHomeData
{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    //    [parmDic setObject:@"101010" forKey:@"token"];
    //    [[NSUserDefaults standardUserDefaults] setObject:@"101010" forKey:@"token"];
    parmDic = (NSMutableDictionary *)[ANCommon dicToSign:parmDic];
    NSString *registrationID = [JPUSHService registrationID];
    if (registrationID) {
        if ([registrationID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]]) {
            [parmDic setValue:registrationID forKey:@"device_id"];
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
            [parmDic setValue:registrationID forKey:@"device_id"];
        }
    }else {
        [parmDic setValue:registrationID forKey:@"device_id"];
    }
    
    [ANHttpTool postWithUrl:@"/api/1/user/marketing_index" params:parmDic successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
                [self parseOrderDtail:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject[@"message"]);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)parseOrderDtail:(id)data
{
    ANLog(@"data: %@", data);
    ANMarkHomeModel *model = [ANMarkHomeModel mj_objectWithKeyValues:data[@"response"]];
    
    self.model = model;
}

- (void)setModel:(ANMarkHomeModel *)model
{
    if (_model != model) {
        _model = model;
    }
    ANLog(@"%@", _model.name);
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString: _model.avatar] placeholderImage:[UIImage imageNamed:@"mark_home_Img"]];
    self.nameLabel.text = _model.name;
//    self.departmentLabel.text = _model.department;
    self.jobNumLabel.text = _model.user_id;
    self.addLabel.text = _model.area;
    self.customersLabel.text = [NSString stringWithFormat:@"客户   %@", _model.customer_num];
    self.messageLabel.text = [NSString stringWithFormat:@"待办   %@", _model.todo_num];
//    self.gtasksLabel.text = [NSString stringWithFormat:@"%@", _model.]
    self.salesMonthBigLabel.text = [NSString stringWithFormat:@"￥ %@", _model.sale_money];
    self.taskMonthBigLabel.text = [NSString stringWithFormat:@"￥ %@", _model.sale_target];
    self.salesMonthSmallLabel.text = [NSString stringWithFormat:@"￥ %@", _model.sale_money];
    self.taskMonthSmallLabel.text = [NSString stringWithFormat:@"￥ %@", _model.sale_target];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:model.user_id forKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] setObject:_model.dealer_mobile forKey:@"dealer_mobile"];
    
}


@end

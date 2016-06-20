//
//  ANMessageViewController.m
//  baobaotang
//
//  Created by 高赛 on 15/11/22.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANMessageViewController.h"
#import "ANMessageListViewController.h"
#import "ANHttpTool.h"
#import "ANMessageModel.h"
#import "MBProgressHUD.h"
#import "ANActivityMessageViewController.h"

@interface ANMessageViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;

// 到货
@property (weak, nonatomic) IBOutlet UILabel *arrivalLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *arrivalView;

// 核销
@property (weak, nonatomic) IBOutlet UILabel *chargeOffLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeOffContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeOffTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *chargeOffView;

// 积分
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *integralView;

// 活动
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *eventView;

// 公告
@property (weak, nonatomic) IBOutlet UILabel *announcementLabel;
@property (weak, nonatomic) IBOutlet UILabel *announcementContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *announcementTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *announcementView;



@end

@implementation ANMessageViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"消息页面"];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"消息页面"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 设置navgation
    [self setNavgation];
    [self requestData];
}
#pragma mark ----自定义方法
/**
 *  设置navgation
 */
- (void)setNavgation
{
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置标题
    self.navigationItem.title = @"消息中心";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
}
/**
 *  返回的点击事件
 */
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setSubView
{
    for (ANMessageModel *model in self.dataArr) {
        NSArray *strArr = [model.add_time componentsSeparatedByString:@" "];
        if ([model.res_name isEqualToString:@"arrival"]) {
            self.arrivalLabel.text = model.res_ch_name;
            self.arrivalContentLabel.text = model.content;
            self.arrivalTimeLabel.text = strArr[0];
            self.arrivalView.tag = [self.dataArr indexOfObject:model] + 2000;
        }else if ([model.res_name isEqualToString:@"group"]) {
            self.chargeOffLabel.text = model.res_ch_name;
            self.chargeOffContentLabel.text = model.content;
            self.chargeOffTimeLabel.text = strArr[0];
            self.chargeOffView.tag = [self.dataArr indexOfObject:model] + 2000;
        }else if ([model.res_name isEqualToString:@"score"]) {
            self.integralLabel.text = model.res_ch_name;
            self.integralContentLabel.text = model.content;
            self.integralTimeLabel.text = strArr[0];
            self.integralView.tag = [self.dataArr indexOfObject:model] + 2000;
        }else if ([model.res_name isEqualToString:@"event"]) {
            self.eventLabel.text = model.res_ch_name;
            self.eventContentLabel.text = model.content;
            self.eventTimeLabel.text = strArr[0];
            self.eventView.tag = [self.dataArr indexOfObject:model] + 2000;
        }else if ([model.res_name isEqualToString:@"notice"]) {
            self.announcementLabel.text = model.res_ch_name;
            self.announcementContentLabel.text = model.content;
            self.announcementTimeLabel.text = strArr[0];
            self.announcementView.tag = [self.dataArr indexOfObject:model] + 2000;
        }
    }
}
#pragma mark ----点击方法
- (IBAction)clickGestureRecognizer:(UITapGestureRecognizer *)sender {
    ANLog(@"%ld",sender.view.tag);
    if (self.dataArr.count == 0) {
        
    }else {
        ANMessageModel *messageModel = self.dataArr[sender.view.tag - 2000];
        if ([messageModel.res_name isEqualToString:@"event"]) {
            ANActivityMessageViewController *activity = [[ANActivityMessageViewController alloc] init];
            activity.res_name = @"event";
            [self.navigationController pushViewController:activity animated:YES];
            return;
        }
        
        ANMessageListViewController *messageListVC = [[ANMessageListViewController alloc] init];
        messageListVC.model = self.dataArr[sender.view.tag - 2000];
        
        [self.navigationController pushViewController:messageListVC animated:YES];
        
    }
}

#pragma mark ----网络请求
- (void)requestData
{
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
    hud.labelText= netStr
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    });
    
    NSDictionary *parmDict = [NSDictionary dictionary];
    parmDict = [ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/message_center/get_message_center_list" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [self parseTaskLoadData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)parseTaskLoadData:(NSDictionary *)json
{
    self.dataArr = [NSMutableArray array];
    NSDictionary *tempDict = json[@"response"];
    NSArray *keys = [tempDict allKeys];
    for (NSString *key in keys) {
        [self.dataArr addObject:[ANMessageModel mj_objectWithKeyValues:tempDict[key]]];
    }
    [self setSubView];
}


@end

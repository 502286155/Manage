//
//  ANPaySuccessViewController.m
//  baobaotang
//
//  Created by Eric on 15/11/6.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANPaySuccessViewController.h"
#import "ANPurchaseRecordsViewController.h"
#import "ANHttpTool.h"
#import "ANPurchaseDetailModel.h"
#import "MBProgressHUD.h"
#import "ANHomePageViewController.h"
#import "ANPurchasesViewController.h"
#import "ANFirstGuideViewController.h"

@interface ANPaySuccessViewController ()<UIAlertViewDelegate>

// 查看订单
@property (weak, nonatomic) IBOutlet UIButton *seeOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
/**
 *  标志是否确认取消按钮    yes为确认收货,no为取消订单
 */
@property (nonatomic, assign)  BOOL isCancelOrSure;
@property (nonatomic, strong) ANPurchaseDetailModel *detailModel;
/**
 *  提示框
 */
@property (nonatomic, strong) UIAlertView *alertView;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation ANPaySuccessViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [MobClick endLogPageView:@"经销商进货成功页"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"经销商进货成功页"];//("PageOne"为页面名称，可自定义)
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.isHomeVC) {
        self.topLabel.text = @"您有尚未到货订单";
        self.bottomLabel.text = @"您可以继续下单或查看订单到货状态";
        self.cancelBtn.hidden = NO;
    }else {
        // 网络请求
        [self requestData];
        self.cancelBtn.hidden = YES;
    }
    
    // 设置navgation
    [self setNavgation];
    self.cancelBtn.layer.cornerRadius = 5;
    self.cancelBtn.layer.borderColor = [UIColor colorWithRed:0.2118 green:0.1216 blue:0.3059 alpha:1.0].CGColor;
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.masksToBounds = YES;
    
}

/**
 *  设置navgation
 */
- (void)setNavgation
{
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnHomeOrFirstClick)];
    // 设置标题
    self.navigationItem.title = @"进货中心";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    // 设置右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_call_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(clickPhone)];
}

/**
 *  返回的点击事件
 */
- (void)returnHomeOrFirstClick
{
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[ANHomePageViewController class]]) {
            
//            [ANNotificationCenter postNotificationName:@"requestData" object:nil userInfo:nil];
            [self.navigationController popToViewController:vc animated:YES];
        } else if ([vc isKindOfClass:[ANFirstGuideViewController class]]) {
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
- (void)clickPhone
{
    ANLog(@"打电话");
    [ANCommon setAlertViewWithTitle:@"请联系区域销售助理" andMessage:@"或拨打 4008650003" andVC:self];
}

/**
 *  打电话
 */
- (void)callTel
{
    NSString *allString = @"tel:4008650003";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
    //    self.webView = [[UIWebView alloc] init];
    //    NSString *telStr = [NSString stringWithFormat:@"tel://%@", Tel];
    //    NSURL *url = [NSURL URLWithString:telStr];
    //
    //    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
    //    [self.webView loadRequest:requestUrl];
}
- (IBAction)clickSeeOrderBtn:(id)sender
{
    ANLog(@"查看订单");
    ANPurchaseRecordsViewController *purchaserVC = [[ANPurchaseRecordsViewController alloc] init];
    purchaserVC.isPaySuccessPush = YES;
    purchaserVC.store_id = self.store_id;
    [self.navigationController pushViewController:purchaserVC animated:YES];
}
- (IBAction)clickCancelBtn:(id)sender
{
    NSString *storeID = [[NSUserDefaults standardUserDefaults] objectForKey:@"agencyStoreId"];
    if (storeID.length != 0) {
        ANPurchasesViewController *stockVC = [[ANPurchasesViewController alloc] init];
        stockVC.storeID = storeID;
        [self.navigationController pushViewController:stockVC animated:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
    if (alertView.tag == 10001 || alertView.tag == 10002) {
        
        if (buttonIndex == 0) {      // 订单的
            [self cancleOrSureOrder];
        }
    } else {           // 拨打电话
        if (buttonIndex == 0) {
            ANLog(@"拨打");
            [self callTel];
        }
    }
}
#pragma mark ---- 网络请求
- (void)requestData
{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"agencyStoreId"] forKey:@"store_id"];
    [parmDict setObject:self.order_id forKey:@"order_id"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/order/get_order_detail" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseTaskLoadData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)parseTaskLoadData:(id)data
{
    self.detailModel = [ANPurchaseDetailModel mj_objectWithKeyValues:data[@"response"]];
    ANLog(@"%@",self.detailModel);
    if ([self.detailModel.progress integerValue] == 1) {
        self.isCancelOrSure = NO;
        self.alertView = [[UIAlertView alloc] initWithTitle:@"撤销订单" message:@"因误操作或进货需求改变取消本订单" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        self.alertView.tag = 10001;
        self.cancelBtn.hidden = YES;
    }else if ([self.detailModel.progress integerValue] == 5) {
        self.isCancelOrSure = YES;
        self.alertView = [[UIAlertView alloc] initWithTitle:@"确认收货" message:@"货物无误并结束订单" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        self.alertView.tag = 10002;
        [self.cancelBtn setBackgroundColor:[UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0]];
        [self.cancelBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
// 确认或取消订单
- (void)cancleOrSureOrder
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
    hud.labelText= netStr
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    });
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"agencyStoreId"] forKey:@"store_id"];
    [parmDict setObject:self.order_id forKey:@"order_id"];
    if (self.isCancelOrSure) {
        [parmDict setObject:@"10" forKey:@"progress"];
    }else {
        [parmDict setObject:@"15" forKey:@"progress"];
    }
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/order/update_order_progress" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"成功%@",responseObject);
        [self parseData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)parseData:(id)data
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    if ([data[@"message"] isEqualToString:@"success"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end

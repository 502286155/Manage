//
//  ANMineCenterViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/24.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANMineCenterViewController.h"
#import "ANNavigationController.h"
#import "ANLoginViewController.h"
#import "ANHttpTool.h"
#import "ANMineCenterModel.h"
#import "ANPurchaseRecordsViewController.h"
#import "ANInventoryCheckViewController.h"
#import "ANHelpHFiveViewController.h"
#import "ANAboutBoboTViewController.h"
#import "ANChangeMineDetailVC.h"
#import "ANSendAddressViewController.h"

@interface ANMineCenterViewController ()<ANSendAddressViewControllerDelegate>

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
/**
 *  姓名Label
 */
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIImageView *namePushIm;
@property (weak, nonatomic) IBOutlet UILabel *dealerNameLabel;

/**
 *  抱抱币
 */
@property (weak, nonatomic) IBOutlet UILabel *bbCoinLable;


/**
 *  手机号Label
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/**
 *  qq
 */
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIImageView *qqPushImg;
@property (weak, nonatomic) IBOutlet UILabel *dealerQQLabel;


@property (weak, nonatomic) IBOutlet UILabel *dealerBankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bankPushImg;
@property (weak, nonatomic) IBOutlet UIButton *bankBtn;


/**
 *  微信/仓库
 */
@property (weak, nonatomic) IBOutlet UILabel *weCharORWarehouse;

/**
 *  职位名称
 */
@property (weak, nonatomic) IBOutlet UILabel *positionName;
/**
 *  仓库Label
 */
@property (weak, nonatomic) IBOutlet UILabel *houseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *housePushImg;
@property (weak, nonatomic) IBOutlet UIButton *houseBtn;


/**
 *  个人中心model
 */
@property (nonatomic, strong) ANMineCenterModel *mineModel;
/**
 *  qqTitleLabel
 */
@property (weak, nonatomic) IBOutlet UILabel *qqTitleLabel;

/**
 *  进货记录
 */
@property (weak, nonatomic) IBOutlet UIView *purchasesRecordView;
/**
 *  库存盘点
 */
@property (weak, nonatomic) IBOutlet UIView *inventoryCheckView;
/**
 *  帮助中心
 */
@property (weak, nonatomic) IBOutlet UIView *helpCenterView;
/**
 *  关于抱抱堂
 */
@property (weak, nonatomic) IBOutlet UIView *aboutMineView;
/**
 *  版本号Label
 */
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (nonatomic, strong) NSMutableArray *addressArray;

@property (nonatomic, assign) BOOL isFrist;
/**
 *  盘点Label
 */
@property (weak, nonatomic) IBOutlet UILabel *inventoryLabel;

@end

@implementation ANMineCenterViewController

#pragma mark ----声明周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"个人中心页"];//("PageOne"为页面名称，可自定义)
    if (self.isFrist) {
        [self requestData];
    }else {
        self.isFrist = YES;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人中心页"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavgation];
    
    self.headImg.layer.cornerRadius = 36;
    self.headImg.layer.masksToBounds = YES;
    self.versionLabel.text = [NSString stringWithFormat:@"%@版本",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    self.bbCoinLable.text = [NSString stringWithFormat:@"现有%@个抱抱币", [[NSUserDefaults standardUserDefaults] objectForKey:@"bbcoin"]];
    
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
    self.navigationItem.title = @"个人中心";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
// 返回的点击事件
- (void)returnClick
{
    if (self.isMarkPeople) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
//        // 创建动画
//        CATransition* transition = [CATransition animation];
//        // 修改动画的方式
//        transition.type = kCATransitionPush;//可更改为其他方式
//        // 设置动画的方向
//        transition.subtype = kCATransitionFromRight;//可更改为其他方式
//        // 修改nav
//        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

/**
 *  退出登录
 */
- (IBAction)exitRegisterAction:(id)sender {
    
    ANLoginViewController *login = [[ANLoginViewController alloc] init];
    ANNavigationController *loginNav = [[ANNavigationController alloc] initWithRootViewController:login];
    [self presentViewController:loginNav animated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"reloID"];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];

}

#pragma mark 修改信息
- (IBAction)clickNameBtn:(id)sender {
    ANChangeMineDetailVC *changeVC = [[ANChangeMineDetailVC alloc] init];
    changeVC.nameStr = @"姓名";
    changeVC.nameValue = self.mineModel.realname;
    changeVC.model = self.mineModel;
    [self.navigationController pushViewController:changeVC animated:YES];
}
- (IBAction)clickBankBtn:(id)sender {
    ANChangeMineDetailVC *changeVC = [[ANChangeMineDetailVC alloc] init];
    changeVC.nameStr = @"银行";
    changeVC.nameValue = [NSString stringWithFormat:@"%@ %@",self.mineModel.bank_code, self.mineModel.bank_name];
    changeVC.model = self.mineModel;
    [self.navigationController pushViewController:changeVC animated:YES];
}
- (IBAction)clickWCHBtn:(id)sender {
    ANChangeMineDetailVC *changeVC = [[ANChangeMineDetailVC alloc] init];
    changeVC.nameStr = @"微信";
    changeVC.nameValue = self.mineModel.weixin;
    changeVC.model = self.mineModel;
    [self.navigationController pushViewController:changeVC animated:YES];
}
- (IBAction)clickHouseBtn:(id)sender {
    ANSendAddressViewController *sendAddressVC = [[ANSendAddressViewController alloc] init];
    sendAddressVC.isHaveData = NO;
    sendAddressVC.delegate = self;
    sendAddressVC.isMineVC = YES;
    [self.navigationController pushViewController:sendAddressVC animated:YES];
}
#pragma mark ANSendAddressViewControllerDelegate
- (void)sendAddressViewController:(ANSendAddressViewController *)sendAddressViewController andDataArr:(NSMutableArray *)dataArr andAddressModel:(ANSendAddressModel *)addressModel
{
    ANLog(@"%@",addressModel);
    [[NSUserDefaults standardUserDefaults] setObject:addressModel.dealer_address forKey:@"dealer_address"];
    [[NSUserDefaults standardUserDefaults] setObject:addressModel.ID forKey:@"dealer_address_id"];
    [[NSUserDefaults standardUserDefaults] setObject:addressModel.dealer_name forKey:@"dealer_name"];
    [[NSUserDefaults standardUserDefaults] setObject:addressModel.dealer_mobile forKey:@"dealer_mobile"];
    self.addressArray = dataArr;
    self.houseLabel.text = addressModel.dealer_address;
}


#pragma mark ---- 网络请求
- (void)requestData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/user/get_user_info" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        self.mineModel = [ANMineCenterModel mj_objectWithKeyValues:responseObject[@"response"]];    
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)setMineModel:(ANMineCenterModel *)mineModel
{
    if (_mineModel != mineModel) {
        _mineModel = mineModel;
    }
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:mineModel.avatar] placeholderImage:[UIImage imageNamed:@"mine_centerImg"]];
    if (![mineModel.realname isEqualToString:@""]) {
        self.dealerNameLabel.text = mineModel.realname;
    }
    if (![mineModel.role_name isEqualToString:@""]) {
        self.positionName.text = mineModel.role_name;
    }
    if (![mineModel.mobile isEqualToString:@""]) {
        self.phoneLabel.text = mineModel.mobile;
    }
    if ([mineModel.is_last_7day_init_stock isEqualToString:@"1"]) {
        self.inventoryLabel.hidden = NO;
    }
    
    if (![mineModel.weixin isEqualToString:@""]) {
        self.dealerQQLabel.text = mineModel.weixin;
    }
    if (![mineModel.bank_code isEqualToString:@""]) {
        self.dealerBankLabel.text = [NSString stringWithFormat:@"%@ %@",mineModel.bank_code, mineModel.bank_name];
    }
}

/**
 *  进货记录
 */
- (IBAction)purchasesRecordButtonAction:(id)sender {
    ANLog(@"进货记录");
    ANPurchaseRecordsViewController *purchRecords = [[ANPurchaseRecordsViewController alloc] init];
    purchRecords.store_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"agencyStoreId"];
    [self.navigationController pushViewController:purchRecords animated:YES];
}

/**
 *  库存盘点
 */
- (IBAction)inventoryCheckButtonAction:(id)sender {
    ANLog(@"库存盘点");
    ANInventoryCheckViewController *inventoryCheck = [[ANInventoryCheckViewController alloc] init];
    inventoryCheck.store_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"agencyStoreId"];
    [self.navigationController pushViewController:inventoryCheck animated:YES];
}

/**
 *  帮助中心
 */
- (IBAction)helpCenterButtonAction:(id)sender {
    ANLog(@"帮助中心");
    ANHelpHFiveViewController *helpH = [[ANHelpHFiveViewController alloc] init];
    [self.navigationController pushViewController:helpH animated:YES];
}

/**
 *  关于抱抱堂
 */
- (IBAction)aboutMineButtonAction:(id)sender {
    ANLog(@"关于抱抱堂");
    
    ANAboutBoboTViewController *about = [[ANAboutBoboTViewController alloc] init];
    [self.navigationController pushViewController:about animated:YES];
    
}




@end

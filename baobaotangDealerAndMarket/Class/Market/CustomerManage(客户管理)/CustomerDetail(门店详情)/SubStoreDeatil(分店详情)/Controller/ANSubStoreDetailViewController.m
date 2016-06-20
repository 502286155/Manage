//
//  ANSubStoreDetailViewController.m
//  baobaotangDealerAndMarket
//
//  Created by Eric on 15/12/14.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANSubStoreDetailViewController.h"
#import "ANHttpTool.h"
#import "ANSubStoreModel.h"
#import "ANSingleType.h"
#import "ANStoreTypeModel.h"
#import "ANCancelStoreViewController.h"
#import "ANAreaListViewController.h"
#import "ANCustomerManageViewController.h"
#import "ANChangeSubStoreVC.h"
#import "ANStoreDeviceCell.h"
#import "ANPeopleDetailViewController.h"
#import "ANRemoveDeviceViewController.h"
#import "ANLocationMapVC.h"

@interface ANSubStoreDetailViewController ()<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, ANStoreDeviceCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  分店门头图
 */
@property (weak, nonatomic) IBOutlet UIImageView *subStoreImage;

/**
 *  分店名
 */
@property (weak, nonatomic) IBOutlet UITextField *storeName;

/**
 *  分店后缀名
 */
@property (weak, nonatomic) IBOutlet UITextField *storeSuffixName;

/**
 *  电话
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

/**
 *  分店类型
 */
@property (weak, nonatomic) IBOutlet UITextField *storeType;
/**
 *  类型model
 */
@property (nonatomic, strong) ANStoreTypeModel *typeModel;

/**
 *  分店的地址
 */
@property (weak, nonatomic) IBOutlet UITextField *storeAddress;

@property (nonatomic, strong) ANSubStoreModel *subStoreModel;
/**
 *  姓名框
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  打电话按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *telBtn;
/**
 *  打电话webView
 */
@property (nonatomic, strong) UIWebView *webView;
/**
 *  是否第一次进来
 */
@property (nonatomic, assign) BOOL isFirst;
/**
 *  数据数组
 */
@property (nonatomic, strong) NSMutableArray *dataArr;
/**
 *  签约人
 */
@property (weak, nonatomic) IBOutlet UILabel *signedPeopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *signedPeopleBtn;

@end

@implementation ANSubStoreDetailViewController

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
    
    if (self.isFirst) {
        [self requestData];
    }else {
        self.isFirst = YES;
    }
    
    
    [MobClick beginLogPageView:@"门店分店详情页"];//("PageOne"为页面名称，可自定义)
}
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
    [MobClick endLogPageView:@"门店分店详情页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavgation];
    [ANNotificationCenter addObserver:self selector:@selector(cancleOrder) name:@"cancle" object:nil];
//    self.subStoreImage.image = [UIImage imageNamed:@"testSubStore"];
//    self.storeName.text = @"万达广场";
//    self.storeSuffixName.text = @"三里屯店";
//    self.phoneTextField.text = @"18077338031";
//    self.storeType.text = @"电影院";
//    self.storeAddress.text = @"北京市朝阳区奥运村街道北苑路13号领地";
    
    [self requestData];
    
}

// 设置nav
- (void)setNavgation
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"门店详情";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 30);
    [rightBtn setTitle:@"修改" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}
// 返回的点击事件
- (void)returnClick
{  
    if (self.isDealer && self.isCancle) {
        for (UIViewController *viewC in self.navigationController.viewControllers) {
            if ([viewC isKindOfClass:[ANAreaListViewController class]]) {
                [self.navigationController popToViewController:viewC animated:YES];
                return;
            }
        }
        for (UIViewController *viewC in self.navigationController.viewControllers) {
            if ([viewC isKindOfClass:[ANCustomerManageViewController class]]) {
                [self.navigationController popToViewController:viewC animated:YES];
                return;
            }
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)clickRightBtn:(UIButton *)btn
{
    ANChangeSubStoreVC *changeSubStoreVC = [[ANChangeSubStoreVC alloc] init];
    changeSubStoreVC.storeID = self.storeID;
    [self.navigationController pushViewController:changeSubStoreVC animated:YES];
}
/**
 *  跳转签约人界面
 */
- (IBAction)clickSignedPeopleBtn:(id)sender {
    NSString *typeID = [[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if ([typeID isEqualToString:@"5"]) {
        if ([self.subStoreModel.sign_user_id isEqualToString:userID]) {
            
        }else {
            ANPeopleDetailViewController *peopleDetailVC = [[ANPeopleDetailViewController alloc] init];
            peopleDetailVC.marketing_id = self.subStoreModel.sign_user_id;
            [self.navigationController pushViewController:peopleDetailVC animated:YES];
        }
    }
}
/**
 *  点击了位置按钮
 */
- (IBAction)clickLocationBtn:(id)sender {
    ANLocationMapVC *mapVC = [[ANLocationMapVC alloc] init];
    mapVC.subStoreModel = self.subStoreModel;
    [self.navigationController pushViewController:mapVC animated:YES];
}


- (void)cancleOrder
{
    self.isCancle = YES;
}

- (IBAction)clickTelBtn:(id)sender {
    [self callTel:self.phoneTextField.text];
}
/**
 *  打电话
 */
- (void)callTel:(NSString *)phone
{
    self.webView = [[UIWebView alloc] init];
    NSString *telStr = [NSString stringWithFormat:@"tel://%@", phone];
    NSURL *url = [NSURL URLWithString:telStr];
    
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestUrl];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANStoreDeviceCell *cell = [ANStoreDeviceCell deviceTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    view.backgroundColor = [UIColor colorWithRed:0.9569 green:0.9569 blue:0.9569 alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.subStoreImage.frame), 10, 100, 20)];
    label.text = [NSString stringWithFormat:@"已绑定设备数:%lu",(unsigned long)self.dataArr.count];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (void)deviceCell:(ANStoreDeviceCell *)cell clickUnwarpBtn:(UIButton *)btn
{
    ANRemoveDeviceViewController *removeDeviceVC = [[ANRemoveDeviceViewController alloc] init];
    removeDeviceVC.storeID = self.storeID;
    removeDeviceVC.deviceNo = cell.model.device_no;
    [self presentViewController:removeDeviceVC animated:YES completion:nil];
}
#pragma mark ----网络请求
- (void)requestData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    [parmDict setObject:self.storeID forKey:@"store_id"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    
    [ANHttpTool postWithUrl:@"/api/1/store/get_store" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseSubStoreData:responseObject];
        
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
        [[ANCommon alloc] setAlertView:responseObject[@"message"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)parseSubStoreData:(id)data
{
    ANLog(@"%@",data);
    self.subStoreModel = [ANSubStoreModel mj_objectWithKeyValues:data[@"response"]];
    NSArray *deviceArr = data[@"response"][@"device_list"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSArray *arr in deviceArr) {
        for (NSDictionary *dict in arr) {
            ANDeviceModel *model = [ANDeviceModel mj_objectWithKeyValues:dict];
            [array addObject:model];
        }
    }
    self.dataArr = array;
    [self.tableView reloadData];
}
- (void)setSubStoreModel:(ANSubStoreModel *)subStoreModel
{
    if (_subStoreModel != subStoreModel) {
        _subStoreModel = subStoreModel;
    }
    
    [self.subStoreImage sd_setImageWithURL:[NSURL URLWithString:subStoreModel.cover]];
    self.storeName.text = subStoreModel.title;
    self.storeSuffixName.text = subStoreModel.title_branch;
    self.phoneTextField.text = subStoreModel.mobile;
    self.storeAddress.text = subStoreModel.address;
    self.nameLabel.text = subStoreModel.name;
    
    NSString *typeID = [[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if ([typeID isEqualToString:@"5"]) {
        if ([self.subStoreModel.sign_user_id isEqualToString:userID]) {
            self.signedPeopleLabel.text = [NSString stringWithFormat:@"签约人:%@",subStoreModel.sign_user_name];
        }else {
            self.signedPeopleLabel.text = [NSString stringWithFormat:@"签约人:%@>>",subStoreModel.sign_user_name];
        }
    }else {
        self.signedPeopleLabel.text = [NSString stringWithFormat:@"签约人:%@",subStoreModel.sign_user_name];
    }
    
    ANSingleType *singleType = [ANSingleType sharetype];
    if (singleType.dataArr == nil) {                // 无,请求类型数据
        [singleType requestData];
        [singleType typeBlock:^(NSArray *typeArr) {
            self.typeModel = [singleType storeTypeModelWithTypeID:self.typeID];
            self.storeType.text = self.typeModel.typeName;
        }];
    }else {                                         // 有,直接根据id获取类型model
        self.typeModel = [singleType storeTypeModelWithTypeID:self.typeID];
        self.storeType.text = self.typeModel.typeName;
    }
    if ([subStoreModel.status isEqualToString:@"3"]) {
        [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:0.2118 green:0.1333 blue:0.298 alpha:1.0]];
        [self.bottomBtn setTitle:@"恢复门店" forState:UIControlStateNormal];
    }else {
        [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:0.7529 green:0.0 blue:0.0 alpha:1.0]];
        [self.bottomBtn setTitle:@"停业撤店" forState:UIControlStateNormal];
    }
}

/**
 *  撤销按钮的点击事件
 */
- (IBAction)backoutStoreAction:(id)sender {
    ANLog(@"撤销门店");
    if ([self.subStoreModel.status isEqualToString:@"3"]) {
        UIAlertView *backoutAlert = [[UIAlertView alloc] initWithTitle:@"恢复门店" message:@"确认恢复门店并开通掌柜账号" delegate:self cancelButtonTitle:@"立即恢复" otherButtonTitles:@"点错了", nil];
        [backoutAlert show];
    }else {
        ANCancelStoreViewController *cancelStoreVC = [[ANCancelStoreViewController alloc] init];
        cancelStoreVC.owner_id = self.owner_id;
        cancelStoreVC.storeID = self.storeID;
        
        [self presentViewController:cancelStoreVC animated:YES completion:nil];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ANLog(@"%ld", buttonIndex);
    if (buttonIndex == 0) {
        NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
        [parmDict setObject:self.storeID forKey:@"store_id"];
        parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
        [ANHttpTool postWithUrl:@"/api/1/store/recover_store" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
            ANLog(@"%@",responseObject);
            [self requestData];
            self.isCancle = YES;
        } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
            ANLog(@"error:%@",responseObject);
        } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
            ANLog(@"fail:%@",error);
        }];
    }
}
- (void)dealloc
{
    [ANNotificationCenter removeObserver:self name:@"cancle" object:nil];
}


@end

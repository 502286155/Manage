//
//  ANAreaDetailViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/19.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANAreaDetailViewController.h"
#import "ANSubStoreListCell.h"
#import "ANSubStoreDetailViewController.h"
#import "ANHttpTool.h"
#import "ANCustomSuperDetailModel.h"
#import "ANSubPriceAdjustmentViewController.h"
#import "ANNewStoreViewController.h"
#import "ANSingleType.h"
#import "ANNewCheckInViewController.h"
#import "ANSelectDeviceViewController.h"
#import "ANStoreSelectPeopleVC.h"
#import "ANChangeMainStoreVC.h"
#import "ANDistributionViewController.h"

@interface ANAreaDetailViewController ()<UITableViewDataSource, UITableViewDelegate, ANSubStoreListCellDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
/**
 *  负责人姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  积分
 */
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
///**
// *  联系方式
// */
//@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/**
 *  身份证Img
 */
@property (weak, nonatomic) IBOutlet UIImageView *identityCardImg;
/**
 *  门店Img
 */
@property (weak, nonatomic) IBOutlet UIImageView *storeImg;
/**
 *  门店名称
 */
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
/**
 *  签约人姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel;

///**
// *  门店类型
// */
//@property (weak, nonatomic) IBOutlet UILabel *storeTypeLabel;
///**
// *  门店地址
// */
//@property (weak, nonatomic) IBOutlet UILabel *storeAddressLabel;
/**
 *  暂停按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
/**
 *  修改按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  数据数组
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 *  打电话号码
 */
@property (nonatomic, copy) NSString * callString;
/**
 *  打电话视图
 */
@property (nonatomic, strong) UIWebView *webView;
/**
 *
 */
@property (nonatomic, strong) ANCustomSuperDetailModel *superModel;
/**
 *  点击添加门店n
 */
@property (weak, nonatomic) IBOutlet UILabel *addChiledStroenum;
/**
 *  tableView的头视图
 */
@property (weak, nonatomic) IBOutlet UIView *headView;
/**
 *  门店类型model
 */
@property (nonatomic, strong) ANStoreTypeModel *typeModel;
/**
 *  门头图文字
 */
@property (weak, nonatomic) IBOutlet UILabel *identityLabel;
/**
 *  身份证文字
 */
@property (weak, nonatomic) IBOutlet UILabel *storeLabel;
/**
 *  打电话按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *telBtn;
/**
 *  签约人打电话按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *secondeTelBtn;

/**
 *  是否第一次
 */
@property (nonatomic, assign) BOOL isFirst;
/**
 *  底部弹出视图
 */
@property (nonatomic, strong) UIAlertController *alertController;

@property (nonatomic, strong) UIAlertView *deleteAlertView;

@end

@implementation ANAreaDetailViewController

- (UIAlertController *)alertController
{
    if (_alertController == nil) {
        _alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择您要进行的操作" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *moveAction = [UIAlertAction actionWithTitle:@"编辑门店" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            ANChangeMainStoreVC *changeStoreVC = [[ANChangeMainStoreVC alloc] init];
            changeStoreVC.owner_id = self.owner_id;
            changeStoreVC.status = self.status;
            [self.navigationController pushViewController:changeStoreVC animated:YES];
        }];
        
        UIAlertAction *historyOrdersAction = [UIAlertAction actionWithTitle:@"历史订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ANLog(@"历史订单");
            ANDistributionViewController *distributionVC = [[ANDistributionViewController alloc] init];
            distributionVC.user_store_id = self.owner_id;
            [self.navigationController pushViewController:distributionVC animated:YES];
        }];
        
        UIAlertAction *changeAction = [UIAlertAction actionWithTitle:@"迁移门店" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ANStoreSelectPeopleVC *selectMarketVC = [[ANStoreSelectPeopleVC alloc] init];
            selectMarketVC.sourceVC = @"1";
            NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
            if ([self.superModel.marketing_id isEqualToString:user_id]) {
                selectMarketVC.marketing_id = @"0";
            }else {
                selectMarketVC.marketing_id = self.superModel.marketing_id;
            }
            selectMarketVC.ownerIDArr = [NSMutableArray arrayWithObject:self.owner_id];
            [self.navigationController pushViewController:selectMarketVC animated:YES];
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除门店" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            ANLog(@"删除门店");
            [self.deleteAlertView show];
        }];
        NSString *typeID = [[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"];
        if ([typeID isEqualToString:@"5"]) {
            [_alertController addAction:cancelAction];
            [_alertController addAction:historyOrdersAction];
            [_alertController addAction:moveAction];
            [_alertController addAction:changeAction];
            [_alertController addAction:deleteAction];
        }else {
            [_alertController addAction:cancelAction];
            [_alertController addAction:historyOrdersAction];
            [_alertController addAction:changeAction];
        }
    }
    return _alertController;
}
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    // setup a list of preview actions
   
    
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"编辑门店" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton1");
        ANChangeMainStoreVC *changeStoreVC = [[ANChangeMainStoreVC alloc] init];
        changeStoreVC.owner_id = self.owner_id;
        changeStoreVC.status = self.status;
        if ([self.delegate respondsToSelector:@selector(pushViewController:)]) {
            [self.delegate pushViewController:changeStoreVC];
        }
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"迁移门店" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton2");
        ANStoreSelectPeopleVC *selectMarketVC = [[ANStoreSelectPeopleVC alloc] init];
        selectMarketVC.sourceVC = @"1";
        NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
        if ([self.superModel.marketing_id isEqualToString:user_id]) {
            selectMarketVC.marketing_id = @"0";
        }else {
            selectMarketVC.marketing_id = self.superModel.marketing_id;
        }
        selectMarketVC.ownerIDArr = [NSMutableArray arrayWithObject:self.owner_id];
        if ([self.delegate respondsToSelector:@selector(pushViewController:)]) {
            [self.delegate pushViewController:selectMarketVC];
        }
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"设备绑定" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton3");
        if ([self.status isEqualToString:@"3"]) {
            [ANCommon setAlertViewWithMessage:@"撤店状态下无法操作。"];
            return;
        }
        NSInteger storeNum = self.superModel.store_num;
        NSInteger stopNum = self.superModel.stop_store_num;
        if (storeNum == 1 ) {
            ANSubStoreModel *subModel = [[ANSubStoreModel alloc] init];
            for (ANSubStoreModel *model in self.dataArray) {
                if (![model.status isEqualToString:@"3"]) {
                    subModel = model;
                }
            }
            
            ANSelectDeviceViewController *selectDeviceVC = [[ANSelectDeviceViewController alloc] init];
            selectDeviceVC.storeName = [NSString stringWithFormat:@"%@(%@)",subModel.title,subModel.title_branch];
            selectDeviceVC.storeID = self.subStoreID;
            if ([self.delegate respondsToSelector:@selector(pushViewController:)]) {
                [self.delegate pushViewController:selectDeviceVC];
            }
            return;
        }else if (stopNum != 0 && storeNum == 0) {
            [ANCommon setAlertViewWithMessage:@"已撤店门店不允许绑定设备"];
            return;
        }
        ANNewCheckInViewController *checkInVC = [[ANNewCheckInViewController alloc] init];
        checkInVC.storeID = self.subStoreID;
        if ([self.delegate respondsToSelector:@selector(pushViewController:)]) {
            [self.delegate pushViewController:checkInVC];
        }
        ANLog(@"设备登记");
    }];
    UIPreviewAction *action4 = [UIPreviewAction actionWithTitle:@"调整价格" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        ANLog(@"action4");
        if ([self.status isEqualToString:@"3"]) {
            [ANCommon setAlertViewWithMessage:@"撤店状态下无法操作。"];
            return;
        }
        ANLog(@"价格调整");
        ANSubStoreModel *model = [[ANSubStoreModel alloc] init];
        if (self.dataArray.count != 0) {
            model = self.dataArray[0];
            ANSubPriceAdjustmentViewController *priceAdjustment = [[ANSubPriceAdjustmentViewController alloc] init];
            priceAdjustment.store_id = model.store_id;
            priceAdjustment.storeName = model.title;
            priceAdjustment.storeCount = [NSString stringWithFormat:@"%ld", self.dataArray.count];
            priceAdjustment.phoneNumber = self.superModel.mobile;
            if ([self.delegate respondsToSelector:@selector(pushViewController:)]) {
                [self.delegate pushViewController:priceAdjustment];
            }
        }
    }];
    UIPreviewAction *action5 = [UIPreviewAction actionWithTitle:@"删除门店" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        if ([self.delegate respondsToSelector:@selector(deleteStore:)]) {
            [self.delegate deleteStore:self.owner_id];
        }
    }];
    NSString *typeID = [[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"];
    NSMutableArray *actions = [NSMutableArray array];
    if ([typeID isEqualToString:@"5"]) {
        [actions addObjectsFromArray:@[action3,action4,action1,action2,action5]];
    }else {
        [actions addObjectsFromArray:@[action1,action3,action4]];
    }
    
    
    // and return them (return the array of actions instead to see all items ungrouped)
    return actions;
}

- (UIAlertView *)deleteAlertView
{
    if (_deleteAlertView == nil) {
        _deleteAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除该掌柜所有门店,删除后将无法恢复!\n该账号将被停用,如需重签请联系客服!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    return _deleteAlertView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"区域管理门店详情页"];//("PageOne"为页面名称，可自定义)
    if (self.isFirst) {
        [self requestData];
    }else {
        self.isFirst = YES;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"区域管理门店详情页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [ANNotificationCenter addObserver:self selector:@selector(requestData) name:@"changeRequest" object:nil];
    
    [self setNavgation];
    [self setSubView];
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
    self.navigationItem.title = @"掌柜详情";
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 30);
    [rightBtn setImage:[UIImage imageNamed:@"setUp"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(6, 32, 6, 0)];
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    NSString *typeID = [[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"];
//    if ([typeID isEqualToString:@"5"]) {
//        //45262
//    }else if ([typeID isEqualToString:@"10"]) {
//        UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        rightBtn1.frame = CGRectMake(0, 0, 50, 30);
//        [rightBtn1 setTitle:@"修改" forState:UIControlStateNormal];
//        rightBtn1.titleLabel.font = [UIFont systemFontOfSize:14];
//        [rightBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [rightBtn1 addTarget:self action:@selector(clickRightChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn1];
//    }
}
- (void)setSubView
{
    self.pauseBtn = [ANCommon setBtnRadiusAndBorder:self.pauseBtn];
    self.changeBtn = [ANCommon setBtnRadiusAndBorder:self.changeBtn];
}
// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  点击详情上的打电话
 */
- (IBAction)clickTelBtn:(id)sender {
    [self callTel:self.superModel.mobile];
}
- (IBAction)clickSecondTelBtn:(id)sender {
    [self callTel:self.superModel.sign_user_mobile];
}


// 价格调整
- (IBAction)clickPauseBtn:(id)sender {
    if ([self.status isEqualToString:@"3"]) {
        [ANCommon setAlertViewWithMessage:@"撤店状态下无法操作。"];
        return;
    }
    ANLog(@"价格调整");
    ANSubStoreModel *model = [[ANSubStoreModel alloc] init];
    if (self.dataArray.count != 0) {
        model = self.dataArray[0];
        ANSubPriceAdjustmentViewController *priceAdjustment = [[ANSubPriceAdjustmentViewController alloc] init];
        priceAdjustment.store_id = model.store_id;
        priceAdjustment.storeName = model.title;
        priceAdjustment.storeCount = [NSString stringWithFormat:@"%ld", self.dataArray.count];
        priceAdjustment.phoneNumber = self.superModel.mobile;
        [self.navigationController pushViewController:priceAdjustment animated:YES];
    }
}
// 设备登记
- (IBAction)clickChangeBtn:(id)sender {
    if ([self.status isEqualToString:@"3"]) {
        [ANCommon setAlertViewWithMessage:@"撤店状态下无法操作。"];
        return;
    }
    NSInteger storeNum = self.superModel.store_num;
    NSInteger stopNum = self.superModel.stop_store_num;
    if (storeNum == 1 ) {
        ANSubStoreModel *subModel = [[ANSubStoreModel alloc] init];
        for (ANSubStoreModel *model in self.dataArray) {
            if (![model.status isEqualToString:@"3"]) {
                subModel = model;
            }
        }
        
        ANSelectDeviceViewController *selectDeviceVC = [[ANSelectDeviceViewController alloc] init];
        selectDeviceVC.storeName = [NSString stringWithFormat:@"%@(%@)",subModel.title,subModel.title_branch];
        selectDeviceVC.storeID = self.subStoreID;
        [self.navigationController pushViewController:selectDeviceVC animated:YES];
        return;
    }else if (stopNum != 0 && storeNum == 0) {
        [ANCommon setAlertViewWithMessage:@"已撤店门店不允许绑定设备"];
        return;
    }
    ANNewCheckInViewController *checkInVC = [[ANNewCheckInViewController alloc] init];
    checkInVC.storeID = self.subStoreID;
    [self.navigationController pushViewController:checkInVC animated:YES];
    ANLog(@"设备登记");
}
#pragma mark 门店迁移
- (void)clickRightChangeBtn:(UIButton *)btn
{
    ANChangeMainStoreVC *changeStoreVC = [[ANChangeMainStoreVC alloc] init];
    changeStoreVC.owner_id = self.owner_id;
    changeStoreVC.status = self.status;
    [self.navigationController pushViewController:changeStoreVC animated:YES];
}
- (void)clickRightBtn:(UIButton *)btn
{
    [self presentViewController:self.alertController animated:YES completion:nil];
//    self.menuView.hidden = !self.menuView.hidden;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ANLog(@"%ld",(long)buttonIndex);
}
///**
// *  门店迁移
// */
//- (IBAction)clickMoveBtn:(id)sender {
//    ANStoreSelectPeopleVC *selectMarketVC = [[ANStoreSelectPeopleVC alloc] init];
//    selectMarketVC.sourceVC = @"1";
//    NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
//    if ([self.superModel.marketing_id isEqualToString:user_id]) {
//        selectMarketVC.marketing_id = @"0";
//    }else {
//        selectMarketVC.marketing_id = self.superModel.marketing_id;
//    }
//    selectMarketVC.ownerIDArr = [NSMutableArray arrayWithObject:self.owner_id];
//    [self.navigationController pushViewController:selectMarketVC animated:YES];
//}
///**
// *  门店修改
// */
//- (IBAction)clickChangeStoreBtn:(id)sender {
//    ANChangeMainStoreVC *changeStoreVC = [[ANChangeMainStoreVC alloc] init];
//    changeStoreVC.owner_id = self.owner_id;
//    changeStoreVC.status = self.status;
//    [self.navigationController pushViewController:changeStoreVC animated:YES];
//}

#pragma mark ----UITableViewDelegate
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
    ANSubStoreListCell *cell = [ANSubStoreListCell subStoreTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANSubStoreDetailViewController *subStoreDetail = [[ANSubStoreDetailViewController alloc] init];
    ANSubStoreModel *model = self.dataArray[indexPath.row];
    subStoreDetail.storeID = model.store_id;
    subStoreDetail.typeID = model.type;
    subStoreDetail.owner_id = self.owner_id;
    subStoreDetail.isDealer = YES;
    [self.navigationController pushViewController:subStoreDetail animated:YES];
}
- (void)subStoreListCell:(ANSubStoreListCell *)cell clickPhone:(NSString *)phone
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ANSubStoreModel *model = self.dataArray[indexPath.row];
//    [ANCommon setAlertViewWithTitle:@"呼叫" andMessage:phone andVC:self];
//    ANLog(@"%@", phone);
    self.callString = model.mobile;
//    ANLog(@"%@",model.type);
    [self callTel:self.callString];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.deleteAlertView) {
        if (buttonIndex == 1) {
            [self deleteStore];
        }
    }else {
        if (buttonIndex == 0) {
            ANLog(@"拨打");
            [self callTel:self.callString];
            
            //        NSString *allString = [NSString stringWithFormat:@"tel:%@", self.callString];
            //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
        }
    }
    
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
#pragma mark ---- 添加分店
- (IBAction)addChildStroe:(id)sender {
    if ([self.status isEqualToString:@"3"]) {
        [ANCommon setAlertViewWithMessage:@"撤店状态下无法操作。"];
        return;
    }
    ANNewStoreViewController *newStore = [[ANNewStoreViewController alloc] init];
    
    newStore.phoneNumber = self.superModel.mobile;
    newStore.connectionNameStr = self.superModel.name;
    
    ANSubStoreModel *model = self.dataArray[0];
    newStore.typeID = model.type;
    newStore.storeName = model.title;
    newStore.isNewStore = YES;
    newStore.owner_id = self.owner_id;
    newStore.isDealerNewStore = YES;
    [self.navigationController pushViewController:newStore animated:YES];
}
#pragma mark ---- 网络请求
- (void)requestData
{
    // 请求总店
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.owner_id forKey:@"owner_id"];
    parmDic = (NSMutableDictionary *)[ANCommon dicToSign:parmDic];
    
    [ANHttpTool postWithUrl:@"/api/1/store/get_user_store" params:parmDic successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseSuperStoreData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject[@"message"]);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
    // 请求分店
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.owner_id forKey:@"owner_id"];
    [parmDict setObject:self.status forKey:@"status"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/store/list_agency_owner_stores" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseSubStoreData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
// 解析主店信息
- (void)parseSuperStoreData:(id)data
{
//    ANLog(@"%@",data);
    NSDictionary *tempDic = data[@"response"];
    self.superModel = [ANCustomSuperDetailModel mj_objectWithKeyValues:tempDic];
}
// 设置主店信息
- (void)setSuperModel:(ANCustomSuperDetailModel *)superModel
{
    if (_superModel != superModel) {
        _superModel = superModel;
    }
    self.nameLabel.text = [NSString stringWithFormat:@"%@ | %@",superModel.name,superModel.mobile];
    self.secondNameLabel.text = [NSString stringWithFormat:@"%@ | %@",self.superModel.sign_user_name, self.superModel.sign_user_mobile];
    self.levelLabel.text = superModel.score;
    if ([superModel.is_have_cert_company isEqualToString:@"1"]) {
        self.identityCardImg.hidden = NO;
        self.identityLabel.hidden = YES;
    }else {
        self.identityCardImg.hidden = YES;
        self.identityLabel.hidden = NO;
    }
    if ([superModel.is_have_cert_idcard isEqualToString:@"1"]) {
        self.storeImg.hidden = NO;
        self.storeLabel.hidden = YES;
    }else {
        self.storeImg.hidden = YES;
        self.storeLabel.hidden = NO;
    }
    [self.tableView setTableHeaderView:self.headView];
}

// 解析分店信息
- (void)parseSubStoreData:(id)data
{
//    ANLog(@"分店 data : %@", data);
    self.dataArray = [NSMutableArray array];
    NSArray *tempArr = data[@"response"][@"stores"];
    for (NSDictionary *dict in tempArr) {
        ANSubStoreModel *model = [ANSubStoreModel mj_objectWithKeyValues:dict];
//        self.storeName = model.title;
        [self.dataArray addObject:model];
    }
    
//    self.addSubStoreLabel.text = [NSString stringWithFormat:@"点击添加门店%ld", self.dataArray.count+1];
    [self.tableView reloadData];
//    self.addChiledStroenum.text = [NSString stringWithFormat:@"点击添加新门店", self.dataArray.count + 1];
    
    if (self.dataArray.count == 0) {
        return;
    }
    
    ANSubStoreModel *model = self.dataArray[0];
    
    ANSingleType *singleType = [ANSingleType sharetype];
    if (singleType.dataArr == nil) {                // 无,请求类型数据
        [singleType requestData];
        [singleType typeBlock:^(NSArray *typeArr) {
            self.typeModel = [singleType storeTypeModelWithTypeID:model.type];
            self.storeNameLabel.text = [NSString stringWithFormat:@"%@ | %@",model.title,self.typeModel.typeName];
        }];
    }else {                                         // 有,直接根据id获取类型model
        self.typeModel = [singleType storeTypeModelWithTypeID:model.type];
        self.storeNameLabel.text = [NSString stringWithFormat:@"%@ | %@",model.title,self.typeModel.typeName];
    }
}

- (void)deleteStore
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.owner_id forKey:@"owner_id"];
    params = (NSMutableDictionary *)[ANCommon dicToSign:params];
    [ANHttpTool postWithUrl:@"/api/1/store/del_user_store" params:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
//        ANLog(@"%@",responseObject);
        [[ANCommon alloc] setAlertView:responseObject[@"message"]];
        dispatch_time_t time = dispatch_time ( DISPATCH_TIME_NOW , 2ull * NSEC_PER_SEC ) ;
        dispatch_after(time, dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(deleteStoreSuccess:)]) {
                [self.delegate deleteStoreSuccess:self.indexPath];
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
//        ANLog(@"%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
    
}

- (void)dealloc
{
    [ANNotificationCenter removeObserver:self];
}

@end

//
//  ANPeopleDetailViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/20.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANPeopleDetailViewController.h"
#import "ANJieyueViewController.h"
#import "ANHttpTool.h"
#import "ANPeopleDetailModel.h"
#import "ANPeopleStoreListVC.h"
#import "ANChangePeopleViewController.h"

@interface ANPeopleDetailViewController ()<UIAlertViewDelegate, ANChangePeopleViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *jieyueBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeContentBtn;
@property (nonatomic, strong) ANPeopleDetailModel *model;
@property (weak, nonatomic) IBOutlet UILabel *realeName;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
/**
 *  本月销售额
 */
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
/**
 *  本月销量
 */
@property (weak, nonatomic) IBOutlet UILabel *monthNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property (nonatomic, strong) UIAlertController *alertController;

@property (nonatomic, strong) UIAlertView *deleteAlertView;


@end

@implementation ANPeopleDetailViewController

- (UIAlertController *)alertController
{
    if (_alertController == nil) {
        _alertController = [UIAlertController alertControllerWithTitle:@"设置" message:@"请选择编辑人员信息还是删除市场人员" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *moveAction = [UIAlertAction actionWithTitle:@"编辑信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            if ([self.model.status isEqualToString:@"0"]) {
                [ANCommon setAlertViewWithMessage:@"请先恢复市场人员再进行信息修改"];
                return ;
            }
            ANChangePeopleViewController *changePeopleVC = [[ANChangePeopleViewController alloc] init];
            changePeopleVC.delegate = self;
            changePeopleVC.model = self.model;
            changePeopleVC.marketing_id = self.marketing_id;
            [self.navigationController pushViewController:changePeopleVC animated:YES];
        }];
        UIAlertAction *changeAction = [UIAlertAction actionWithTitle:@"删除人员" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            ANStoreSelectPeopleVC *selectMarketVC = [[ANStoreSelectPeopleVC alloc] init];
//            selectMarketVC.sourceVC = @"1";
//            NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
//            if ([self.superModel.marketing_id isEqualToString:user_id]) {
//                selectMarketVC.marketing_id = @"0";
//            }else {
//                selectMarketVC.marketing_id = self.superModel.marketing_id;
//            }
//            selectMarketVC.ownerIDArr = [NSMutableArray arrayWithObject:self.owner_id];
//            [self.navigationController pushViewController:selectMarketVC animated:YES];
            [self.deleteAlertView show];
        }];
        [_alertController addAction:cancelAction];
        [_alertController addAction:moveAction];
        [_alertController addAction:changeAction];
    }
    return _alertController;
}

- (UIAlertView *)deleteAlertView
{
    if (_deleteAlertView == nil) {
        _deleteAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除市场人员,删除后不可恢复.\n若要重签该手机号需联系客服." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    }
    return _deleteAlertView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"人员详情页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"人员详情页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];
    [self setSubView];
    [self requestData];
}
#pragma mark ---- 自定义方法
// 设置nav
- (void)setNavgation
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"人员详情";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    // 设置右按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 50, 30);
    //        [rightBtn setTitle:@"迁移" forState:UIControlStateNormal];
    //        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    //        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"setUp"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(6, 32, 6, 0)];
    //        [rightBtn setBackgroundImage:[UIImage imageNamed:@"setUp"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}
// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickRightBtn:(UIButton *)btn
{
    [self presentViewController:self.alertController animated:YES completion:nil];
}
- (void)setSubView
{
    self.jieyueBtn = [ANCommon setBtnRadiusAndBorder:self.jieyueBtn];
    self.changeContentBtn = [ANCommon setBtnRadiusAndBorder:self.changeContentBtn];
}
- (IBAction)clickJieyueBtn:(id)sender {
    ANLog(@"解约");
    
    NSString *str = @"";
    if ([self.model.status isEqualToString:@"1"]) {
        str = @"确定解约人员?";
    }else {
        str = @"确定恢复人员?";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (IBAction)clickChangeBtn:(id)sender {
    ANLog(@"人员迁移");
    if ([self.model.store_num isEqualToString:@"0"]) {
        [ANCommon setAlertViewWithMessage:@"该市场人员暂未签约掌柜"];
        return;
    }
    ANPeopleStoreListVC *peopleStoreListVC = [[ANPeopleStoreListVC alloc] init];
    peopleStoreListVC.marketing_id = self.marketing_id;
    [self.navigationController pushViewController:peopleStoreListVC animated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView == self.deleteAlertView) {
            [self deletePeople];
        }else {
            [self performSelector:@selector(requestUnwind) withObject:nil afterDelay:0.3f];
        }
    }
}
- (void)requestPeopleData
{
    [self requestData];
}
- (void)requestUnwind
{
    ANLog(@"%@",self.model.status);
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setObject:self.marketing_id forKey:@"marketing_id"];
    if ([self.model.status isEqualToString:@"1"]) {
        [paramsDict setObject:@"0" forKey:@"marketing_status"];
    }else {
        [paramsDict setObject:@"1" forKey:@"marketing_status"];
    }
    paramsDict = (NSMutableDictionary *)[ANCommon dicToSign:paramsDict];
    ANLog(@"%@",paramsDict);
    [ANHttpTool postWithUrl:@"/api/1/dealers/change_people_status" params:paramsDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
        [self requestData];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
}
#pragma mark ----网络请求
- (void)requestData
{
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.marketing_id forKey:@"marketing_id"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [ANHttpTool postWithUrl:@"/api/1/dealers/get_people_detail" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseSubStoreData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)parseSubStoreData:(id)data
{
    NSDictionary *tempDict = data[@"response"];
    if (tempDict) {
        self.model = [ANPeopleDetailModel mj_objectWithKeyValues:tempDict];
    }
}
- (void)setModel:(ANPeopleDetailModel *)model
{
    if (_model != model) {
        _model = model;
    }
    if ([model.status isEqualToString:@"1"]) {
        [self.bottomBtn setTitle:@"人员解约" forState:UIControlStateNormal];
    }else {
        [self.bottomBtn setTitle:@"人员恢复" forState:UIControlStateNormal];
    }
    if ([model.realname isEqualToString:@""]) {
        
    }else {
        self.realeName.text = model.realname;
    }
    if ([model.mobile isEqualToString:@""]) {
        
    }else {
        self.phoneLabel.text = model.mobile;
    }
    if ([model.gender isEqualToString:@"0"]) {
        self.genderLabel.text = @"女";
    }else {
        self.genderLabel.text = @"男";
    }
    if ([model.qq isEqualToString:@""]) {
        
    }else {
        self.qqLabel.text = model.qq;
    }
    if ([model.weixin isEqualToString:@""]) {
        
    }else {
        self.weixinLabel.text = model.weixin;
    }
    if ([model.idcard isEqualToString:@""]) {
        
    }else {
        self.cardLabel.text = model.idcard;
    }
    if ([model.bank_cardno isEqualToString:@""]) {
        
    }else {
        self.bankLabel.text = [NSString stringWithFormat:@"%@ %@",model.bank_name,model.bank_cardno];
    }
    self.monthLabel.text = model.month_sales_money;
    self.monthNumLabel.text = model.month_sales_num;
}

- (void)deletePeople
{
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    [parmas setObject:self.marketing_id forKey:@"marketing_id"];
    parmas = (NSMutableDictionary *)[ANCommon dicToSign:parmas];
    ANLog(@"%@",parmas);
    
    [ANHttpTool postWithUrl:@"/api/1/dealers/delete_marketing" params:parmas successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [[ANCommon alloc] setAlertView:responseObject[@"message"]];
        dispatch_time_t time = dispatch_time ( DISPATCH_TIME_NOW , 2ull * NSEC_PER_SEC ) ;
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
}

@end

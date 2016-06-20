//
//  ANDeviceDetailViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/18.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANDeviceDetailViewController.h"
#import "ANHttpTool.h"
#import "ANRemoveDeviceViewController.h"
#import "ZBarSDK.h"
#import "ZHJuBuViewController.h"
#import "ANDeviceCell.h"
#import "ANDeviceModel.h"


@interface ANDeviceDetailViewController ()<UITextFieldDelegate, UIAlertViewDelegate,ZBarReaderDelegate, UITableViewDelegate, UITableViewDataSource, ANDeviceCellDelegate>
/**
 *  设备名称
 */
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
/**
 *  登记视图
 */
@property (weak, nonatomic) IBOutlet UIView *checkInView;
/**
 *  展示视图
 */
@property (weak, nonatomic) IBOutlet UIView *infoView;
/**
 *  登记输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *checkInTextField;
/**
 *  设备串码
 */
@property (weak, nonatomic) IBOutlet UILabel *deviceNumLabel;
/**
 *  解除绑定Label
 */
@property (weak, nonatomic) IBOutlet UILabel *removeLabel;
/**
 *  解除绑定Btn
 */
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;
/**
 *  下部视图
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/**
 *  弹出提示框
 */
@property (nonatomic, strong) UIAlertView *alertView;
/**
 *  开头标题Label
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *  键盘是否显示  1为显示  0为不显示
 */
@property (nonatomic, assign) BOOL isShowKeyBoard;
/**
 *  提示Label
 */
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
/**
 *  扫描按钮
 */
@property (weak, nonatomic) IBOutlet UIView *scanBtn;
/**
 *  要提交的设备号
 */
@property (nonatomic, copy) NSString *submitDeviceNum;
/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  数据数组
 */
@property (nonatomic, strong) NSMutableArray *dataArr;


@end

@implementation ANDeviceDetailViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isDevice) {
        
    }else {
        if (self.isShowKeyBoard ) {
            [self.checkInTextField becomeFirstResponder];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"设备登记串码登记页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.checkInTextField endEditing:YES];
    [MobClick endLogPageView:@"设备登记串码登记页"];
}
- (void)autoBack
{
    [[ANCommon alloc] setAlertView:@"设备暂未推出敬请关注。"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.deviceNameLabel.text = self.deviceName;
    self.removeLabel.layer.cornerRadius = 3;
    self.removeLabel.layer.masksToBounds = YES;
    
    self.dataArr = [NSMutableArray array];
    
    [ANNotificationCenter addObserver:self selector:@selector(requestTableViewData) name:@"removeDevice" object:nil];
    [ANNotificationCenter addObserver:self selector:@selector(scanStr:) name:@"scan" object:nil];
    
    [self setNavgation];
    
    if (self.isDevice) {
        self.checkInView.hidden = YES;
        self.infoView.hidden = NO;
        self.deviceNumLabel.text = self.deviceNum;
        self.bottomView.hidden = YES;
    }else {
        self.checkInView.hidden = NO;
        self.infoView.hidden = YES;
    }
    if ([self.deviceNo isEqualToString:@"1"]) {
        self.isShowKeyBoard = YES;
        self.titleLabel.text = @"ZX";
        self.scanBtn.hidden = YES;
        self.promptLabel.hidden = NO;
        self.checkInTextField.placeholder = @" 输入ZX后9位数字串码";
        [self requestTableViewData];
    }else if ([self.deviceNo isEqualToString:@"2"]) {
        if ([self.model.allow_bind isEqualToString:@"0"]) {
            [self autoBack];
            self.isShowKeyBoard = NO;
        }else {
            self.isShowKeyBoard = YES;
            self.titleLabel.text = @"MX";
            self.checkInTextField.placeholder = @" 输入MX后10位数字串码";
            [self requestTableViewData];
        }
    }else if ([self.deviceNo isEqualToString:@"3"]) {
        if ([self.model.allow_bind isEqualToString:@"0"]) {
            [self autoBack];
            self.isShowKeyBoard = NO;
        }else {
            self.isShowKeyBoard = YES;
            self.titleLabel.text = @"AD";
            self.checkInTextField.placeholder = @" 输入AD后10位数字串码";
            [self requestTableViewData];
        }
    }else if ([self.deviceNo isEqualToString:@"4"]) {
        self.titleLabel.text = @"OS";
        if ([self.model.allow_bind isEqualToString:@"0"]) {
            [self autoBack];
            self.isShowKeyBoard = NO;
        }else {
            self.isShowKeyBoard = YES;
            self.checkInTextField.placeholder = @" 输入OS后9位数字串码";
            [self requestTableViewData];
        }
    }else if ([self.deviceNo isEqualToString:@"5"]) {
        self.titleLabel.text = @"TA";
        if ([self.model.allow_bind isEqualToString:@"0"]) {
            self.isShowKeyBoard = NO;
            [self autoBack];
        }else {
            self.isShowKeyBoard = YES;
            self.checkInTextField.placeholder = @" 输入PA后10位数字串码";
            [self requestTableViewData];
        }
    }
    
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
    self.navigationItem.title = @"设备绑定";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ANLog(@"%lu",(unsigned long)self.dataArr.count);
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANDeviceCell *cell = [ANDeviceCell deviceTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
#pragma mark ANDeviceCellDelegate
- (void)deviceCell:(ANDeviceCell *)cell clickUnwarpBtn:(UIButton *)btn
{
    ANRemoveDeviceViewController *removeDeviceVC = [[ANRemoveDeviceViewController alloc] init];
    removeDeviceVC.storeID = self.storeID;
    removeDeviceVC.deviceNo = cell.model.device_no;
    [self presentViewController:removeDeviceVC animated:YES completion:nil];
}

#pragma mark ---- 扫描
- (void)scanStr:(NSNotification *)notification
{
    NSString *scanNum = notification.userInfo[@"scan"];
    ANLog(@"%@",scanNum);
    self.checkInTextField.text = [scanNum substringFromIndex:2];
}
#pragma ZBarReaderDelegate 代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    id <NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for (symbol in results) {
        break;
    }
    NSString *text = symbol.data;
    self.checkInTextField.text = [text substringFromIndex:2];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

// 扫描设备码
- (IBAction)clickCheckInBtn:(id)sender {
    ANLog(@"设备登记");
    [self.checkInTextField endEditing:YES];
    ZHJuBuViewController *VC = [[ZHJuBuViewController alloc] init];
    __weak ANDeviceDetailViewController *weakSelf = self;
    VC.block = ^(NSString *text){
        ANLog(@"%@",text);
        NSString *prefixStr = [text substringToIndex:2];
        if ([self.deviceNo isEqualToString:@"2"]) {
            if ([prefixStr isEqualToString:@"MX"]) {
                weakSelf.checkInTextField.text = [text substringFromIndex:2];
            }else {
                [ANCommon setAlertViewWithMessage:@"请扫描2代爆米花箱设备串码"];
            }
        }else if ([self.deviceNo isEqualToString:@"3"]) {
            if ([prefixStr isEqualToString:@"AD"]) {
                weakSelf.checkInTextField.text = [text substringFromIndex:2];
            }else {
                [ANCommon setAlertViewWithMessage:@"请扫描液晶屏设备串码"];
            }
        }else if ([self.deviceNo isEqualToString:@"4"]) {
            if ([prefixStr isEqualToString:@"OS"]) {
                weakSelf.checkInTextField.text = [text substringFromIndex:2];
            }else {
                [ANCommon setAlertViewWithMessage:@"请扫描摇一摇设备串码"];
            }
        }else if ([self.deviceNo isEqualToString:@"5"]) {
            if ([prefixStr isEqualToString:@"PA"]) {
                weakSelf.checkInTextField.text = [text substringFromIndex:2];
            }else {
                [ANCommon setAlertViewWithMessage:@"请扫描游戏桌设备串码"];
            }
        }
    };
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ---- alertView
- (UIAlertView *)alertView
{
    if (_alertView == nil) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备绑定成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    }
    return _alertView;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.checkInTextField.text = @"";
//    [self.navigationController popViewControllerAnimated:YES];
//    self.deviceNumLabel.text = self.submitDeviceNum;
//    self.infoView.hidden = NO;
//    self.checkInView.hidden = YES;
//    self.bottomView.hidden = YES;
    
}

#pragma mark ---- textFieldDelegate

- (IBAction)clickSureBtn:(id)sender {
    
    if (self.checkInTextField.text.length == 0) {
        [ANCommon setAlertViewWithMessage:@"设备串码不能为空"];
        return;
    }
    NSString *str = [self.checkInTextField.text substringToIndex:2];
    ANLog(@"%@",str);
    
    if ([self.deviceNo isEqualToString:@"1"]) {
        if (self.checkInTextField.text.length == 9) {
            if ([self isPureInt:self.checkInTextField.text]) {
                self.submitDeviceNum = [NSString stringWithFormat:@"ZX%@",self.checkInTextField.text];
            }else {
                [ANCommon setAlertViewWithMessage:@"请输入以ZX开头的9位数字串码"];
                return;
            }
        }else {
            [ANCommon setAlertViewWithMessage:@"请输入以ZX开头的9位数字串码"];
            return;
        }
    }else if ([self.deviceNo isEqualToString:@"2"]) {
        if (self.checkInTextField.text.length == 10) {
            if ([self isPureInt:self.checkInTextField.text]) {
                self.submitDeviceNum = [NSString stringWithFormat:@"MX%@",self.checkInTextField.text];
            }else {
                [ANCommon setAlertViewWithMessage:@"请输入以MX开头的10位数字串码"];
                return;
            }
        }else {
            [ANCommon setAlertViewWithMessage:@"请输入以MX开头的10位数字串码"];
            return;
        }
    }else if ([self.deviceNo isEqualToString:@"3"]) {
        if (self.checkInTextField.text.length == 10) {
            if ([self isPureInt:self.checkInTextField.text]) {
                self.submitDeviceNum = [NSString stringWithFormat:@"AD%@",self.checkInTextField.text];
            }else {
                [ANCommon setAlertViewWithMessage:@"请输入以AD开头的10位数字串码"];
                return;
            }
        }else {
            [ANCommon setAlertViewWithMessage:@"请输入以AD开头的10位数字串码"];
            return;
        }
    }else if ([self.deviceNo isEqualToString:@"4"]) {
        if (self.checkInTextField.text.length == 9) {
            if ([self isPureInt:self.checkInTextField.text]) {
                self.submitDeviceNum = [NSString stringWithFormat:@"OS%@",self.checkInTextField.text];
            }else {
                [ANCommon setAlertViewWithMessage:@"请输入以OS开头的9位数字串码"];
                return;
            }
        }else {
            [ANCommon setAlertViewWithMessage:@"请输入以OS开头的9位数字串码"];
            return;
        }
        
    }else if ([self.deviceNo isEqualToString:@"5"]) {
        if (self.checkInTextField.text.length == 10) {
            if ([self isPureInt:self.checkInTextField.text]) {
                self.submitDeviceNum = [NSString stringWithFormat:@"TA%@",self.checkInTextField.text];
            }else {
                [ANCommon setAlertViewWithMessage:@"请输入以TA开头的10位数字串码"];
                return;
            }
        }else {
            [ANCommon setAlertViewWithMessage:@"请输入以TA开头的10位数字串码"];
            return;
        }
    }
    
    [self requestData];
    
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
#pragma mark ---- 解除绑定
- (IBAction)clickRemoveBtn:(id)sender {
    ANRemoveDeviceViewController *removeDeviceVC = [[ANRemoveDeviceViewController alloc] init];
    removeDeviceVC.storeID = self.storeID;
    if (self.deviceNum == nil) {
        removeDeviceVC.deviceNo = self.submitDeviceNum;
    }else {
        removeDeviceVC.deviceNo = self.deviceNum;
    }
    [self presentViewController:removeDeviceVC animated:YES completion:nil];
}


#pragma mark ---- 网络请求
- (void)requestData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.submitDeviceNum forKey:@"device_no"];
    [parmDict setObject:@"" forKey:@"extra"];
    [parmDict setObject:@"2" forKey:@"status"];
    [parmDict setObject:self.storeID forKey:@"store_id"];
    [parmDict setObject:@"" forKey:@"unbind_reason"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    
    ANLog(@"%@",parmDict);
    
    [ANHttpTool postWithUrl:@"/api/1/store/bind_store_device" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"success:%@",responseObject);
//        [self.checkInTextField endEditing:YES];
        [self.alertView show];
        [self requestTableViewData];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)requestTableViewData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.storeID forKey:@"store_id"];
    [dict setObject:self.res_name forKey:@"res_name"];
    NSDictionary *params = [ANCommon dicToSign:dict];
    
    [ANHttpTool postWithUrl:@"/api/1/store/get_store_device_list" params:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [self parseTableViewData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
}
- (void)parseTableViewData:(id)data
{
    NSArray *keyArr = [data allKeys];
    if (keyArr.count == 3) {
        self.dataArr = [ANDeviceModel mj_objectArrayWithKeyValuesArray:data[@"response"]];
        [self.tableView reloadData];
    }else {
        [self.dataArr removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)dealloc
{
    [ANNotificationCenter removeObserver:self name:@"removeDevice" object:nil];
}

@end

//
//  ANEditAddressViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/4/29.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANEditAddressViewController.h"
#import "ANHttpTool.h"

@interface ANEditAddressViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) UIPickerView *pickerView;
/**
 *  省
 */
@property (nonatomic, strong) NSMutableArray *provinceDataArr;
/**
 *  省数量
 */
@property (nonatomic, assign) NSInteger provinceNum;
/**
 *  省编码
 */
@property (nonatomic, copy) NSString *provinceStr;
/**
 *  市
 */
@property (nonatomic, strong) NSMutableArray *cityDataArr;
/**
 *  市数量
 */
@property (nonatomic, assign) NSInteger cityNum;
/**
 *  市编码
 */
@property (nonatomic, copy) NSString *cityStr;
/**
 *  区
 */
@property (nonatomic, strong) NSMutableArray *districtDataArr;
/**
 *  区数量
 */
@property (nonatomic, assign) NSInteger districtNum;
/**
 *  区编码
 */
@property (nonatomic, copy) NSString *districtStr;
/**
 *  底部视图
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/**
 *  底部父视图
 */
@property (weak, nonatomic) IBOutlet UIView *bottomSuperView;
/**
 *  姓名Text
 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextLabel;
/**
 *  手机号Text
 */
@property (weak, nonatomic) IBOutlet UITextField *mobilTextLabel;
/**
 *  省市区Btn
 */
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
/**
 *  addressText
 */
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
/**
 *  左按钮
 */
@property (nonatomic, strong) UIButton *leftBtn;
/**
 *  右按钮
 */
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation ANEditAddressViewController

- (NSMutableArray *)provinceDataArr
{
    if (_provinceDataArr == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Area" ofType:@"plist"];
        NSLog(@"%@",path);
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:path];
        ANLog(@"%@",arr);
        _provinceDataArr = arr[0];
    }
    return _provinceDataArr;
}
- (NSMutableArray *)cityDataArr
{
    if (_cityDataArr == nil) {
        _cityDataArr = [NSMutableArray arrayWithArray:self.provinceDataArr[0][@"list"]];
    }
    return _cityDataArr;
}
- (NSMutableArray *)districtDataArr
{
    if (_districtDataArr == nil) {
        _districtDataArr = [NSMutableArray arrayWithArray:self.cityDataArr[0][@"list"]];
    }
    return _districtDataArr;
}

- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, 216)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}
- (UIButton *)leftBtn
{
    if (_leftBtn == nil) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, 0, 100, 44);
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 55)];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_leftBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
- (UIButton *)rightBtn
{
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(0, 0, 100, 44);
        [_rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 55, 0, 0)];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavgation];
    self.cityNum = self.cityDataArr.count;
    self.districtNum = self.districtDataArr.count;
    
    [self.bottomView addSubview:self.pickerView];
    
    
    if (self.isAdd) {
//        self.rightBtn.enabled = NO;
//        [self.rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }else {
        self.nameTextLabel.text = self.model.dealer_name;
        self.mobilTextLabel.text = self.model.dealer_mobile;
        [self.areaBtn setTitle:[NSString stringWithFormat:@"%@%@%@",self.model.province_area,self.model.city_area,self.model.county_area] forState:UIControlStateNormal];
        [self.areaBtn setTitleColor:[UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0] forState:UIControlStateNormal];
        self.addressTextView.text = self.model.dealer_address;
        self.provinceStr = self.model.province_code;
        self.cityStr = self.model.city_code;
        self.districtStr = self.model.county_code;
    }
}
- (void)setNavgation
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"修改地址";
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    
}
- (void)returnBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)clickSureBtn
{
    if ([self.nameTextLabel.text isEqualToString:@""]) {
        [ANCommon setAlertViewWithMessage:@"请输入收货人姓名"];
        return;
    }else if ([self.mobilTextLabel.text isEqualToString:@""]) {
        [ANCommon setAlertViewWithMessage:@"请输入收货人手机号"];
        return;
    }else if (self.mobilTextLabel.text.length != 11) {
        [ANCommon setAlertViewWithMessage:@"请输入正确的手机号"];
        return;
    }else if ([self.areaBtn.titleLabel.text isEqualToString:@"请选择省市区"]) {
        [ANCommon setAlertViewWithMessage:@"请选择省市区"];
        return;
    }else if ([self.addressTextView.text isEqualToString:@""]) {
        [ANCommon setAlertViewWithMessage:@"请输入详细地址"];
        return;
    }
        [self updateAddress];
}


- (IBAction)clickAddressBtn:(id)sender {
    self.bottomSuperView.hidden = YES;
}
- (IBAction)clickPickViewSureBtn:(id)sender {
    self.bottomSuperView.hidden = YES;
    [self.areaBtn setTitleColor:[UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0] forState:UIControlStateNormal];
    self.provinceStr = @"";
    self.cityStr = @"";
    self.districtStr = @"";
    NSString *addressStr = self.provinceDataArr[[self.pickerView selectedRowInComponent:0]][@"area"];
    self.provinceStr = self.provinceDataArr[[self.pickerView selectedRowInComponent:0]][@"area_code"];
    if (self.cityNum != 0) {
        addressStr = [addressStr stringByAppendingString:self.cityDataArr[[self.pickerView selectedRowInComponent:1]][@"area"]];
        self.cityStr = self.cityDataArr[[self.pickerView selectedRowInComponent:1]][@"area_code"];
        if (self.districtNum != 0) {
            addressStr = [addressStr stringByAppendingString:self.districtDataArr[[self.pickerView selectedRowInComponent:2]][@"area"]];
            self.districtStr = self.districtDataArr[[self.pickerView selectedRowInComponent:2]][@"area_code"];
        }
    }
    [self.areaBtn setTitle:addressStr forState:UIControlStateNormal];
}
- (IBAction)clickAreaBtn:(id)sender {
    [self.view endEditing:YES];
    self.bottomSuperView.hidden = NO;
}
- (IBAction)clickButtonBtn:(id)sender {
    self.bottomSuperView.hidden = YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceDataArr.count;
    }else if (component == 1) {
        return self.cityNum;
    }else {
        return self.districtNum;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceDataArr[row][@"area"];
    }else if (component == 1){
        return self.cityDataArr[row][@"area"];
    }else {
        return self.districtDataArr[row][@"area"];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.cityDataArr = self.provinceDataArr[row][@"list"];
        self.cityNum = self.cityDataArr.count;
        [self.pickerView reloadComponent:1];
        if (self.cityNum == 0) {
            self.districtNum = 0;
            [self.pickerView reloadComponent:2];
        }else {
            self.districtDataArr = self.cityDataArr[0][@"list"];
            self.districtNum = self.districtDataArr.count;
            [self.pickerView reloadComponent:2];
        }
    }else if (component == 1) {
        self.districtDataArr = self.cityDataArr[[self.pickerView selectedRowInComponent:1]][@"list"];
        self.districtNum = self.districtDataArr.count;
        [self.pickerView reloadComponent:2];
    }else {
        
    }
}

- (void)updateAddress
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.isAdd) {
        [params setObject:@"0" forKey:@"address_id"];
    }else {
        [params setObject:self.model.ID forKey:@"address_id"];
    }
    [params setObject:self.cityStr forKey:@"city_code"];
    [params setObject:self.districtStr forKey:@"county_code"];
    [params setObject:self.addressTextView.text forKey:@"dealer_address"];
    [params setObject:self.mobilTextLabel.text forKey:@"dealer_mobile"];
    [params setObject:self.nameTextLabel.text forKey:@"dealer_name"];
    [params setObject:self.provinceStr forKey:@"province_code"];
    params  = (NSMutableDictionary *)[ANCommon dicToSign:params];
    ANLog(@"%@",params);
    [ANHttpTool postWithUrl:@"/api/1/dealers/update_dealer_address" params:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [[ANCommon alloc] setAlertView:responseObject[@"message"][@"info"]];
        dispatch_time_t time = dispatch_time ( DISPATCH_TIME_NOW , 2ull * NSEC_PER_SEC ) ;
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

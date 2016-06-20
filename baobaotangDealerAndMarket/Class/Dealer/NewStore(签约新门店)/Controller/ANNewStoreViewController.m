//
//  ANNewStoreViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/25.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANNewStoreViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "ANStoreTypeViewController.h"
#import "ANSubStoreModel.h"
#import "ANHttpTool.h"
#import "ANSingleType.h"
#import "ANStoreTypeModel.h"
#import "ANCustomerSuccessViewController.h"

@interface ANNewStoreViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MAMapViewDelegate, AMapSearchDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    
    CLLocation *_currentLocation;
    UIButton *_locationButton;
}


@property (nonatomic, assign) BOOL hasStrorImage;


@property (weak, nonatomic) IBOutlet UIView *mapSuperView;

/**
 *  完成创建的父视图
 */
@property (weak, nonatomic) IBOutlet UIView *aduitSuperView;

/**
 *  提交审核
 */
@property (weak, nonatomic) IBOutlet UIButton *auditBtn;

/**
 *  停业撤店按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *delateStoreButton;

/**
 *  门头图拍照Img
 */
@property (weak, nonatomic) IBOutlet UIImageView *bigStoreImg;
/**
 *  门头图拍照btn
 */
@property (weak, nonatomic) IBOutlet UIButton *bigStoreButton;

/**
 *  门头图Label
 */
@property (weak, nonatomic) IBOutlet UILabel *storePhotoLabel;

/**
 *  范例按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *exampleButton;
/**
 *  范例Label
 */
@property (weak, nonatomic) IBOutlet UILabel *exampleLabel;

/**
 *  门店类型TextField
 */
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
/**
 *  门店类型Btn
 */
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
/**
 *  门店类型Image
 */
@property (weak, nonatomic) IBOutlet UIImageView *typeButtonImage;

/**
 *  联系人textField
 */
@property (weak, nonatomic) IBOutlet UITextField *connectionName;

/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  门店名称
 */
@property (weak, nonatomic) IBOutlet UITextField *storeNameTextField;
/**
 *  门店后缀
 */
@property (weak, nonatomic) IBOutlet UITextField *extensionsTextField;
/**
 *  门店地址
 */
@property (weak, nonatomic) IBOutlet UITextField *storeAddressTextField;
/**
 *  电话Textfield
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;



/**
 *  头视图
 */
@property (weak, nonatomic) IBOutlet UIView *headView;
/**
 *  隐藏视图
 */
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
/**
 *  错误提示视图
 */
@property (nonatomic, strong) UIView *errorView;

/**
 *  添加分店的模型
 */
@property (nonatomic, strong) ANSubStoreModel *model;

/**
 *  区域地理编码
 */
@property (nonatomic, copy) NSString *adCode;

@property (nonatomic, strong) ANStoreTypeModel *typeModel;
/**
 *  电话处的编辑按钮
 */
@property (weak, nonatomic) IBOutlet UIImageView *phoneEditImg;
/**
 *  联系人处的编辑图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *peopleEditImg;
/**
 *  地址处的编辑图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *addressEditImg;
/**
 *  电话处的编辑按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
/**
 *  联系人的编辑按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *peopleBtn;


@property (weak, nonatomic) IBOutlet UIButton *changAddButton;

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation ANNewStoreViewController


#pragma mark - 地图

/**
 *  初始化地图
 */
- (void)initMapView
{
    [MAMapServices sharedServices].apiKey = LBS_MAP_KEY;
    [AMapSearchServices sharedServices].apiKey = LBS_MAP_KEY;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.mapSuperView.frame), CGRectGetHeight(self.mapSuperView.frame))];
    _mapView.delegate = self;
    
    // 地图缩放级别
    _mapView.zoomLevel = 14.5;
    
    // 是否显示罗盘
    _mapView.showsCompass = NO;
    
    [self.mapSuperView addSubview:_mapView];
    
    // 打开用户定位
    _mapView.showsUserLocation = YES;

}
/**
 *  初始化按钮
 */
- (void)initControls
{
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.frame = CGRectMake(10, CGRectGetHeight(_mapView.bounds) - 50, 40, 40);
    _locationButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
//    _locationButton.backgroundColor = [UIColor whiteColor];
    _locationButton.layer.cornerRadius = 5;
    
    [_locationButton addTarget:self action:@selector(locateAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_locationButton setImage:[UIImage imageNamed:@"location_no"] forState:UIControlStateNormal];
    
    [_mapView addSubview:_locationButton];
    
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    
}

/**
 *  初始化AMapSearchAPI
 */
- (void)initSearch
{
    
    [AMapSearchServices sharedServices].apiKey = LBS_MAP_KEY;
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate  = self;

}
/**
 *  模式转换
 */
- (void)locateAction
{
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow)
    {
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
}

/**
 *  逆地理编码的搜素请求
 */
- (void)reGeoAction
{
    if (_currentLocation)
    {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        
        request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        [_search AMapReGoecodeSearch:request];
    }
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    // 修改定位按钮状态
    if (mode == MAUserTrackingModeNone)
    {
        [_locationButton setImage:[UIImage imageNamed:@"location_no"] forState:UIControlStateNormal];
    }
    else
    {
        [_locationButton setImage:[UIImage imageNamed:@"location_yes"] forState:UIControlStateNormal];
    }
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
//    ANLog(@"userLocation: %@", userLocation.location);
    _currentLocation = [userLocation.location copy];

    [self reGeoAction];
}

/**
 *  点击定位点的回调方法
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    // 选中定位annotation的时候进行逆地理编码查询
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        [self reGeoAction];
    }
}



#pragma mark - AMapSearchDelegate
- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    ANLog(@"request :%@, error :%@", request, error);
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
    NSString *title = response.regeocode.addressComponent.city;
    if (title.length == 0)
    {
        title = response.regeocode.addressComponent.province;
    }
    
    // title 为城市
    _mapView.userLocation.title = title;
    
    // subtitle为地址
    _mapView.userLocation.subtitle = response.regeocode.formattedAddress;

    if (self.changAddButton.selected == YES) {
        self.storeAddressTextField.enabled = NO;
        self.storeAddressTextField.text = response.regeocode.formattedAddress;
    }
    self.adCode = response.regeocode.addressComponent.adcode;
    
    
    
//  ANLog(@"%@, %@", self.adCode, response.regeocode.formattedAddress);

}

#pragma mark ---- 生命周期
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 初始化地图
    [self initMapView];
    
    // 初始化AMapSearchAPI
    [self initSearch];
    
    // 创建定位按钮
    [self initControls];
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
    [MobClick endLogPageView:@"简约新门店创建分店页"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"签约新门店创建分店页"];//("PageOne"为页面名称，可自定义)
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.model = [[ANSubStoreModel alloc] init];
    
    if (self.storeName.length != 0) {
        self.storeNameTextField.text = self.storeName;
        self.storeNameTextField.enabled = NO;
    }
    
    if (self.phoneNumber.length != 0) {
        self.phoneTextField.text = self.phoneNumber;
        self.phoneEditImg.hidden = NO;
    }
    
    if (self.connectionNameStr.length != 0) {
        self.connectionName.text = self.connectionNameStr;
        self.peopleEditImg.hidden = NO;
    }
    
    [self setNavgation];
//    [self setfromControllerString];
    
    
    self.hasStrorImage = NO;
    
    if (fourInch) {
        self.tableView.tableHeaderView.height = 689;
    }else if (fourPointSevenInch) {
        self.tableView.tableHeaderView.height = 763;
    }else if (fivePointFiveInch) {
        self.tableView.tableHeaderView.height = 807;
    }
    
    [ANNotificationCenter addObserver:self selector:@selector(notification:) name:@"type" object:nil];
    [self registerForKeyboardNotifications];
    
    // 判断是不是从总店详情跳过来的
    if (self.isNewStore) {      //如果是通过单例获取类型数据,如果没有,先请求数据
        ANSingleType *singleType = [ANSingleType sharetype];
        if (singleType.dataArr == nil) {                // 无,请求类型数据
            [singleType requestData];
            [singleType typeBlock:^(NSArray *typeArr) {
                self.typeModel = [singleType storeTypeModelWithTypeID:self.typeID];
                self.typeTextField.text = self.typeModel.typeName;
            }];
        }else {                                         // 有,直接根据id获取类型model
            self.typeModel = [singleType storeTypeModelWithTypeID:self.typeID];
            self.typeTextField.text = self.typeModel.typeName;
        }
        self.typeTextField.enabled = NO;
        self.typeButtonImage.image = nil;
        self.typeBtn.enabled = NO;
    }else {
        self.phoneTextField.enabled = NO;
        self.phoneTextField.selected = NO;
        self.phoneEditImg.hidden = YES;
        self.connectionName.enabled = NO;
        self.connectionName.selected = NO;
        self.peopleEditImg.hidden = YES;
    }
}
/**
 *  点击联系电话进入编辑状态
 */
- (IBAction)clickPhoneBtn:(id)sender {
    [self.phoneTextField becomeFirstResponder];
//    self.phoneEditImg.hidden = YES;
}
/**
 *  点击联系人进入编辑状态
 */
- (IBAction)clickPeopleBtn:(id)sender {
    [self.connectionName becomeFirstResponder];
//    self.peopleEditImg.hidden = YES;
}
- (void)notification:(NSNotification *)notification
{
    self.typeTextField.text = notification.userInfo[@"name"];
    self.typeID = notification.userInfo[@"typeID"];
    self.typeName = notification.userInfo[@"name"];
    self.typeModel = [[ANStoreTypeModel alloc] init];
    self.typeModel.typeID = self.typeID;
    self.typeModel.typeName = self.typeName;
//    self.typeBtn.enabled = NO;
}

/**
 *  修改/切换 地址
 */
- (IBAction)changeAddressButtonAction:(UIButton *)sender {
    
    if (sender.selected == YES) {
        sender.selected = NO;
        self.storeAddressTextField.enabled = YES;
        [self.storeAddressTextField becomeFirstResponder];
    } else {
        sender.selected = YES;
    }
}


#pragma mark ---- 自定义方法
// 设置nav
- (void)setNavgation
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnAlterView)];
    // 设置标题
    self.title = @"创建门店";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
// 返回的点击事件
- (void)returnAlterView
{

    self.alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定放弃创建门店吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [self.alertView show];

}
// 完成创建按钮
- (IBAction)clickAuditBtn:(id)sender {
    self.auditBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.auditBtn.enabled = YES;
    });
    if (self.phoneTextField.text.length == 0 || self.typeTextField.text.length == 0 || self.storeNameTextField.text.length == 0 || self.storeAddressTextField.text.length == 0 || self.extensionsTextField.text.length == 0 || self.hasStrorImage == NO) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,你的资料不完整,请完善后再递交。"];
        [self setNavErrorView];
        return;
    }
    
//    if (self.phoneTextField.text.length != 11) {
//        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,你填入的手机号码格式不正确。"];
//        [self setNavErrorView];
//        return;
//    }
    
    self.model.title = self.storeNameTextField.text; // 总店前缀;
    self.model.title_branch = self.extensionsTextField.text; // 分店后缀名;
    self.model.mobile = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""]; // 手机号
    self.model.type = self.typeModel.typeID; // 分店类型
    self.model.address = self.storeAddressTextField.text; // 分店地址
    
    self.model.address_code = self.adCode; // 省市县编码
    self.model.latitude = [NSString stringWithFormat:@"%f", _currentLocation.coordinate.latitude]; // 纬度
    self.model.longitude = [NSString stringWithFormat:@"%f", _currentLocation.coordinate.longitude]; // 经度
    self.model.name = self.connectionName.text; // 分店长姓名
    
    if (self.isDealerNewStore) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确认创建该分店后将下发账号密码至%@",self.phoneTextField.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }else {
        self.addSubStoreBlock(self.model, self);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark ---- 提交分店
/**
 *  提交分店的信息
 */
- (void)postDataAddSubStoreWithOwnerID:(NSString *)ownerID
{
    // 提交分店
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];

    parmDic = [self.model mj_keyValues];
    
    [parmDic setObject:ownerID forKey:@"owner_id"];  // 总店用户ID
    [parmDic setObject:[ANCommon token] forKey:@"token"]; // token
    [parmDic removeObjectForKey:@"imgURL"];
    parmDic = (NSMutableDictionary *)[ANCommon dicToSign:parmDic];
    
    ANLog(@"提交的子门店的数据 : %@", parmDic);
    
    [ANHttpTool postWithUrl:@"/api/1/store/create_store" params:parmDic successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"分店信息 : %@", responseObject);
        ANCustomerSuccessViewController *successVC = [[ANCustomerSuccessViewController alloc] init];
        
        successVC.user_name = responseObject[@"response"][@"user_name"];
        [self.navigationController pushViewController:successVC animated:YES];
        
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"分店信息 : error : %@", responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"分店信息 : fail :%@", error);
    }];
}

- (IBAction)deleteButtonAction:(id)sender {
    
    ANLog(@"停业撤店");
    
}


#pragma mark ----弹出错误视图提示
- (void)setNavErrorView
{
    [self.navigationController.navigationBar addSubview:self.errorView];
    [UIView animateWithDuration:0.5 animations:^{
        self.errorView.y = -20;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(removeError) withObject:self.errorView afterDelay:1];
    }];
}
- (void)removeError
{
    [UIView animateWithDuration:0.5 animations:^{
        self.errorView.height = -64;
    } completion:^(BOOL finished) {
        [self.errorView removeFromSuperview];
    }];
}
#pragma mark ---- 显示或隐藏视图
// 显示范例
- (IBAction)clickHiddenViewBtn:(id)sender {
    self.hiddenView.hidden = NO;
    [self.storeNameTextField resignFirstResponder];
    [self.storeAddressTextField resignFirstResponder];
    [self.extensionsTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
}
// 隐藏范例
- (IBAction)clickHiddenBtn:(id)sender {
    self.hiddenView.hidden = YES;
    [self.storeNameTextField resignFirstResponder];
    [self.storeAddressTextField resignFirstResponder];
    [self.extensionsTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
}
#pragma mark ---- 照相机
// 点击拍照图片
- (IBAction)clickStoreImgBtn:(id)sender {
    ANLog(@"上传门头图");
    [self.storeNameTextField resignFirstResponder];
    [self.storeAddressTextField resignFirstResponder];
    [self.extensionsTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self iconChangeClick];
}
/**
 *  弹出选择器
 */
- (void)iconChangeClick
{
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"拍照(请横向拍摄)", @"从手机相册选择", nil];
    
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0://相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1://相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
                
        }
    }
    else {
        if (buttonIndex == 1) {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        } else {
            return;
        }
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

/**
 *  选择店铺类型
 */
- (IBAction)clickStoreTypeVC:(id)sender {
    
    [self.storeNameTextField resignFirstResponder];
    [self.storeAddressTextField resignFirstResponder];
    [self.extensionsTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    
    ANStoreTypeViewController *storeVC = [[ANStoreTypeViewController alloc] init];
    [self.navigationController pushViewController:storeVC animated:YES];
}


#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    ANLog(@"门头图 : %@", info[UIImagePickerControllerOriginalImage]);
    BOOL isPhotos = NO;
    // 将编辑后的图片写入本地
    if (info[@"UIImagePickerControllerMediaMetadata"]) {    //有这个值是拍摄的
        isPhotos = YES;
    }else {//否则是从相册中选择的
    }

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"headIcon.png"]];
    [UIImagePNGRepresentation(info[UIImagePickerControllerOriginalImage]) writeToFile:imagePath atomically:YES];
    [[NSUserDefaults standardUserDefaults] setObject:imagePath forKey:@"imagePath"];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self postCustomImages:[self compressImage:info[UIImagePickerControllerOriginalImage] toTargetWidth:1008 andIsPhotos:isPhotos] compression:0.3];
    }];

}

- (void)postCustomImages:(UIImage *)image compression:(CGFloat)compression
{
    NSString *imageData = [UIImageJPEGRepresentation(image, compression) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:imageData forKey:@"data"];
    parmDic = (NSMutableDictionary *)[ANCommon dicToSign:parmDic];
    
    [ANHttpTool postWithUrl:@"/api/1/common/upload_img" params:parmDic image:image compression:compression successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"分店图片path : %@", responseObject);
        self.model.cover = responseObject[@"response"][@"img"];
        self.model.imgURL = responseObject[@"response"][@"path"];
        [self.bigStoreImg sd_setImageWithURL:responseObject[@"response"][@"path"]];
        self.hasStrorImage = YES;
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error : %@", responseObject[@"message"]);
        
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"file : %@", error);
        
    }];
}

- (void)addSubStoreBlock:(AddSubStoreBlock)model
{
    self.addSubStoreBlock = model;
}

#pragma mark -- 键盘收缩
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 键盘出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    //使用NSNotificationCenter 键盘隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
- (void)removeForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size; //得到鍵盤的高度
    
    ANLog(@"kbSize : %f, %f", kbSize.width, kbSize.height);
    
    self.view.frame = CGRectMake(0, -kbSize.height + 200, WIDTH, HIGH - 64);

}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    //do something
    self.view.frame = CGRectMake(0, 64, WIDTH, HIGH - 64);
    
}
- (void)dealloc
{
    [self removeForKeyboardNotifications];
    [ANNotificationCenter removeObserver:self];
}

- (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth andIsPhotos:(BOOL)isPhotos{
    CGSize imageSize = sourceImage.size;
    
    UIImage *img = sourceImage;
    
    if (isPhotos) { // 说明是拍摄的
        if (imageSize.width < imageSize.height) {
            img = [UIImage imageWithCGImage:sourceImage.CGImage scale:1 orientation:UIImageOrientationDown];
        }
    }else {//是从相册中选择的
        if (imageSize.width < imageSize.height) {
            img = [UIImage imageWithCGImage:sourceImage.CGImage scale:1 orientation:UIImageOrientationRight];
        }
    }
    
    CGFloat targetHeight = 756;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [img drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 是否需要放弃签约
    if (buttonIndex == 1) {
        if (self.alertView == alertView) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self postDataAddSubStoreWithOwnerID:self.owner_id];
        }
    }
}

@end

//
//  ANSubStoreDetailViewController.m
//  baobaotangDealerAndMarket
//
//  Created by Eric on 15/12/14.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANChangeSubStoreVC.h"
#import "ANHttpTool.h"
#import "ANSubStoreModel.h"
#import "ANSingleType.h"
#import "ANStoreTypeModel.h"
#import "ANCancelStoreViewController.h"
#import "ANAreaListViewController.h"
#import "ANCustomerManageViewController.h"

@interface ANChangeSubStoreVC ()<UIAlertViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

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
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

/**
 *  打电话webView
 */
@property (nonatomic, strong) UIWebView *webView;
/**
 *  是否第一次进来
 */
@property (nonatomic, assign) BOOL isFirst;
/**
 *  是否上传图片
 */
@property (nonatomic, assign) BOOL is_cover;
/**
 *  图片路径
 */
@property (nonatomic, copy) NSString *cover;
@property (weak, nonatomic) IBOutlet UIImageView *phoneEditImg;
/**
 *  修改后缀名btn
 */
@property (weak, nonatomic) IBOutlet UIButton *changeStoreNameBtn;
/**
 *  修改联系电话Btn
 */
@property (weak, nonatomic) IBOutlet UIButton *changePeoplePhoneBtn;
/**
 *  修改联系人电话Btn
 */
@property (weak, nonatomic) IBOutlet UIButton *changePeopleNameBtn;
/**
 *  修改地址Btn
 */
@property (weak, nonatomic) IBOutlet UIButton *changeStoreAddressBtn;

@end

@implementation ANChangeSubStoreVC

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

#pragma mark 修改门店
/**
 *  修改门店后缀名按钮
 */
- (IBAction)clickChangeStoreNameBtn:(id)sender {
    [self.storeSuffixName becomeFirstResponder];
}
/**
 *  修改门店地址按钮
 */
- (IBAction)clickChangeStoreAddressBtn:(id)sender {
    [self.storeAddress becomeFirstResponder];
}
/**
 *  修改联系人电话按钮
 */
- (IBAction)clcikChangePeoplePhoneBtn:(id)sender {
    [self.phoneTextField becomeFirstResponder];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.phoneTextField) {
        NSString *regex = @"^1[3|4|5|7|8]\\d{9}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isValid = [predicate evaluateWithObject:textField.text];
        if (isValid) {
            
        }else {
            [ANCommon setAlertViewWithMessage:@"请输入正确的格式"];
            return NO;
        }
    }
    return YES;
}
/**
 *  修改联系人姓名按钮
 */
- (IBAction)clickChangePeopleNameBtn:(id)sender {
    [self.nameTextField becomeFirstResponder];
}

- (IBAction)clickBottomBtn:(id)sender {
    
    if ([self.storeSuffixName.text isEqualToString:@""]) {
        [ANCommon setAlertViewWithMessage:@"请输入门店后缀名"];
        return;
    }else if ([self.phoneTextField.text isEqualToString:@""]) {
        [ANCommon setAlertViewWithMessage:@"请输入联系电话"];
        return;
    }else if (self.phoneTextField.text.length != 11){
        [ANCommon setAlertViewWithMessage:@"请输入正确的手机号"];
        return;
    }else if ([self.nameTextField.text isEqualToString:@""]) {
        [ANCommon setAlertViewWithMessage:@"请输入联系人姓名"];
        return;
    }else if ([self.storeAddress.text isEqualToString:@""]) {
        [ANCommon setAlertViewWithMessage:@"请输入门店地址"];
        return;
    }
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.storeAddress.text forKey:@"address"];
    if (self.is_cover) {
        [dict setObject:@"1" forKey:@"is_cover"];
        [dict setObject:self.cover forKey:@"cover"];
    }else {
        [dict setObject:@"0" forKey:@"is_cover"];
        [dict setObject:self.subStoreModel.cover forKey:@"cover"];
    }
    [dict setObject:self.nameTextField.text forKey:@"name"];
    [dict setObject:self.storeID forKey:@"store_id"];
    [dict setObject:self.storeSuffixName.text forKey:@"title_branch"];
    [dict setObject:self.phoneTextField.text forKey:@"mobile"];
    
    NSDictionary *params = [ANCommon dicToSign:dict];
//    ANLog(@"%@",params);
    
    [ANHttpTool postWithUrl:@"/api/1/store/update_store_info" params:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
//        ANLog(@"%@",responseObject);
        [[ANCommon alloc] setAlertView:responseObject[@"message"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        });
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
        ANLog(@"%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
}
- (IBAction)clickChangeImgBtn:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self.storeSuffixName resignFirstResponder];
    [self.storeAddress resignFirstResponder];
    [self iconChangeClick];
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
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)parseSubStoreData:(id)data
{
    ANLog(@"%@",data);
    self.subStoreModel = [ANSubStoreModel mj_objectWithKeyValues:data[@"response"]];
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
    self.nameTextField.text = subStoreModel.name;
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
    if ([subStoreModel.store_order isEqualToString:@"1"]) {
        self.changePeoplePhoneBtn.enabled = NO;
        self.phoneTextField.enabled = NO;
        self.phoneEditImg.hidden = YES;
    }
}
#pragma mark 选择照片
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
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    BOOL isPhotos = NO;
    // 将编辑后的图片写入本地
    if (info[@"UIImagePickerControllerMediaMetadata"]) {    //有这个值是拍摄的
        isPhotos = YES;
    }else {//否则是从相册中选择的
    }
    ANLog(@"门头图 : %@", info[UIImagePickerControllerOriginalImage]);
    // 将编辑后的图片写入本地
    //    UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerEditedImage], nil, nil, nil);
    self.subStoreImage.image = [self compressImage:info[UIImagePickerControllerOriginalImage] toTargetWidth:1008 andIsPhotos:isPhotos];
    
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
        [self.subStoreImage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"response"][@"path"]]];
        self.is_cover = YES;
        self.cover = responseObject[@"response"][@"img"];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error : %@", responseObject[@"message"]);
        
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"file : %@", error);
    }];
}
- (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth  andIsPhotos:(BOOL)isPhotos{
    
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
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end

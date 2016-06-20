//
//  ANCustomerDetailViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/2.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANChangeMainStoreVC.h"
#import "ANSubStoreListCell.h"
#import "ANSubStoreDetailViewController.h"
#import "ANNewStoreViewController.h"
#import "ANCustomerSuccessViewController.h"
#import "ANChangeMainStoreVC.h"
#import "ANHttpTool.h"
#import "ANCustomSuperDetailModel.h"        //总店信息model
#import "ANSubStoreModel.h"                 //分店信息model
#import "MBProgressHUD.h"
#import "ANStoreTypeViewController.h"
#import "ANStoreTypeModel.h"


@interface ANChangeMainStoreVC ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 *  tableView头视图
 */
@property (weak, nonatomic) IBOutlet UIView *tableHeadView;
/**
 *  手机号Text
 */
@property (weak, nonatomic) IBOutlet UITextField *userPhoneText;
/**
 *  门店类型视图
 */
@property (weak, nonatomic) IBOutlet UIView *storeTypeView;
/**
 *  营业执照父视图
 */
@property (weak, nonatomic) IBOutlet UIView *businessLicenseView;
/**
 *  营业执照图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *storeImg;
/**
 *  身份证父视图
 */
@property (weak, nonatomic) IBOutlet UIView *cardView;
/**
 *  身份证正面图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *cardUpImg;
/**
 *  身份证反面图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *cardDownImg;
/**
 *  分割视图
 */
@property (weak, nonatomic) IBOutlet UIView *intervalView;
/**
 *  tableView尾视图
 */
@property (weak, nonatomic) IBOutlet UIView *tableFootView;
/**
 *  身份证距营业执照约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCard;
/**
 *  主店Model
 */
@property (nonatomic, strong) ANCustomSuperDetailModel *superModel;

/**
 *  提交审核的父视图
 */
@property (weak, nonatomic) IBOutlet UIView *subAuditButtonSupperView;
/**
 *  执照审核中Label
 */
@property (weak, nonatomic) IBOutlet UILabel *checkingCerLabel;
/**
 *  执照审核成功Image
 */
@property (weak, nonatomic) IBOutlet UIImageView *checkSuccessCerImage;

/**
 *  身份证审核中
 */
@property (weak, nonatomic) IBOutlet UILabel *checkingIDCardLabel;
/**
 *  身份证审核成功Image
 */
@property (weak, nonatomic) IBOutlet UIImageView *checkSuccessIDCardImage;

/**
 *  店名
 */
@property (nonatomic, copy) NSString *storeName;

/**
 *  可编辑商家姓名输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *changeNameTextField;
/**
 *  可编辑店铺姓名输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *changeStoreNameTextField;
/**
 *  可编辑店铺类型Label
 */
@property (weak, nonatomic) IBOutlet UILabel *changeStoreTypeLabel;
/**
 *  可编辑店铺类型Btn
 */
@property (weak, nonatomic) IBOutlet UIButton *changeTypeBtn;
/**
 *  图片数组
 */
@property (nonatomic, strong) NSArray *imgArr;
/**
 *  img数组中的下标
 */
@property (nonatomic, assign) NSInteger imageIndex;
/**
 *  营业执照视图是否添加
 */
@property (nonatomic, assign) BOOL is_cert_company;
/**
 *  营业执照url
 */
@property (nonatomic, copy) NSString *cert_company;
/**
 *  身份证正面是否添加
 */
@property (nonatomic, assign) BOOL is_cert_idcard_front;
/**
 *  身份证正面url
 */
@property (nonatomic, copy) NSString *cert_idcard_front;
/**
 *  身份证反面是否添加
 */
@property (nonatomic, assign) BOOL is_cert_idcard_back;
/**
 *  身份证反面url
 */
@property (nonatomic, copy) NSString *cert_idcard_back;
/**
 *  类型ID
 */
@property (nonatomic, copy) NSString *typeID;
/**
 *  类型名称
 */
@property (nonatomic, copy) NSString *typeName;
/**
 *  类型model
 */
@property (nonatomic, strong) ANStoreTypeModel *typeModel;


@end

@implementation ANChangeMainStoreVC

- (NSArray *)imgArr
{
    if (_imgArr == nil) {
        _imgArr = [NSArray arrayWithObjects:self.storeImg, self.cardUpImg, self.cardDownImg, nil];
    }
    return _imgArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"门店详情页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"门店详情页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];

    if (HIGH == 480) {
        self.tableView.tableHeaderView.height = 661;
    }else if (HIGH == 568) {
        self.tableView.tableHeaderView.height = 661;
    }else if (HIGH == 667) {
        self.tableView.tableHeaderView.height = 725;
    }
    [ANNotificationCenter addObserver:self selector:@selector(changeStoreType:) name:@"type" object:nil];
    // 数据请求
    [self requestData];
}
#pragma mark ----自定义方法
// 设置nav
- (void)setNavgation
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"修改信息";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ----tableViewDelegate
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
    [self.navigationController pushViewController:subStoreDetail animated:YES];
}
#pragma mark 编辑模块
/**
 *  点击了修改门店类型
 */
- (IBAction)clickStoreTypeBtn:(UIButton *)btn
{
    ANStoreTypeViewController *storeVC = [[ANStoreTypeViewController alloc] init];
    [self.navigationController pushViewController:storeVC animated:YES];
}
/**
 *  营业执照
 */
- (IBAction)clickFirstImgBtn:(id)sender {
    [self resignTextFieldFirstResponder];
    self.imageIndex = 0;
    [self iconChangeClick];
}
/**
 *  身份证正面
 */
- (IBAction)clickSecondImgBtn:(id)sender {
    [self resignTextFieldFirstResponder];
    self.imageIndex = 1;
    [self iconChangeClick];
}
/**
 *  身份证反面
 */
- (IBAction)clickThrdImgBtn:(id)sender {
    [self resignTextFieldFirstResponder];
    self.imageIndex = 2;
    [self iconChangeClick];
}
- (void)resignTextFieldFirstResponder
{
    [self.changeNameTextField resignFirstResponder];
    [self.changeStoreNameTextField resignFirstResponder];
}
- (void)changeStoreType:(NSNotification *)notification
{
    self.changeStoreTypeLabel.text = notification.userInfo[@"name"];
    self.typeID = notification.userInfo[@"typeID"];
    self.typeName = notification.userInfo[@"name"];
    self.typeModel = [[ANStoreTypeModel alloc] init];
    self.typeModel.typeID = self.typeID;
    self.typeModel.typeName = self.typeName;
}

- (void)requestChangeData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.changeNameTextField.text forKey:@"name"];
    [dict setObject:self.owner_id forKey:@"owner_id"];
    [dict setObject:self.changeStoreNameTextField.text forKey:@"title"];
    [dict setObject:self.typeModel.typeID forKey:@"type"];
    [dict setObject:self.superModel.cert_type forKey:@"cert_type"];
    if (self.is_cert_company) {
        [dict setObject:@"1" forKey:@"is_cert_company"];
        [dict setObject:@"0" forKey:@"cert_type"];
    }else {
        [dict setObject:@"0" forKey:@"is_cert_company"];
    }
    if (self.is_cert_idcard_front) {
        [dict setObject:@"1" forKey:@"is_cert_idcard_front"];
    }else {
        [dict setObject:@"0" forKey:@"is_cert_idcard_front"];
    }
    if (self.is_cert_idcard_back) {
        [dict setObject:@"1" forKey:@"is_cert_idcard_back"];
    }else {
        [dict setObject:@"0" forKey:@"is_cert_idcard_back"];
    }
    [dict setObject:self.cert_company forKey:@"cert_company"];
    [dict setObject:self.cert_idcard_front forKey:@"cert_idcard_front"];
    [dict setObject:self.cert_idcard_back forKey:@"cert_idcard_back"];
    
    NSDictionary *params = [ANCommon dicToSign:dict];
    
    
    [ANHttpTool postWithUrl:@"/api/1/store/update_user_store" params:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
//        ANLog(@"%@",responseObject);
        [[ANCommon alloc] setAlertView:@"修改成功"];
        [ANNotificationCenter postNotificationName:@"changeRequest" object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        });

    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
//        ANLog(@"%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
}

/**
 *  提交修改
 */
- (IBAction)submitAuditAction:(id)sender {
    ANLog(@"递交审核 : owner_id : %@", self.owner_id);
    if ([self.changeStoreNameTextField.text isEqualToString:@""]) {
        [ANCommon setAlertViewWithMessage:@"店铺名称不能为空"];
        return;
    }else if ([self.changeNameTextField.text isEqualToString:@""]) {
        [ANCommon setAlertViewWithMessage:@"掌柜姓名不能为空"];
        return;
    }
    [self requestChangeData];
}


#pragma mark ---- 网络请求
- (void)requestData
{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    
    [parmDic setObject:self.owner_id forKey:@"owner_id"];
    parmDic = (NSMutableDictionary *)[ANCommon dicToSign:parmDic];
    
    [ANHttpTool postWithUrl:@"/api/1/store/get_user_store" params:parmDic successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
//        ANLog(@"%@", responseObject[@"message"]);
        [self parseSuperStoreData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject[@"message"]);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
// 解析主店信息
- (void)parseSuperStoreData:(id)data
{
//    ANLog(@"总店 data : %@", data);
    NSDictionary *tempDic = data[@"response"];
    self.superModel = [ANCustomSuperDetailModel mj_objectWithKeyValues:tempDic];
}
// 设置主店信息
- (void)setSuperModel:(ANCustomSuperDetailModel *)superModel
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    if (_superModel != superModel) {
        _superModel = superModel;
    }
    self.userPhoneText.text = superModel.mobile;
    self.changeNameTextField.text = superModel.name;
    self.changeStoreNameTextField.text = superModel.title;
    self.changeStoreTypeLabel.text = superModel.type_str;
    
    self.typeModel = [[ANStoreTypeModel alloc] init];
    self.typeModel.typeID = superModel.type;
    self.typeModel.typeName = superModel.type_str;
    self.typeName = superModel.type_str;
    self.typeID = superModel.type;
    
    [self.storeImg sd_setImageWithURL:[NSURL URLWithString:superModel.cert_company] placeholderImage:[UIImage imageNamed:@"customer_licence"]];
    [self.cardUpImg sd_setImageWithURL:[NSURL URLWithString:superModel.cert_idcard_front] placeholderImage:[UIImage imageNamed:@"customer_card"]];
    [self.cardDownImg sd_setImageWithURL:[NSURL URLWithString:superModel.cert_idcard_back] placeholderImage:[UIImage imageNamed:@"customer_card"]];
    
    self.cert_company = superModel.cert_company;
    self.cert_idcard_back = superModel.cert_idcard_back;
    self.cert_idcard_front = superModel.cert_idcard_front;
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
    UIImageView *imageView = self.imgArr[self.imageIndex];
    imageView.image = [self compressImage:info[UIImagePickerControllerOriginalImage] toTargetWidth:1008 andIsPhotos:isPhotos];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"headIcon.png"]];
    [UIImagePNGRepresentation(info[UIImagePickerControllerOriginalImage]) writeToFile:imagePath atomically:YES];
    [[NSUserDefaults standardUserDefaults] setObject:imagePath forKey:@"imagePath"];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self postCustomImages:imageView.image compression:0.3];
    }];
}
/**
 *  裁剪图片
 *
 *  @param sourceImage 要裁剪的图片
 *  @param targetWidth 裁剪后的宽
 *  @param isPhotos    是否从相册总选择的 yes是no不是
 *
 *  @return 裁剪后的图片
 */
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
- (void)postCustomImages:(UIImage *)image compression:(CGFloat)compression
{
    NSString *imageData = [UIImageJPEGRepresentation(image, compression) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:imageData forKey:@"data"];
    parmDic = (NSMutableDictionary *)[ANCommon dicToSign:parmDic];
    
    [ANHttpTool postWithUrl:@"/api/1/common/upload_img" params:parmDic image:image compression:compression successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"分店图片path : %@", responseObject);
        if (self.imageIndex == 0) {
            self.is_cert_company = YES;
            self.cert_company = responseObject[@"response"][@"img"];
        }else if (self.imageIndex == 1) {
            self.is_cert_idcard_front = YES;
            self.cert_idcard_front = responseObject[@"response"][@"img"];
        }else {
            self.is_cert_idcard_back = YES;
            self.cert_idcard_back = responseObject[@"response"][@"img"];
        }
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error : %@", responseObject[@"message"]);
        
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"file : %@", error);
        
    }];
}


@end

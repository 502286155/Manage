//
//  ANSignedViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/24.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANSignedViewController.h"
#import "ANCustomerSuccessViewController.h"
#import "ANNewStoreViewController.h"
#import "ANSubStoreListCell.h"
#import "ANSubStoreModel.h"
#import "ANHttpTool.h"

@interface ANSignedViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ANSubStoreListCellDelegate, UIAlertViewDelegate>


/**
 *  营业执照按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *businessLicenseButton;
/**
 *  营业执照按钮Icon
 */
@property (weak, nonatomic) IBOutlet UIImageView *businessLicenseIcon;


/**
 *  身份证按钮父视图
 */
@property (weak, nonatomic) IBOutlet UIView *cardIDButtonSupperView;

/**
 *  身份证按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cardIDButton;

/**
 *  身份证按钮Icon
 */
@property (weak, nonatomic) IBOutlet UIImageView *cardIDIcon;

/**
 *  营业执照拍照视图
 */
@property (weak, nonatomic) IBOutlet UIView *businessLicensePhotographView;

/**
 *  身份证拍照视图
 */
@property (weak, nonatomic) IBOutlet UIView *cardIDPhotographView;

/**
 *  添加门店的父视图
 */
@property (weak, nonatomic) IBOutlet UIView *addStoreSupperView;

/**
 *  添加门店按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *addStoreBtn;

/**
 *  手机/账号
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
/**
 *  商家姓名
 */
@property (weak, nonatomic) IBOutlet UITextField *storeNameTextField;


/**
 *  添加分店
 */
@property (weak, nonatomic) IBOutlet UIButton *auditBtn;
/**
 *  背景阴影
 */
@property (weak, nonatomic) IBOutlet UIView *shadowView;
/**
 *  身份证范例视图
 */
@property (weak, nonatomic) IBOutlet UIView *shadowCardView;
/**
 *  隐藏身份证范例视图按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *removeCardViewBtn;
/**
 *  营业执照视图
 */
@property (weak, nonatomic) IBOutlet UIView *shadowStoreView;
/**
 *  存放营业执照的img
 */
@property (weak, nonatomic) IBOutlet UIImageView *stroeImg;
/**
 *  存放正面身份证的IMG
 */
@property (weak, nonatomic) IBOutlet UIImageView *upCardImg;
/**
 *  存放反面身份证的img
 */
@property (weak, nonatomic) IBOutlet UIImageView *downCardImg;
/**
 *  上传正面身份证的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *upCardImgBtn;
/**
 *  上传反面身份证的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *downCardImgBtn;

/**
 *  隐藏营业执照范例按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *removeStoreViewBtn;
/**
 *  头部的最下方视图
 */
@property (weak, nonatomic) IBOutlet UIView *headBottomView;
/**
 *  tableView的头视图
 */
@property (weak, nonatomic) IBOutlet UIView *headTableView;
/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footView;

/**
 *  分店的数据
 */
@property (nonatomic, strong) NSArray *dataArray;

/**
 *  存放需要上传的img数组
 */
@property (nonatomic, strong) NSArray *imgArr;
/**
 *  img数组中的下标
 */
@property (nonatomic, assign) NSInteger imageIndex;
/**
 *  营业执照视图是否添加
 */
@property (nonatomic, assign) BOOL isStoreImg;
/**
 *  身份证正面是否添加
 */
@property (nonatomic, assign) BOOL isCardUpImg;
/**
 *  身份证反面是否添加
 */
@property (nonatomic, assign) BOOL isCardDownImg;
/**
 *  区头的高度
 */
@property (nonatomic, assign) float sectionHeight;
/**
 *  错误提示视图
 */
@property (nonatomic, strong) UIView *errorView;

@property (nonatomic, strong) ANSubStoreModel *addSubStoreModel;

@property (nonatomic, strong) NSLayoutConstraint *cardTopC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCard;

/**
 *  营业执照图片
 */
@property (nonatomic, copy) NSString *cert_company;
/**
 *  身份证正面照片
 */
@property (nonatomic, copy) NSString *cert_idcard_front;
/**
 *  身份证反面照片
 */
@property (nonatomic, copy) NSString *cert_idcard_back;
/**
 *  证件类型 (0:公司执照+身份证 1:身份证)
 */
@property (nonatomic, assign) NSInteger cert_type;
/**
 *  仅身份证按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *onlyCardBtn;
/**
 *  营业执照与身份证都传的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *allStroebtn;
/**
 *  是否保留信息
 */
@property (nonatomic, assign) BOOL isPreserve;
/**
 *  保留的签约门店信息控制器
 */
@property (nonatomic, strong) ANNewStoreViewController *StoreVC;


@end

@implementation ANSignedViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"签约新门店创建总店页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"签约新门店创建总店页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    [self setNavgation];
    
    self.cert_type = 0;

    if (HIGH == 480) {
        self.sectionHeight = 715;
    }else if (HIGH == 568) {
        self.sectionHeight = 715;
    }else if (HIGH == 667) {
        self.sectionHeight = 779;
    }else {
        self.sectionHeight = 824;
    }
    self.tableView.tableHeaderView.height = 0;

}

- (NSArray *)imgArr
{
    if (_imgArr == nil) {
        _imgArr = [NSArray arrayWithObjects:self.stroeImg, self.upCardImg, self.downCardImg, nil];
    }
    return _imgArr;
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
    self.title = @"签约主体";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  递交审核按钮
 */
- (IBAction)clickAuditBtn:(id)sender {
    [self resignTextFieldFirstResponder];
    ANLog(@"提交审核");
    
    ANLog(@"\n营业执照%@;\n身份证正面照%@;\n身份证反面照%@;\n证件类型%ld;\n手机号%@;\n负责人姓名%@;", self.cert_company, self.cert_idcard_front, self.cert_idcard_back, self.cert_type, self.phoneTextField.text, self.storeNameTextField.text);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认递交审核后将开通掌柜账户 请协助掌柜安装客户端" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.auditBtn.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.auditBtn.enabled = YES;
        });
        if ([self setWarning]) {
            // 提交总店 (获取owner_id)
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:[ANCommon token] forKey:@"token"];
            if (self.cert_type == 0) {
                if (self.cert_company) {
                    [parmDic setObject:self.cert_company forKey:@"cert_company"];  // 营业执照
                } else {
                    [parmDic setObject:@"" forKey:@"cert_company"];  // 营业执照
                }
            }
            if (self.cert_idcard_front) {
                [parmDic setObject:self.cert_idcard_front forKey:@"cert_idcard_front"];  // 身份证正面照
            } else {
                [parmDic setObject:@"" forKey:@"cert_idcard_front"];  // 身份证正面照
            }
            if (self.cert_idcard_back) {
                [parmDic setObject:self.cert_idcard_back forKey:@"cert_idcard_back"]; // 身份证反面照
            } else {
                [parmDic setObject:@"" forKey:@"cert_idcard_back"]; // 身份证反面照
            }
            [parmDic setObject:[NSString stringWithFormat:@"%ld", self.cert_type] forKey:@"cert_type"]; // 证件类型
            [parmDic setObject:@"" forKey:@"title"];
            
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            tempDict = [self.addSubStoreModel mj_keyValues];
            [parmDic addEntriesFromDictionary:tempDict];
            [parmDic setObject:[self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"mobile"]; // 手机号
            [parmDic setObject:self.storeNameTextField.text forKey:@"name"]; // 负责人姓名
            [parmDic removeObjectForKey:@"imgURL"];
            [parmDic removeObjectForKey:@"device_num"];
            parmDic = (NSMutableDictionary *)[ANCommon dicToSign:parmDic];
            
            ANLog(@"这是啥 : %@", parmDic);
            
            [ANHttpTool postWithUrl:@"/api/1/store/create_new_user_store" params:parmDic successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
                ANLog(@"分店信息 : %@", responseObject);
                ANCustomerSuccessViewController *successVC = [[ANCustomerSuccessViewController alloc] init];
                
                successVC.user_name = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                [self.navigationController pushViewController:successVC animated:YES];
            } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
                ANLog(@"总店信息 : error : %@", responseObject);
                [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
            } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
                ANLog(@"总店信息 : fail :%@", error);
            }];
        }
    }
}
/**
 *  提交分店的信息
 */
- (void)postDataAddSubStoreWithOwnerID:(NSString *)ownerID
{
    // 提交分店
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    parmDic = [self.addSubStoreModel mj_keyValues];
    
    [parmDic setObject:ownerID forKey:@"owner_id"];  // 总店用户ID
    [parmDic setObject:[ANCommon token] forKey:@"token"]; // token
    [parmDic removeObjectForKey:@"imgURL"];
    parmDic = (NSMutableDictionary *)[ANCommon dicToSign:parmDic];
    
    ANLog(@"提交的子门店的数据 : %@", parmDic);
    
    [ANHttpTool postWithUrl:@"/api/1/store/create_store" params:parmDic successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"分店信息 : %@", responseObject);
        ANCustomerSuccessViewController *successVC = [[ANCustomerSuccessViewController alloc] init];
        
        successVC.user_name = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self.navigationController pushViewController:successVC animated:YES];
        
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"分店信息 : error : %@", responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"分店信息 : fail :%@", error);
    }];
}

/**
 *  添加分店按钮
 */
- (IBAction)clickAddStoreBtn:(id)sender {
    ANLog(@"添加分店");
    [self resignTextFieldFirstResponder];
    self.addStoreBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.addStoreBtn.enabled = YES;
    });
    
    if ([self.phoneTextField.text isEqualToString:@""]) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,你的签约主体手机号还未填写"];
        [self setNavErrorView];
        return ;
    }
    if ([self.storeNameTextField.text isEqualToString:@""]) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,你的掌柜姓名还未填写"];
        [self setNavErrorView];
        return ;
    }
    
    
    ANNewStoreViewController *newStore = [[ANNewStoreViewController alloc] init];
    
    newStore.phoneNumber = [self.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    newStore.connectionNameStr = self.storeNameTextField.text;
    
    [newStore addSubStoreBlock:^(ANSubStoreModel *model, ANNewStoreViewController *storeVC) {
        
        self.isPreserve = YES;
        self.StoreVC = storeVC;
        
        self.addSubStoreModel = model;
        
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:model];
        self.dataArray = arr;
        [self.tableView reloadData];
        ANLog(@"回调门店 : %@, %@, %@ ,%@", model.cover, model.title, model.title_branch,model.type);
        self.tableView.tableFooterView = nil;
    }];
    [self.navigationController pushViewController:newStore animated:YES];
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

#pragma mark - 认证类型切换
/**
 *  营业执照 + 身份证
 */
- (IBAction)businessLicenseButtonAction:(id)sender {
    self.onlyCardBtn.enabled = YES;
    self.allStroebtn.enabled = NO;
    
    [self resignTextFieldFirstResponder];
    self.businessLicenseIcon.image = [UIImage imageNamed:@"customer_select"];
    self.cardIDIcon.image = [UIImage imageNamed:@"customer_unSelect"];
    self.businessLicensePhotographView.hidden = NO;
    self.cert_type = 0;
    if (HIGH == 480) {
        self.sectionHeight = 715;
    }else if (HIGH == 568) {
        self.sectionHeight = 715;
    }else if (HIGH == 667) {
        self.sectionHeight = 779;
    }else {
        self.sectionHeight = 824;
    }
    [self.headTableView removeConstraint:self.cardTopC];
    [self.headTableView addConstraint:self.constraintCard];
    [self.tableView reloadData];
}

/**
 *  仅身份证
 */
- (IBAction)cardIDButtonAction:(id)sender {
    self.onlyCardBtn.enabled = NO;
    self.allStroebtn.enabled = YES;
    
    [self resignTextFieldFirstResponder];
    self.cardIDIcon.image = [UIImage imageNamed:@"customer_select"];
    self.businessLicenseIcon.image = [UIImage imageNamed:@"customer_unSelect"];
    self.businessLicensePhotographView.hidden = YES;
    self.cert_type = 1;

    self.cardIDPhotographView.y = CGRectGetMaxY(self.cardIDButtonSupperView.frame);
    self.headBottomView.y = CGRectGetMaxY(self.cardIDPhotographView.frame);
    
    if (HIGH == 480) {
        self.sectionHeight = 715 - self.businessLicensePhotographView.height - 21;
    }else if (HIGH == 568) {
        self.sectionHeight = 715 - self.businessLicensePhotographView.height - 21;
    }else if (HIGH == 667) {
        self.sectionHeight = 779 - self.businessLicensePhotographView.height - 21;
    }else {
        self.sectionHeight = 824 - self.businessLicensePhotographView.height - 21;
    }
    
    self.cardIDPhotographView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *blueTop = [NSLayoutConstraint constraintWithItem:self.cardIDPhotographView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cardIDButtonSupperView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    self.cardTopC = blueTop;
    [self.headTableView removeConstraint:self.constraintCard];
    [self.headTableView addConstraint:blueTop];
    
    [self.tableView reloadData];
}

// 点击营业执照范例Btn
- (IBAction)clickLicenceBtn:(id)sender {
    self.shadowView.hidden = NO;
    self.shadowStoreView.hidden = NO;
    [self resignTextFieldFirstResponder];
    
}

// 点击身份证范例Btn
- (IBAction)clickCardBtn:(id)sender {
    self.shadowView.hidden = NO;
    self.shadowCardView.hidden = NO;
    [self resignTextFieldFirstResponder];
}

// 点击空白阴影隐藏
- (IBAction)clickShadowView:(id)sender {
    self.shadowView.hidden = YES;
    self.shadowCardView.hidden = YES;
    self.shadowStoreView.hidden = YES;
    [self resignTextFieldFirstResponder];
}

// 点击隐藏身份证视图按钮
- (IBAction)clickRemovewCardBtn:(id)sender {
    self.shadowView.hidden = YES;
    self.shadowCardView.hidden = YES;
    [self resignTextFieldFirstResponder];
}

// 点击隐藏企业执照视图按钮
- (IBAction)clickRemovewStoreBtn:(id)sender {
    self.shadowView.hidden = YES;
    self.shadowStoreView.hidden = YES;
    [self resignTextFieldFirstResponder];
}
#pragma mark ---- UITableViewDelegate
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
    ANSubStoreModel *model = self.dataArray[indexPath.row];
    model.device_num = @"0";
    cell.model = model;
    cell.delegate = self;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.headTableView.hidden = NO;
    return self.headTableView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.sectionHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:self.StoreVC animated:YES];
}

#pragma mark -- cell的代理方法
- (void)subStoreListCell:(ANSubStoreListCell *)cell clickPhone:(NSString *)phone
{
    ANLog(@"打电话 : %@", phone);
}

#pragma mark ----拍照上传
- (IBAction)clickUpCardBtn:(id)sender {
    ANLog(@"上传正面身份证");
    [self resignTextFieldFirstResponder];
    self.imageIndex = 1;
    [self iconChangeClick];
}
- (IBAction)clickDownCardBtn:(id)sender {
    ANLog(@"上传反面身份证");
    [self resignTextFieldFirstResponder];
    self.imageIndex = 2;
    [self iconChangeClick];
}
// 点击上传营业执照
- (IBAction)clickStoreImgBtn:(id)sender {
    ANLog(@"上传营业执照");
    [self resignTextFieldFirstResponder];
    self.imageIndex = 0;
    [self iconChangeClick];
}
- (void)resignTextFieldFirstResponder
{
    [self.storeNameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
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

/**
 *  选择拍照/相册选择
 */
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
    UIImageView *imageView = self.imgArr[self.imageIndex];
    imageView.image = [self compressImage:info[UIImagePickerControllerOriginalImage] toTargetWidth:1008 andIsPhotos:isPhotos];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"headIcon.png"]];
    [UIImagePNGRepresentation(imageView.image) writeToFile:imagePath atomically:YES];
    [[NSUserDefaults standardUserDefaults] setObject:imagePath forKey:@"imagePath"];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self postCustomImages:imageView.image indexImage:self.imageIndex compression:0.3];
    }];
    if (self.imageIndex == 0) {
        self.isStoreImg = YES;
    }else if (self.imageIndex == 1) {
        self.isCardUpImg = YES;
    }else {
        self.isCardDownImg = YES;
    }
}

/**
 *  设置警告框
 */
- (BOOL)setWarning
{
    if (self.storeNameTextField.text.length == 0) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,你的签约主体姓名未填写,请完善后再递交。"];
        [self setNavErrorView];
        return NO;
    }
    if (self.phoneTextField.text.length == 0) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,你的签约主体手机号未填写,请完善后再递交。"];
        [self setNavErrorView];
        return NO;
    }
    if (self.phoneTextField.text.length != 11) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,你填入的手机号码格式不正确。"];
        [self setNavErrorView];
        return NO;
    }
    
    if (self.dataArray.count == 0) {
        self.errorView = [ANCommon errorViewWithColor:ErrorViewColor Message:@"伙伴,请创建门店后提交。"];
        [self setNavErrorView];
        return NO;
    }
    return YES;
}

/**
 *  提交图片获取图片url
 *
 *  @param image       提交的图片
 *  @param indexImage  图片的序号
 *  @param compression 图片的压缩比例 0--1 (1表示不压缩)
 */
- (void)postCustomImages:(UIImage *)image indexImage:(NSInteger)indexImage compression:(CGFloat)compression
{
    NSString *imageData = [UIImageJPEGRepresentation(image, compression) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:imageData forKey:@"data"];
    parmDic = (NSMutableDictionary *)[ANCommon dicToSign:parmDic];
    
    [ANHttpTool postWithUrl:@"/api/1/common/upload_img" params:parmDic image:image compression:compression successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"responseObject : %@", responseObject);
        if (self.imageIndex == 0) {
            self.cert_company = responseObject[@"response"][@"img"];
        } else if (self.imageIndex == 1) {
            self.cert_idcard_front = responseObject[@"response"][@"img"];
        } else if (self.imageIndex == 2) {
            self.cert_idcard_back = responseObject[@"response"][@"img"];
        }
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"图片error : %@", responseObject[@"message"]);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"图片file : %@", error);
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

@end

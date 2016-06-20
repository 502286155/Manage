//
//  ANPriceAdjustmentViewController.m
//  baobaotangDealerAndMarket
//
//  Created by Eric on 15/12/10.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANPriceAdjustmentViewController.h"
#import "ANPriceAdjustmentCell.h"
#import "ANSubPriceAdjustmentViewController.h"
#import "ANPurchasesModel.h"
#import "ANNewPurchasesModel.h"
#import "ANHttpTool.h"

@interface ANPriceAdjustmentViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  价格增减幅度Label
 */
@property (weak, nonatomic) IBOutlet UILabel *priceRangeLabel;

/**
 *  价格增减幅度textfield
 */
@property (weak, nonatomic) IBOutlet UITextField *priceRangeTextField;

/**
 *  减价按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *minusPriceButton;

/**
 *  加价按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *plusPriceButton;

/**
 *  价格浮动
 */
@property (nonatomic, assign) float priceRang;

/**
 *  门店名称
 */
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
/**
 *  门店数量
 */
@property (weak, nonatomic) IBOutlet UILabel *storeCountLabel;

/**
 *  手机号码
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

/**
 *  通知视图
 */
@property (weak, nonatomic) IBOutlet UIView *noticePhoneView;

@end

@implementation ANPriceAdjustmentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"统一调价页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"统一调价页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavgation];

    self.priceRangeLabel.layer.borderWidth = 1;
    self.priceRangeLabel.layer.borderColor = ANColor(209, 210, 204).CGColor;
    self.priceRangeLabel.layer.cornerRadius = 4;
}
- (void)setValue
{
    self.storeNameLabel.text = self.storeName;
    self.storeCountLabel.text = [NSString stringWithFormat:@"该掌柜%@家门店所选%@件商品", self.storeCount,self.goodsCount];
    self.phoneNumberLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"dealer_mobile"];
    
    if (5 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"] integerValue]) {
        self.noticePhoneView.hidden = YES;
    }
}
// 设置nav
- (void)setNavgation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"调整价格";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANPriceAdjustmentCell *cell = [ANPriceAdjustmentCell priceAdjustmentWithCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

/**
 *  减价事件
 */
- (IBAction)minusPriceAction:(id)sender {
    
    [self.priceRangeTextField resignFirstResponder];
    ANLog(@"减价");
    self.priceRang = self.priceRang - 1.0;
    
}

/**
 *  加价事件
 */
- (IBAction)plusPriceAction:(id)sender {
    
    [self.priceRangeTextField resignFirstResponder];
    ANLog(@"加价");
    self.priceRang = self.priceRang + 1.0;
}

- (void)changeAllPrice:(float)range
{
    for (int i = 0; i < self.dataArray.count; i++) {
        ANNewPurchasesModel *newModel = self.dataArray[i];
        newModel.skuList.price = [NSString stringWithFormat:@"%.1f",[newModel.skuList.price floatValue] + range];
    }
}

- (void)setPriceRang:(float)priceRang
{
    if (_priceRang != priceRang) {
        _priceRang = priceRang;
    }
    self.priceRangeTextField.text = [NSString stringWithFormat:@"%.1f", _priceRang];
    
    if (_priceRang == -10000) {
        self.minusPriceButton.enabled = NO;
        [self.minusPriceButton setImage:[UIImage imageNamed:@"minus_unselected"] forState:UIControlStateNormal];
    } else if (_priceRang == 10000) {
        self.plusPriceButton.enabled = NO;
        [self.plusPriceButton setImage:[UIImage imageNamed:@"plus_unselected"] forState:UIControlStateNormal];
    } else {
        self.plusPriceButton.enabled = YES;
        self.minusPriceButton.enabled = YES;
        [self.minusPriceButton setImage:[UIImage imageNamed:@"minus_selected"] forState:UIControlStateNormal];
        [self.plusPriceButton setImage:[UIImage imageNamed:@"plus_selected"] forState:UIControlStateNormal];
    }
    
}
/**
 *  点击空白处取消点击事件
 */
- (IBAction)clickCancleBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(refreshData:)]) {
        [self.delegate refreshData:@""];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.priceRang = [textField.text floatValue];
}

/**
 *  完成改价
 */
- (IBAction)submitPriceChangeAction:(id)sender {
    ANLog(@"完成改价");
    [self changeAllPrice:_priceRang];
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:@"确认改价并立即显示在掌柜全部门店端" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alterView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (ANNewPurchasesModel *model in self.dataArray) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:model.skuList.price forKey:@"edit_price"];
            [dic setObject:model.skuList.goods_id forKey:@"goods_id"];
            [dic setObject:model.skuList.sku_id forKey:@"sku_id"];
            [tempArr addObject:dic];
        }
        [self changeAllGoodsPriceRequest:[tempArr mj_JSONString]];
    }
}
/**
 *  批量改价发起请求
 */
- (void)changeAllGoodsPriceRequest:(NSString *)jsonString
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:self.store_id forKey:@"store_id"];
    [parmDict setObject:jsonString forKey:@"goods_list"];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    ANLog(@"%@", parmDict);
    
    [ANHttpTool postWithUrl:@"/api/1/dealers/edit_goods_price" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"--hha : %@", responseObject);
        [[ANCommon alloc] setAlertView:@"改价成功"];
        if ([self.delegate respondsToSelector:@selector(refreshData:)]) {
            [self.delegate refreshData:@"1"];
        }
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"responseObject:%@",responseObject[@"message"]);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"error:%@",error);
    }];
}

/**
 *  限制输入小数点后两位
 */
bool isAdiustDian = NO;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isAdiustDian = NO;
    }
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length] == 0) {
                if(single == '.' || single == '0') {
                    
                    textField.text = @"0.";
                    isAdiustDian = YES;
                    return NO;
                }
            }

            if (single == '.') {
                if(!isAdiustDian) { //text中还没有小数点
                
                    isAdiustDian = YES;
                    return YES;
                } else {
                    //                    [self alertView:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            } else {
                if (isAdiustDian) {//存在小数点
                
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    int tt = (int)range.location - (int)ran.location;
                    if (tt <= 1) {
                        return YES;
                    } else {
                        //                        [self alertView:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                } else {
                    
                    return YES;
                }
            }
        } else {//输入的数据格式不正确
            //            [self alertView:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    } else {
        return YES;
    }
}

@end

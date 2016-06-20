//
//  ANCustomerManageCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/24.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANCustomerManageCell.h"

@interface ANCustomerManageCell()

@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkInBtn;
@property (nonatomic, strong) ANCustomerModel *customerModel;
@property (nonatomic, strong) ANSubStoreModel *subStoreModel;
/**
 *  门头图
 */
@property (weak, nonatomic) IBOutlet UIImageView *storeImg;
/**
 *  名称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  分店数量
 */
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
/**
 *  状态
 */
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
/**
 *  积分
 */
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNum;


@end

@implementation ANCustomerManageCell

+ (instancetype)customermanageTabelView:(UITableView *)tableView
{
    ANCustomerManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customerManageCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANCustomerManageCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    self.phoneBtn = [ANCommon setBtnRadiusAndBorder:self.phoneBtn];
    self.checkInBtn = [ANCommon setBtnRadiusAndBorder:self.checkInBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModelDic:(NSDictionary *)modelDic
{
    if (_modelDic != modelDic) {
        _modelDic = modelDic;
    }
    self.customerModel = modelDic[@"user_store"];
    self.subStoreModel = modelDic[@"store"];
    
    [self.storeImg sd_setImageWithURL:[NSURL URLWithString:self.subStoreModel.cover] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    self.nameLabel.text = self.subStoreModel.title;
    self.numLabel.text = self.customerModel.store_num;
    
    if ([self.subStoreModel.status isEqualToString:@"1"]) {
        self.statusLabel.text = @"试营";
    } else if ([self.subStoreModel.status isEqualToString:@"2"]) {
        self.statusLabel.text = @"正常运营";
    } else if ([self.subStoreModel.status isEqualToString:@"3"]) {
        self.statusLabel.text = @"撤店";
    }
    
    self.deviceNum.text = [NSString stringWithFormat:@"已绑定设备数量:%@",self.customerModel.device_num];
    
    NSString *money = self.customerModel.purchase_info[@"money"];
    money = [money componentsSeparatedByString:@"."].firstObject;
    
    if ([self.customerModel.purchase_info[@"number"] integerValue] == 0) {
        self.scoreLabel.text = @"0元/0箱 | 本月";
    } else {
        
        self.scoreLabel.text = [NSString stringWithFormat:@"%@元/%@箱 | 本月", money, self.customerModel.purchase_info[@"number"]];
    }
    
    if ([_customerModel.storeStateType integerValue] == -1) {
        self.statusLabel.text = [NSString stringWithFormat:@"积分 %@分", _subStoreModel.score];
    }
    
}

- (IBAction)clickPhoneBtn:(id)sender {

    if ([self.delegate respondsToSelector:@selector(customerManageCell:clickPhoneBtn:withPhone:indexPath:)]) {
        [self.delegate customerManageCell:self clickPhoneBtn:sender withPhone:@"" indexPath:self.indexPath];
    }
}
- (IBAction)clickCheckInBtn:(id)sender {
    ANLog(@"设备登记");
    if ([self.delegate respondsToSelector:@selector(customerManageCell:clickCheckInBtn:)]) {
        [self.delegate customerManageCell:self clickCheckInBtn:sender];
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    if (_indexPath != indexPath) {
        _indexPath = indexPath;
    }
    
//    if (indexPath.row == 0) {
//        self.statusLabel.text = @"试运营";
//        self.scoreLabel.text = @"正在等待审核";
//        self.statusLabel.textColor = [UIColor redColor];
//        self.scoreLabel.textColor = [UIColor redColor];
//        self.numLabel.text = @"1";
//        self.nameLabel.text = @"万达影城";
//        self.storeImg.image = [UIImage imageNamed:@"wanda"];
//    }
}


@end

//
//  ANAreaListTableViewCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/19.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANAreaListTableViewCell.h"

@interface ANAreaListTableViewCell()

/**
 *  店铺图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;

/**
 *  店名
 */
@property (weak, nonatomic) IBOutlet UILabel *storeName;

/**
 *  店铺的个数
 */
@property (weak, nonatomic) IBOutlet UILabel *storeCount;

/**
 *  签约人员名称
 */
@property (weak, nonatomic) IBOutlet UILabel *ignedName;

/**
 *  状态Label
 */
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
/**
 *  状态描述Label
 */
@property (weak, nonatomic) IBOutlet UILabel *statusContentLabel;

/**
 *  本月销售额
 */
@property (weak, nonatomic) IBOutlet UILabel *sellTradeCurrentMonth;


@property (nonatomic, strong) ANCustomerModel *customerModel;
@property (nonatomic, strong) ANSubStoreModel *subStoreModel;
/**
 *  绑定设备数量Label
 */
@property (weak, nonatomic) IBOutlet UILabel *numOfDeviceLabel;


@end

@implementation ANAreaListTableViewCell

+ (instancetype)areaListTableView:(UITableView *)tableView
{
    ANAreaListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANAreaListTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    if (_indexPath != indexPath) {
        _indexPath = indexPath;
    }
}

- (void)awakeFromNib {
    // Initialization code
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (void)setModelDic:(NSDictionary *)modelDic
{
    if (_modelDic != modelDic) {
        _modelDic = modelDic;
    }
    self.customerModel = modelDic[@"user_store"];
    self.subStoreModel = modelDic[@"store"];
    
    [self.storeImageView sd_setImageWithURL:[NSURL URLWithString:self.subStoreModel.cover] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    self.storeName.text = self.subStoreModel.title;
    self.storeCount.text = self.customerModel.store_num;
    self.numOfDeviceLabel.text = [NSString stringWithFormat:@"已绑定设备:%@",self.customerModel.device_num];
    
    if ([self.subStoreModel.status isEqualToString:@"1"]) {
        self.statusLabel.text = @"试营";
        self.statusContentLabel.text = @"正在等待审核";
        self.statusLabel.textColor = ANColor(220, 44, 100);
        self.statusContentLabel.textColor = ANColor(220, 44, 100);
    } else if ([self.subStoreModel.status isEqualToString:@"2"]) {
        self.statusLabel.text = @"正常";
        if (self.subStoreModel.score.length == 0) {
            self.statusContentLabel.text = @"0分";
        } else {
            self.statusContentLabel.text = [NSString stringWithFormat:@"%@分", self.subStoreModel.score];
        }
        self.statusLabel.textColor = ANColor(53, 33, 72);
        self.statusContentLabel.textColor = ANColor(53, 33, 72);
    } else if ([self.subStoreModel.status isEqualToString:@"3"]) {
        self.statusLabel.text = @"撤店";
        self.statusContentLabel.text = @"";
        self.statusLabel.textColor = ANColor(60, 41, 81);
        self.statusContentLabel.textColor = ANColor(164, 164, 164);
    }
    NSString *money = self.customerModel.purchase_info[@"money"];
    money = [money componentsSeparatedByString:@"."].firstObject;
    [self.customerModel.purchase_info setValue:money forKey:@"money"];
    
    self.ignedName.text = [NSString stringWithFormat:@"%@签约",self.customerModel.marketing_info[@"name"]];
    self.sellTradeCurrentMonth.text = [NSString stringWithFormat:@"%@元/%@箱 | 本月",self.customerModel.purchase_info[@"money"],self.customerModel.purchase_info[@"number"]];
    if ([_customerModel.storeStateType integerValue] == -1) {
        if (self.subStoreModel.score.length == 0) {
            self.statusLabel.text = @"积分 0分";
            self.statusContentLabel.text = @"";
        } else {
            self.statusLabel.text = [NSString stringWithFormat:@"积分 %@分", _subStoreModel.score];
            self.statusContentLabel.text = @"";
        }
        self.statusLabel.textColor = ANColor(53, 33, 72);
        self.statusContentLabel.textColor = ANColor(53, 33, 72);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end

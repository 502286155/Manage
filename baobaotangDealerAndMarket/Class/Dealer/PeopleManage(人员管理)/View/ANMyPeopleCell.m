//
//  ANMyPeopleCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/17.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANMyPeopleCell.h"

@interface ANMyPeopleCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
/**
 *  姓名Label
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  未送订单数量
 */
@property (weak, nonatomic) IBOutlet UILabel *sendNum;
/**
 *  拍照任务数量
 */
@property (weak, nonatomic) IBOutlet UILabel *zhaoxiangNum;
/**
 *  topLabel
 */
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
/**
 *  商户数量Label
 */
@property (weak, nonatomic) IBOutlet UIButton *storeNumBtn;
/**
 *  历史Label
 */
@property (weak, nonatomic) IBOutlet UILabel *historyLabel;
/**
 *  本月Label
 */
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@property (weak, nonatomic) IBOutlet UIImageView *peoplePushImg;

@end

@implementation ANMyPeopleCell

+ (instancetype)myPeopleTableView:(UITableView *)tableView
{
    ANMyPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myPeopleCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANMyPeopleCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setModel:(ANPeopleManageModel *)model
{
    if (_model != model) {
        _model = model;
    }
    if ([model.gender isEqualToString:@"0"]) {
        self.headImg.image = [UIImage imageNamed:@"nv"];
    }else if ([model.gender isEqualToString:@"1"]) {
        self.headImg.image = [UIImage imageNamed:@"nan"];
    }
//    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    // 姓名
    self.nameLabel.text = model.realname;
    self.sendNum.text = model.no_deliver_num;
    [self.storeNumBtn setTitle:[NSString stringWithFormat:@"%@个掌柜",model.store_num] forState:UIControlStateNormal];
    self.historyLabel.text = [NSString stringWithFormat:@"%@元/%@箱",model.all_sales_money,model.all_sales_num];
    self.monthLabel.text = [NSString stringWithFormat:@"%@元/%@箱",model.month_sales_money,model.month_sales_num];
    self.topLabel.text = [NSString stringWithFormat:@"top%ld",self.indexPath.row + 1];
}
- (IBAction)clickPeopleStoreListBtn:(id)sender {
    if ([self.model.store_num isEqualToString:@"0"]) {
        [ANCommon setAlertViewWithMessage:@"该市场人员暂未签约商家"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(myPeopleCell:clickPeopleStoreListBtn:withPeopleModel:)]) {
        [self.delegate myPeopleCell:self clickPeopleStoreListBtn:sender withPeopleModel:self.model];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

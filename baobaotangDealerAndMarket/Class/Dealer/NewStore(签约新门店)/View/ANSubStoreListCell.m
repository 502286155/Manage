//
//  ANSubStoreListCell.m
//  baobaotangDealerAndMarket
//
//  Created by Eric on 15/12/10.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANSubStoreListCell.h"

@interface ANSubStoreListCell ()

/**
 *  门店头视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
/**
 *  姓名Label
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  地址Label
 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
/**
 *  门店编号Label
 */
@property (weak, nonatomic) IBOutlet UILabel *stroeNumLabel;
/**
 *  门店状态Label
 */
@property (weak, nonatomic) IBOutlet UILabel *storeStatusLabel;
/**
 *  门店积分Label
 */
@property (weak, nonatomic) IBOutlet UILabel *storeScoreLabel;

/**
 *  拨打电话
 */
@property (weak, nonatomic) IBOutlet UIButton *callButtonAction;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumLabel;

@end

@implementation ANSubStoreListCell

+ (instancetype)subStoreTableView:(UITableView *)tableView
{
    ANSubStoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ANSubStoreListCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANSubStoreListCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setModel:(ANSubStoreModel *)model
{
    if (_model != model) {
        _model = model;
    }
    self.deviceNumLabel.text = [NSString stringWithFormat:@"已绑定设备:%@",model.device_num];
    if (model.imgURL) {
        
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.imgURL] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    }else {
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    }
    NSString *title = model.title;
    if (![model.title_branch isEqualToString:@""]) {
        title = [NSString stringWithFormat:@"%@(%@)",model.title,model.title_branch];
        self.nameLabel.text = title;
    }else {
        self.nameLabel.text = title;
    }
    self.addressLabel.text = model.address;
    if ([model.status isEqualToString:@"1"]) {
        self.lineLabel.hidden = NO;
        self.stroeNumLabel.hidden = NO;
        self.callButtonAction.hidden = NO;
        self.storeStatusLabel.hidden = NO;
        self.storeStatusLabel.text = @"试营";
    } else if ([model.status isEqualToString:@"3"]){
        self.lineLabel.hidden = NO;
        self.stroeNumLabel.hidden = NO;
        self.callButtonAction.hidden = NO;
        self.storeStatusLabel.hidden = NO;
        self.storeStatusLabel.text = @"撤店";
        self.storeStatusLabel.textColor = [UIColor redColor];
    }else if ([model.status isEqualToString:@"2"]) {
        self.lineLabel.hidden = NO;
        self.stroeNumLabel.hidden = NO;
        self.callButtonAction.hidden = NO;
        self.storeStatusLabel.hidden = NO;
        self.storeScoreLabel.text = @"正常";
    }
    self.stroeNumLabel.text = [NSString stringWithFormat:@"门店%@",model.store_order];
    if (model.score.length == 0) {
        self.storeScoreLabel.text = @"";
    } else {
        self.storeScoreLabel.text = [NSString stringWithFormat:@"%@分", model.score];
    }
}

- (IBAction)clickPhoneBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(subStoreListCell:clickPhone:)]) {
        [self.delegate subStoreListCell:self clickPhone:self.model.mobile];
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

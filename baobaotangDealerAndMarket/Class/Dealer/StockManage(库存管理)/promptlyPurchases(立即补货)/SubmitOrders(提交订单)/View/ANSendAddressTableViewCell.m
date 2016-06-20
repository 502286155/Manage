//
//  ANSendAddressTableViewCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/3/21.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANSendAddressTableViewCell.h"

@interface ANSendAddressTableViewCell()

/*
 *  地址Label
 */
@property (weak, nonatomic) IBOutlet UILabel *addressNameLabel;
/*
 *  标志Image
 */
@property (weak, nonatomic) IBOutlet UIImageView *tagImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ANSendAddressTableViewCell

+ (instancetype)sendAddressTableView:(UITableView *)tableView
{
    ANSendAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sendAddress"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANSendAddressTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAddressModel:(ANSendAddressModel *)addressModel
{
    if (_addressModel != addressModel) {
        _addressModel = addressModel;
    }
    self.addressNameLabel.text = addressModel.dealer_address;
    self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",addressModel.dealer_name,addressModel.dealer_mobile];
    if ([addressModel.is_default isEqualToString:@"1"]) {
        self.tagImage.hidden = NO;
    }else {
        self.tagImage.hidden = YES;
    }
}

@end

//
//  ANPriceAdjustmentCell.m
//  baobaotangDealerAndMarket
//
//  Created by Eric on 15/12/10.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANPriceAdjustmentCell.h"

@implementation ANPriceAdjustmentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)priceAdjustmentWithCell:(UITableView *)tableView
{
    ANPriceAdjustmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ANPriceAdjustmentCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANPriceAdjustmentCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

@end

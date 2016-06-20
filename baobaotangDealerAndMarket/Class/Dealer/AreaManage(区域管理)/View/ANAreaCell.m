//
//  ANAreaCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/16.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANAreaCell.h"

@implementation ANAreaCell

+ (instancetype)areaTabelView:(UITableView *)tableView
{
    ANAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANAreaCell" owner:nil options:nil].lastObject;
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

@end

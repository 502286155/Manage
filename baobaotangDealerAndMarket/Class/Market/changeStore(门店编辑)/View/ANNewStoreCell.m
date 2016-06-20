//
//  ANNewStoreCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/2.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANNewStoreCell.h"

@implementation ANNewStoreCell

+ (instancetype)newStoreTableView:(UITableView *)tableView
{
    ANNewStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANNewStoreCell" owner:nil options:nil].lastObject;
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

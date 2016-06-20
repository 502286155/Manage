//
//  ANAwardCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/18.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANAwardCell.h"

@implementation ANAwardCell

+ (instancetype)awardTableViewCell:(UITableView *)tableView
{
    ANAwardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"awardCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANAwardCell" owner:nil options:nil].lastObject;
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

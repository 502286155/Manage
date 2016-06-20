//
//  ANCameraInfoTableViewCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/24.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANCameraInfoTableViewCell.h"

@implementation ANCameraInfoTableViewCell

+ (instancetype)cameraInfoTableView:(UITableView *)tableView
{
    ANCameraInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cameraCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANCameraInfoTableViewCell" owner:nil options:nil].lastObject;
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

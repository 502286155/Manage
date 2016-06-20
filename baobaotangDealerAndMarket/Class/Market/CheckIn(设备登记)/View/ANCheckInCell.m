//
//  ANCheckInCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/10.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANCheckInCell.h"

@interface ANCheckInCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@end

@implementation ANCheckInCell

+ (instancetype)checkInTableView:(UITableView *)tableView
{
    ANCheckInCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkIn"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANCheckInCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setModel:(ANCheckInModel *)model
{
    if (_model == model) {
        _model = model;
    }
    self.nameLabel.text = model.store_title;
    if ([model.device_num intValue] == 0) {
        self.leftLabel.text = @"暂无";
    }else {
        self.leftLabel.text = [NSString stringWithFormat:@"%@个设备",model.device_num];
        self.leftLabel.textColor = [UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0];
    }
    
}

@end

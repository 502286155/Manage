//
//  ANCheckInCell.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/10.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANCheckInModel.h"

@interface ANCheckInCell : UITableViewCell

@property (nonatomic, strong) ANCheckInModel *model;

+ (instancetype)checkInTableView:(UITableView *)tableView;

@end

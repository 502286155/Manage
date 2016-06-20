//
//  ANDeviceCell.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/4/11.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANDeviceModel.h"
@class ANDeviceCell;

@protocol ANDeviceCellDelegate <NSObject>

- (void)deviceCell:(ANDeviceCell *)cell clickUnwarpBtn:(UIButton *)btn;

@end

@interface ANDeviceCell : UITableViewCell

@property (nonatomic, weak) id<ANDeviceCellDelegate> delegate;

@property (nonatomic, strong) ANDeviceModel *model;

+ (ANDeviceCell *)deviceTableView:(UITableView *)tableView;

@end

//
//  ANStoreDeviceCell.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/4/11.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANDeviceModel.h"
@class ANStoreDeviceCell;

@protocol ANStoreDeviceCellDelegate <NSObject>

- (void)deviceCell:(ANStoreDeviceCell *)cell clickUnwarpBtn:(UIButton *)btn;

@end

@interface ANStoreDeviceCell : UITableViewCell

@property (nonatomic, weak) id<ANStoreDeviceCellDelegate> delegate;

@property (nonatomic, strong) ANDeviceModel *model;

+ (ANStoreDeviceCell *)deviceTableView:(UITableView *)tableView;

@end

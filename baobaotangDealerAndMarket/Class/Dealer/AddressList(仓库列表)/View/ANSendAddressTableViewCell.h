//
//  ANSendAddressTableViewCell.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/3/21.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANSendAddressModel.h"
@class ANSendAddressTableViewCell;

@protocol ANSendAddressTableViewCellDelegate <NSObject>

- (void)sendAddressCell:(ANSendAddressTableViewCell *)cell clickInfoBtn:(UIButton *)btn;

@end

@interface ANSendAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) ANSendAddressModel *addressModel;
@property (nonatomic, assign) id<ANSendAddressTableViewCellDelegate> delegate;

+ (instancetype)sendAddressTableView:(UITableView *)tableView;

@end

//
//  ANSendAddressTableViewCell.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/3/21.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANSendAddressModel.h"

@interface ANSendAddressTableViewCell : UITableViewCell

@property (nonatomic, strong) ANSendAddressModel *addressModel;

+ (instancetype)sendAddressTableView:(UITableView *)tableView;

@end

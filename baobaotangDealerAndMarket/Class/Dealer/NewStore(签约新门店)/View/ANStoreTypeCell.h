//
//  ANStoreTypeCell.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/9.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANStoreTypeModel.h"

@interface ANStoreTypeCell : UITableViewCell

@property (nonatomic, strong) ANStoreTypeModel *model;

+ (instancetype)storeTypeTableView:(UITableView *)tableView;

@end

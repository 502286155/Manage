//
//  ANSelectCheckInCell.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/18.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANSelectCheckInModel.h"

@interface ANSelectCheckInCell : UITableViewCell

@property (nonatomic, copy) NSString *storeID;
@property (nonatomic, strong) ANSelectCheckInModel *model;

+ (ANSelectCheckInCell *)selectCheckInCell:(UITableView *)tableView;

@end

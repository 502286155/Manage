//
//  ANAreaListTableViewCell.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/19.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANCustomerModel.h"
#import "ANSubStoreModel.h"

@interface ANAreaListTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *modelDic;

@property (nonatomic, strong) NSIndexPath *indexPath;

+ (instancetype)areaListTableView:(UITableView *)tableView;

@end

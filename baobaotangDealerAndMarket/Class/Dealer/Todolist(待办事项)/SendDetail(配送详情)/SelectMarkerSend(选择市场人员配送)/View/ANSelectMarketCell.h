//
//  ANSelectMarketCell.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/21.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPeopleManageModel.h"

@interface ANSelectMarketCell : UITableViewCell

@property (nonatomic, strong) ANPeopleManageModel *peopleModel;

+ (ANSelectMarketCell *)selectMarketTabelView:(UITableView *)tableView;

@end

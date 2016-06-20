//
//  ANDistributionCell.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/23.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ANDistributionCell;
#import "ANDistributionListModel.h"

@protocol ANDistributionCellDelegate <NSObject>

- (void)distributioncell:(ANDistributionCell *)cell clickSeeDetailBtn:(UIButton *)btn;
- (void)distributioncell:(ANDistributionCell *)cell clickEndSendBtn:(UIButton *)btn;

@end

@interface ANDistributionCell : UITableViewCell

@property (nonatomic, strong) ANDistributionListModel *model;

@property (nonatomic, assign) id<ANDistributionCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

+ (instancetype)distributionTableView:(UITableView *)tableView;

@end

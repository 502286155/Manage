//
//  ANSubStoreListCell.h
//  baobaotangDealerAndMarket
//
//  Created by Eric on 15/12/10.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANSubStoreModel.h"
@class ANSubStoreListCell;

@protocol ANSubStoreListCellDelegate <NSObject>

- (void)subStoreListCell:(ANSubStoreListCell *)cell clickPhone:(NSString *)phone;

@end

@interface ANSubStoreListCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) ANSubStoreModel *model;
@property (nonatomic, assign) id<ANSubStoreListCellDelegate> delegate;

+ (instancetype)subStoreTableView:(UITableView *)tableView;

@end

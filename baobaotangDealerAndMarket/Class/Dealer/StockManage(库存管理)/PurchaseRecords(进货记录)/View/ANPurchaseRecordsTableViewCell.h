//
//  ANPurchaseRecordsTableViewCell.h
//  baobaotang
//
//  Created by Eric on 15/11/5.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPurchaseRecordsModel.h"
@class ANPurchaseRecordsTableViewCell;

@protocol ANPurchaseRecordsTableViewCellDelegate <NSObject>

- (void)purchaseRecordsCell:(ANPurchaseRecordsTableViewCell *)cell clickBtn:(UIButton *)btn orderType:(int)orderType orderID:(NSString *)orderID;

- (void)purchaseRecordsCell:(ANPurchaseRecordsTableViewCell *)cell clickLogisticsBtn:(UIButton *)btn withModel:(ANPurchaseRecordsModel *)model;

@end


@interface ANPurchaseRecordsTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ANPurchaseRecordsTableViewCellDelegate> delegate;

@property (nonatomic, assign) BOOL isBool;

@property (nonatomic, strong) ANPurchaseRecordsModel *model;

+ (instancetype)purchaseRecordsTableViewCell:(UITableView *)table;

@end

//
//  ANSubmitOrderesTableViewCell.h
//  baobaotang
//
//  Created by Eric on 15/11/4.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPurchaseOrderListModel.h"

@class ANSubmitPurchasesModel;
@interface ANSubmitOrderesTableViewCell : UITableViewCell



@property (nonatomic, strong) ANSubmitPurchasesModel *model;
@property (nonatomic, strong) ANPurchaseOrderListModel *orderListModel;

/**
 *  cell的快速创建
 */
+ (instancetype)submitOrderTableViewCell:(UITableView *)table;


@end

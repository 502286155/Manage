//
//  ANMarkPurchaseDetailViewController.h
//  baobaotang
//
//  Created by 高赛 on 15/12/7.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANDistributionListModel.h"

@interface ANMarkPurchaseDetailViewController : UIViewController

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *storePeople;
@property (nonatomic, copy) NSString *signedName;
@property (nonatomic, copy) NSString *storeID;
@property (nonatomic, copy) NSString *phone;
/**
 *  列表model
 */
@property (nonatomic, strong) ANDistributionListModel *model;

@end

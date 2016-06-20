//
//  ANPurchaseDetailViewController.h
//  baobaotang
//
//  Created by 高赛 on 15/12/7.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPurchaseRecordsModel.h"

@interface ANPurchaseDetailViewController : UIViewController

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, strong) ANPurchaseRecordsModel *model;

@end

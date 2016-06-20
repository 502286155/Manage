//
//  ANPayOrderViewController.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/4/11.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPurchaseRecordsModel.h"

@interface ANPayOrderViewController : UIViewController

@property (nonatomic, strong) ANPurchaseRecordsModel *model;
@property (nonatomic, copy) NSString *orderID;

@end

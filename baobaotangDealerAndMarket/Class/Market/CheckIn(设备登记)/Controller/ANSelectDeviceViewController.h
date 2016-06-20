//
//  ANSelectDeviceViewController.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/18.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANCheckInModel.h"

@interface ANSelectDeviceViewController : UIViewController

/**
 *  设备门店列表Model 
 */
@property (nonatomic, strong) ANCheckInModel *model;
/**
 *  门店名称
 */
@property (nonatomic, copy) NSString *storeName;
/**
 *  门店id
 */
@property (nonatomic, copy) NSString *storeID;

@end

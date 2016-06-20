//
//  ANDeviceDetailViewController.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/18.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANSelectCheckInModel.h"

@interface ANDeviceDetailViewController : UIViewController

/**
 *  设备名称
 */
@property (nonatomic, copy) NSString *deviceName;
/**
 *  设备号
 */
@property (nonatomic, copy) NSString *deviceNum;
/**
 *  设备序号
 */
@property (nonatomic, copy) NSString *deviceNo;
/**
 *  是否登记过   1为是  2为不是
 */
@property (nonatomic, assign) BOOL isDevice;
/**
 *  门店id
 */
@property (nonatomic, copy) NSString *storeID;
/**
 *  新设备名称
 */
@property (nonatomic, copy) NSString *res_name;

@property (nonatomic, strong) ANSelectCheckInModel *model;

@end

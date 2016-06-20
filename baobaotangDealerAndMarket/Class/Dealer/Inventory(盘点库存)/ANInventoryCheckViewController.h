//
//  ANPurchasesViewController.h
//  baobaotang
//
//  Created by Eric on 15/11/3.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANInventoryCheckViewController : UIViewController

/**
 *  店铺id
 */
@property (nonatomic, copy) NSString *store_id;

/**
 *  门店名称
 */
@property (nonatomic, copy) NSString *storeName;

/**
 *  商家手机号
 */
@property (nonatomic, copy) NSString *phoneNumber;

/**
 *  门店数量
 */
@property (nonatomic, copy) NSString *storeCount;



@end

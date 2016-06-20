//
//  ANPurchaseRecordsViewController.h
//  baobaotang
//
//  Created by Eric on 15/11/5.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANPurchaseRecordsViewController : UIViewController

/**
 *  是否是订单成功页push过来的
 */
@property (nonatomic, assign) BOOL isPaySuccessPush;

@property (nonatomic, copy) NSString *store_id;


/**
 *  是否是订单成功页push过来的
 */
@property (nonatomic, assign) BOOL isPurchesPush;
@end

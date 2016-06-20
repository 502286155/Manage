//
//  ANSubStoreDetailViewController.h
//  baobaotangDealerAndMarket
//
//  Created by Eric on 15/12/14.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANSubStoreDetailViewController : UIViewController

@property (nonatomic, copy) NSString *storeID;
@property (nonatomic, copy) NSString *typeID;
@property (nonatomic, copy) NSString *owner_id;
/**
 *  是否是从经销商门店列表进来的   1为是  0为不实
 */
@property (nonatomic, assign) BOOL isDealer;
/**
 *  是否暂停了门店  1为是  0为不是
 */
@property (nonatomic, assign) BOOL isCancle;

- (void)requestData;

@end

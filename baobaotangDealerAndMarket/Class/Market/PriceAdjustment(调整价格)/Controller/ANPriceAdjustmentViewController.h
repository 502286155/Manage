//
//  ANPriceAdjustmentViewController.h
//  baobaotangDealerAndMarket
//
//  Created by Eric on 15/12/10.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ANPriceAdjustmentViewControllerDelegate <NSObject>

- (void)refreshData:(NSString *)str;

@end

@interface ANPriceAdjustmentViewController : UIViewController

@property (nonatomic, weak) id<ANPriceAdjustmentViewControllerDelegate> delegate;

@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, strong) NSArray *dataArray;

/**
 *  门店名称
 */
@property (nonatomic, copy) NSString *storeName;

///**
// *  商家手机号
// */
//@property (nonatomic, copy) NSString *phoneNumber;

/**
 *  门店数量
 */
@property (nonatomic, copy) NSString *storeCount;
@property (nonatomic, copy) NSString *goodsCount;

- (void)setValue;


@end

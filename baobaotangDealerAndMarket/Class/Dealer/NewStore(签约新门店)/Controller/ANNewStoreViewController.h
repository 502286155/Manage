//
//  ANNewStoreViewController.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/25.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ANNewStoreViewController;
@class ANSubStoreModel;
typedef void (^AddSubStoreBlock)(ANSubStoreModel *model, ANNewStoreViewController *storeVC);

@interface ANNewStoreViewController : UIViewController

/**
 *  总店id
 */
@property (nonatomic, copy) NSString *owner_id;
/**
 *  是否从经销商总店详情跳过来的  1为是 0为不是
 */
@property (nonatomic, assign) BOOL isDealerNewStore;
/**
 *  是否从总店详情跳过来的  1为是 0为不是
 */
@property (nonatomic, assign) BOOL isNewStore;
/**
 *  门店类型
 */
@property (nonatomic, copy) NSString *typeName;
/**
 *  门店id编码
 */
@property (nonatomic, copy) NSString *typeID;
/**
 *  店名
 */
@property (nonatomic, copy) NSString *storeName;
/**
 *  电话号码
 */
@property (nonatomic, copy) NSString *phoneNumber;

/**
 *  联系人名字
 */
@property (nonatomic, copy) NSString *connectionNameStr;

@property (nonatomic, copy) AddSubStoreBlock addSubStoreBlock;

- (void)addSubStoreBlock:(AddSubStoreBlock)model;

@end

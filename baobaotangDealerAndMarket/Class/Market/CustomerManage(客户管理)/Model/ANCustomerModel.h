//
//  ANCustomerModel.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/10.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANCustomerModel : NSObject

/**
 *  添加时间
 */
@property (nonatomic, copy) NSString *add_time;
/**
 *  经销商ID
 */
@property (nonatomic, copy) NSString *agency_id;
/**
 *  保温箱数量
 */
@property (nonatomic, copy) NSString *machine_num;
/**
 *  手机号
 */
@property (nonatomic, copy) NSString *mobile;
/**
 *  姓名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  总店ID
 */
@property (nonatomic, copy) NSString *owner_id;
/**
 *  分店数量
 */
@property (nonatomic, copy) NSString *store_num;
/**
 *  撤店数量
 */
@property (nonatomic, copy) NSString *stop_store_num;
/**
 *  市场人员信息
 */
@property (nonatomic, strong) NSDictionary *marketing_info;
/**
 *  总的进货信息
 */
@property (nonatomic, strong) NSMutableDictionary *purchase_info;

/**
 *  门店状态
 */
@property (nonatomic, copy) NSString *storeStateType;
/**
 *  设备数量
 */
@property (nonatomic, copy) NSString *device_num;

@end

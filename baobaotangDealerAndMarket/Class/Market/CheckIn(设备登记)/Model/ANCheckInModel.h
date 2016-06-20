//
//  ANCheckInModel.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/18.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANCheckInModel : NSObject

/**
 *  设备数
 */
@property (nonatomic, copy) NSString *device_num;
/**
 *  设备数量字符串
 */
@property (nonatomic, copy) NSString *device_num_str;
/**
 *  门店名称
 */
@property (nonatomic, copy) NSString *store_title;
/**
 *  门店ID
 */
@property (nonatomic, copy) NSString *ID;

@end

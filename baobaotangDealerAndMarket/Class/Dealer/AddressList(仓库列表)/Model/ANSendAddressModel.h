//
//  ANSendAddressModel.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/3/23.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANSendAddressModel : NSObject


// 城市编码
@property (nonatomic, copy) NSString *city_code;
/**
 *  城市文字
 */
@property (nonatomic, copy) NSString *city_area;
// 区县编码
@property (nonatomic, copy) NSString *county_code;
/**
 *  区县文字
 */
@property (nonatomic, copy) NSString *county_area;
// 省份编码
@property (nonatomic, copy) NSString *province_code;
/**
 *  省份文字
 */
@property (nonatomic, copy) NSString *province_area;
// 仓库地址
@property (nonatomic, copy) NSString *dealer_address;
// 仓库编号
@property (nonatomic, copy) NSString *ID;
// 是否是默认地址
@property (nonatomic, copy) NSString *is_default;
/**
 *  联系人电话
 */
@property (nonatomic, copy) NSString *dealer_mobile;
/**
 *  联系人姓名
 */
@property (nonatomic, copy) NSString *dealer_name;

@end

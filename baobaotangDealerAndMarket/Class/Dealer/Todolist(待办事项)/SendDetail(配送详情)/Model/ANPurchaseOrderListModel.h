//
//  ANPurchaseOrderListModel.h
//  baobaotang
//
//  Created by 高赛 on 15/12/8.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANPurchaseOrderListModel : NSObject

/**
 *  购买商品时浮动价格
 */
@property (nonatomic, copy) NSString *addon_price;
/**
 *  杯类型
 */
@property (nonatomic, copy) NSString *cup_type;
/**
 *  此商品大杯数量
 */
@property (nonatomic, copy) NSString *big_cup;
/**
 *  此商品中杯数量
 */
@property (nonatomic, copy) NSString *middle_cup;
/**
 *  此商品小杯数量
 */
@property (nonatomic, copy) NSString *small_cup;
/**
 *  商品id
 */
@property (nonatomic, copy) NSString *goods_id;
/**
 *  商品详细信息
 */
@property (nonatomic, strong) NSDictionary *goods_info;
/**
 *  商品数量
 */
@property (nonatomic, copy) NSString *goods_num;
/**
 *  商品价格
 */
@property (nonatomic, copy) NSString *goods_price;
/**
 *  此商品总价格
 */
@property (nonatomic, copy) NSString *real_price;
/**
 *  SKU ID
 */
@property (nonatomic, copy) NSString *sku_id;

@end

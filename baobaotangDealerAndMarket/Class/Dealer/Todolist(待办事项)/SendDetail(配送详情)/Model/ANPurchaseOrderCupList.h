//
//  ANPurchaseOrderCupList.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/30.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANPurchaseOrderCupList : NSObject
/**
 *  一箱杯子的数量
 */
@property (nonatomic, copy) NSString *box2cup_num;
/**
 *  一箱爆米花需要杯子的数量
 */
@property (nonatomic, copy) NSString *box_cup_num;
/**
 *  共计需要多少箱杯子
 */
@property (nonatomic, copy) NSString *box_num;
/**
 *  实际发货需要多少箱杯子
 */
@property (nonatomic, copy) NSString *cup2box_num;
/**
 *  总计需要的杯子数量
 */
@property (nonatomic, copy) NSString *cup_num;
/**
 *  杯型  1 => '小杯', 2 => '中杯', 3 => '大杯', 4 => '较大杯', 5 => '超大杯' 6=>'纸杯'
 */
@property (nonatomic, copy) NSString *cup_type;
/**
 *  当前超发多少杯子
 */
@property (nonatomic, copy) NSString *excess_num;
/**
 *  否扣掉之前超发杯子数量
 */
@property (nonatomic, copy) NSString *less_cup_num;
/**
 *  用户超发杯子的数量
 */
@property (nonatomic, copy) NSString *store_excess_num;
/**
 *  实际发货需要多少箱杯子
 */
@property (nonatomic, copy) NSString *true_cup2box_num;
/**
 *  实际发货的杯子数量
 */
@property (nonatomic, copy) NSString *true_cup_num;


/**
 *  购买商品时浮动价格
 */
@property (nonatomic, copy) NSString *addon_price;
/**
 *  杯类型
 */
//@property (nonatomic, copy) NSString *cup_type;
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

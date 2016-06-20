//
//  ANPurchaseDetailModel.h
//  baobaotang
//
//  Created by 高赛 on 15/12/8.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANPurchaseDetailModel : NSObject

/**
 *  发货时间
 */
@property (nonatomic, copy) NSString *deliver_time;
/**
 *  发货类型
 */
@property (nonatomic, copy) NSString *deliver_type;
/**
 *  订单编号
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  收货人手机号
 */
@property (nonatomic, copy) NSString *mobile;
/**
 *  订单商品列表
 */
@property (nonatomic, strong) NSMutableArray *order_relation_list;
/**
 *  杯型数据
 */
@property (nonatomic, strong) NSMutableArray *order_cup_list;
/**
 *  支付类型
 */
@property (nonatomic, copy) NSString *pay_type;
/**
 *  订单总价格
 */
@property (nonatomic, copy) NSString *price;
/**
 *  订单状态
 */
@property (nonatomic, copy) NSString *progress;
/**
 *  收货人姓名
 */
@property (nonatomic, copy) NSString *receiver;
/**
 *  收货时间
 */
@property (nonatomic, copy) NSString *receiver_time;
/**
 *  商铺id
 */
@property (nonatomic, copy) NSString *store_id;
/**
 *  订单类型
 */
@property (nonatomic, copy) NSString *type;
/**
 *  积分
 */
@property (nonatomic, copy) NSString *score;
/**
 *  备注
 */
@property (nonatomic, copy) NSString *note;
/**
 *  指派人id
 */
@property (nonatomic, copy) NSString *assigned_id;
/**
 *  是否指派
 */
@property (nonatomic, copy) NSString *is_assigned;
/**
 *  收货地址
 */
@property (nonatomic, copy) NSString *dealer_address;
/**
 *  是否收款
 */
@property (nonatomic, copy) NSString *is_pay;
/**
 *  抱抱币数量
 */
@property (nonatomic, copy) NSString *bbcoin;

@end

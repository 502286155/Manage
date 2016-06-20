//
//  ANPurchaseRecordsModel.h
//  baobaotang
//
//  Created by 高赛 on 15/12/7.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANPurchaseRecordsModel : NSObject

/**
 *  订单添加时间
 */
@property (nonatomic, copy) NSString *add_time;
/**
 *  发货时间
 */
@property (nonatomic, copy) NSString *deliver_time;
/**
 *  配送类型
 */
@property (nonatomic, copy) NSString *deliver_type;
/**
 *  商品总数量
 */
@property (nonatomic, copy) NSString *goods_num;
/**
 *  收货人手机号
 */
@property (nonatomic, copy) NSString *mobile;
/**
 *  支付类型
 */
@property (nonatomic, copy) NSString *pay_type;
/**
 *  订单价格
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
 *  商户时间
 */
@property (nonatomic, copy) NSString *store_id;
/**
 *  订单类型
 */
@property (nonatomic, copy) NSString *type;
/**
 *  下单用户id
 */
@property (nonatomic, copy) NSString *user_id;
/**
 *  订单ID
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  订单内包括几款商品
 */
@property (nonatomic, copy) NSString *goods_type_num;
/**
 *  发货物流备注
 */
@property (nonatomic, copy) NSString *express_note;
/**
 *  发货物流号
 */
@property (nonatomic, copy) NSString *express_no;
/**
 *  物流公司
 */
@property (nonatomic, copy) NSString *express_name;
/**
 *  是否通过审核
 */
@property (nonatomic, copy) NSString *is_payoff;
/**
 *  凭证备注
 */
@property (nonatomic, copy) NSString *payoff_extra;
/**
 *  凭证人员
 */
@property (nonatomic, copy) NSString *payoff_person;
/**
 *  凭证时间
 */
@property (nonatomic, copy) NSString *payoff_time;
/**
 *  凭证金额
 */
@property (nonatomic, copy) NSString *payoff_money;


@end

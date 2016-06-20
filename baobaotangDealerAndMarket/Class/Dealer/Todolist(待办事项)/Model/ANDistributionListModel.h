//
//  ANDistributionListModel.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/15.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANStoreInfoModel.h"
#import "ANAssignUserModel.h"

@interface ANDistributionListModel : NSObject

/**
 *  下单时间
 */
@property (nonatomic, copy) NSString *add_time;
/**
 *  经销商用户id
 */
@property (nonatomic, copy) NSString *agency_id;
/**
 *  指派人ID
 */
@property (nonatomic, copy) NSString *assigned_id;
/**
 *  配送时间
 */
@property (nonatomic, copy) NSString *deliver_time;
/**
 *  配送类型                1 => 免费送货上门
 */
@property (nonatomic, copy) NSString *deliver_type;
/**
 *  订单商品总数
 */
@property (nonatomic, copy) NSString *goods_num;
/**
 *  是否已经指派配送        1=>已经指派 0=>未指派
 */
@property (nonatomic, copy) NSString *is_assigned;
/**
 *  收货人手机号
 */
@property (nonatomic, copy) NSString *mobile;
/**
 *  备注
 */
@property (nonatomic, copy) NSString *note;
/**
 *  订单编号
 */
@property (nonatomic, copy) NSString *order_no;
/**
 *  其他指派人的手机号
 */
@property (nonatomic, copy) NSString *other_assigned_mobile;
/**
 *  其他指派人的真实姓名
 */
@property (nonatomic, copy) NSString *other_assigned_name;
/**
 *  订单总价格
 */
@property (nonatomic, copy) NSString *price;
/**
 *  订单状态        1=>等待配送 5=>配送中 10=>配送完成 15=>取消订单
 */
@property (nonatomic, copy) NSString *progress;
/**
 *  终端店铺id
 */
@property (nonatomic, copy) NSString *store_id;
/**
 *  订单类型        1=>总部订单 5=>经销商订单
 */
@property (nonatomic, copy) NSString *type;
/**
 *  下单用户
 */
@property (nonatomic, copy) NSString *user_id;
/**
 *  支付类型        1 => 上门收款 | 5 => 微信支付 | 10 => 支付宝支付 | 15 => 银联在线支付
 */
@property (nonatomic, copy) NSString *pay_type;
/**
 *  收货时间
 */
@property (nonatomic, copy) NSString *receiver_time;
/**
 *  店铺相关信息
 */
@property (nonatomic, strong) ANStoreInfoModel *storeInfo;
/**
 *  谁撤销的订单
 */
@property (nonatomic, copy) NSString *cancel_order_type;
/**
 *  撤销时间
 */
@property (nonatomic, copy) NSString *cancel_order_time;
/**
 *  撤销人ID
 */
@property (nonatomic, copy) NSString *cancel_order_user_id;
/**
 *  指派人员信息
 */
@property (nonatomic, strong) ANAssignUserModel *assignUserModel;
/**
 *  是否收款
 */
@property (nonatomic, copy) NSString *is_pay;



@end

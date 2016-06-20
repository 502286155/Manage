//
//  ANDealerHomeModel.h
//  baobaotangDealerAndMarket
//
//  Created by Eric on 15/12/23.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANDealerHomeModel : NSObject

/**
 *  区域
 */
@property (nonatomic, copy) NSString *area;

/**
 *  头像链接
 */
@property (nonatomic, copy) NSString *avatar;

/**
 *  区域管理
 */
@property (nonatomic, copy) NSString *customer_num;

/**
 *  库存管理
 */
@property (nonatomic, copy) NSString *goods_category_num;

/**
 *  人员管理
 */
@property (nonatomic, copy) NSString *marketing_num;

/**
 *  电话
 */
@property (nonatomic, copy) NSString *mobile;

/**
 *  姓名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  送货中心
 */
@property (nonatomic, copy) NSString *no_deliver_num;
/**
 *  未处理订单数量
 */
@property (nonatomic, copy) NSString *unassigned_num;

/**
 *  月销售额度
 */
@property (nonatomic, copy) NSString *sale_money_month;

/**
 *  今日销售额
 */
@property (nonatomic, copy) NSString *sale_money_today;

/**
 *  昨日销售额
 */
@property (nonatomic, copy) NSString *sale_money_yesterday;

/**
 *  月销量
 */
@property (nonatomic, copy) NSString *sale_num_month;

/**
 *  今日销量
 */
@property (nonatomic, copy) NSString *sale_num_today;

/**
 *  昨日销量
 */
@property (nonatomic, copy) NSString *sale_num_yesterday;

/**
 *  积分
 */
@property (nonatomic, copy) NSString *score;

/**
 *  <#Description#>
 */
@property (nonatomic, copy) NSString *stock_money;

/**
 *  库存
 */
@property (nonatomic, copy) NSString *stock_num;

/**
 *  门店数量
 */
@property (nonatomic, copy) NSString *store_num;

/**
 *  拍照任务
 */
@property (nonatomic, copy) NSString *todo_num;

/**
 *  未读消息数
 */
@property (nonatomic, copy) NSString *unread_msg_num;

/**
 *  工号
 */
@property (nonatomic, copy) NSString *user_id;
/**
 *  进货记录数目
 */
@property (nonatomic, copy) NSString *trade_order_num;
/**
 *  抱抱币
 */
@property (nonatomic, copy) NSString *bbcoin;

/**
 *  总销售额
 */
@property (nonatomic, copy) NSString *sale_money_all;

/**
 *  商品种类
 */
@property (nonatomic, copy) NSString *store_goods_category_num;
/**
 *  商品的总种类
 */
@property (nonatomic, copy) NSString *all_store_goods_category_num;
/**
 *  总销售量
 */
@property (nonatomic, copy) NSString *sale_num_all;
/**
 *  经销商默认地址
 */
@property (nonatomic, copy) NSString *store_house;
/**
 *  经销商默认地址ID
 */
@property (nonatomic, copy) NSString *dealer_address_id;
/**
 *  默认地址姓名
 */
@property (nonatomic, copy) NSString *dealer_name;
/**
 *  默认地址手机号
 */
@property (nonatomic, copy) NSString *dealer_mobile;
/**
 *  抱抱币开关   1打开  0关闭
 */
@property (nonatomic, copy) NSString *is_bbcoin_enable;
@end

//
//  ANPeopleManageModel.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/15.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANPeopleManageModel : NSObject

/**
 *  头像
 */
@property (nonatomic, copy) NSString *avatar;
/**
 *  邮箱
 */
@property (nonatomic, copy) NSString *email;
/**
 *  性别
 */
@property (nonatomic, copy) NSString *gender;
/**
 *  id
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  手机号
 */
@property (nonatomic, copy) NSString *mobile;
/**
 *  qq
 */
@property (nonatomic, copy) NSString *qq;
/**
 *  真实姓名
 */
@property (nonatomic, copy) NSString *realname;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *user_name;
/**
 *  微信
 */
@property (nonatomic, copy) NSString *weixin;
/**
 *  历史业绩
 */
@property (nonatomic, copy) NSString *all_sales_money;
/**
 *  历史销量数目
 */
@property (nonatomic, copy) NSString *all_sales_num;
/**
 *  本月业绩
 */
@property (nonatomic, copy) NSString *month_sales_money;
/**
 *  本月销量数目
 */
@property (nonatomic, copy) NSString *month_sales_num;
/**
 *  还没有配送完成的订单
 */
@property (nonatomic, copy) NSString *no_deliver_num;
/**
 *  负责店铺的数目
 */
@property (nonatomic, copy) NSString * store_num;

@end

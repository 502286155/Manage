//
//  ANMarkHomeModel.h
//  baobaotangDealerAndMarket
//
//  Created by Eric on 15/12/22.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANMarkHomeModel : NSObject

/**
 *  位置区域
 */
@property (nonatomic, copy) NSString *area;

/**
 *  头像url
 */
@property (nonatomic, copy) NSString *avatar;

/**
 *  客户数
 */
@property (nonatomic, copy) NSString *customer_num;

/**
 *  部门
 */
@property (nonatomic, copy) NSString *department;

/**
 *  职位
 */
@property (nonatomic, copy) NSString *job;

/**
 *  姓名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  本月销售额
 */
@property (nonatomic, copy) NSString *sale_money;

/**
 *  本月销售目标
 */
@property (nonatomic, copy) NSString *sale_target;

/**
 *  待办事项数
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
 *  经销商电话
 */
@property (nonatomic, copy) NSString *dealer_mobile;

@end

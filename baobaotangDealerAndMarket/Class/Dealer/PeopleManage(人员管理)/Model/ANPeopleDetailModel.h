//
//  ANPeopleDetailModel.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/15.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANPeopleDetailModel : NSObject

/**
 *  银行号码
 */
@property (nonatomic, copy) NSString *bank_cardno;
/**
 *  银行名称
 */
@property (nonatomic, copy) NSString *bank_name;
/**
 *  部门
 */
@property (nonatomic, copy) NSString *department;
/**
 *  邮箱
 */
@property (nonatomic, copy) NSString *email;
/**
 *  性别
 */
@property (nonatomic, copy) NSString *gender;
/**
 *  身份证号码
 */
@property (nonatomic, copy) NSString *idcard;
/**
 *  职位
 */
@property (nonatomic, copy) NSString *job;
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
 *  微信
 */
@property (nonatomic, copy) NSString *weixin;
/**
 *  本月业绩
 */
@property (nonatomic, copy) NSString *month_sales_money;
/**
 *  本月销量数目
 */
@property (nonatomic, copy) NSString *month_sales_num;
/**
 *  解约状态
 */
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *store_num;


@end

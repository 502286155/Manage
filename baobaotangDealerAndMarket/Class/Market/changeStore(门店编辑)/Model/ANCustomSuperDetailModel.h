//
//  ANCustomSuperDetailModel.h
//  baobaotangDealerAndMarket
//
//  Created by Eric on 15/12/14.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANCustomSuperDetailModel : NSObject

/**
 *  营业执照
 */
@property (nonatomic, copy) NSString *cert_company;
/**
 *  是否有营业执照
 */
@property (nonatomic, copy) NSString *is_have_cert_company;
/**
 *  是否上传身份证
 */
@property (nonatomic, copy) NSString *is_have_cert_idcard;

/**
 *  身份证正面
 */
@property (nonatomic, copy) NSString *cert_idcard_front;

/**
 *  身份证反面
 */
@property (nonatomic, copy) NSString *cert_idcard_back;

/**
 *  分店数量
 */
@property (nonatomic, assign) NSInteger store_num;
/**
 *  撤店数量
 */
@property (nonatomic, assign) NSInteger stop_store_num;
/**
 *  认证类型	 0营业执照+身份证 1身份证
 */
@property (nonatomic, copy) NSString *cert_type;
/**
 *  手机号
 */
@property (nonatomic, copy) NSString *mobile;
/**
 *  姓名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  本月销售额
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
 *  本月销售量
 */
@property (nonatomic, copy) NSString *sale_num_month;
/**
 *  今日销售量
 */
@property (nonatomic, copy) NSString *sale_num_today;
/**
 *  昨日销售量
 */
@property (nonatomic, copy) NSString *sale_num_yesterday;
/**
 *  积分
 */
@property (nonatomic, copy) NSString *score;
/**
 *  签约人ID
 */
@property (nonatomic, copy) NSString *marketing_id;
/**
 *  商铺的姓名
 */
@property (nonatomic, copy) NSString *title;
/**
 *  商铺的类型名称
 */
@property (nonatomic, copy) NSString *type_str;
/**
 *  商铺的类型ID
 */
@property (nonatomic, copy) NSString *type;
/**
 *  签约人姓名
 */
@property (nonatomic, copy) NSString *sign_user_name;
/**
 *  签约人手机号
 */
@property (nonatomic, copy) NSString *sign_user_mobile;


@end

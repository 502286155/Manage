//
//  ANMineCenterModel.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/9.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANMineCenterModel : NSObject

/**
 *  头像地址
 */
@property (nonatomic, copy) NSString *avatar;
/**
 *  银行号码
 */
@property (nonatomic, copy) NSString *bank_code;
/**
 *  银行名称
 */
@property (nonatomic, copy) NSString *bank_name;
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
 *  职位
 */
@property (nonatomic, copy) NSString *role_name;
/**
 *  仓库地址
 */
@property (nonatomic, copy) NSString *store_house;
/**
 *  微信
 */
@property (nonatomic, copy) NSString *weixin;
/**
 *  是否超过7天未盘点
 */
@property (nonatomic, copy) NSString *is_last_7day_init_stock;

@end

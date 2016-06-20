//
//  ANSubStoreModel.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/10.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANSubStoreModel : NSObject

/**
 *  门店地址
 */
@property (nonatomic, copy) NSString *address;          //
/**
 *  门店级别
 */
@property (nonatomic, copy) NSString *level;            //
/**
 *  门头图
 */
@property (nonatomic, copy) NSString *cover;            //
/**
 *  维度
 */
@property (nonatomic, copy) NSString *latitude;         //
/**
 *  经度
 */
@property (nonatomic, copy) NSString *longitude;        //
/**
 *  设备序列号
 */
@property (nonatomic, copy) NSString *machine_serial;
/**
 *  店长手机号
 */
@property (nonatomic, copy) NSString *mobile;           //
/**
 *  店长姓名
 */
@property (nonatomic, copy) NSString *name;             //
/**
 *  状态
 */
@property (nonatomic, copy) NSString *status;           //
/**
 *  门店ID
 */
@property (nonatomic, copy) NSString *store_id;         //
/**
 *  门店标题
 */
@property (nonatomic, copy) NSString *title;            //
/**
 *  积分
 */
@property (nonatomic, copy) NSString *score;            //
/**
 *  分店后缀名
 */
@property (nonatomic, copy) NSString *title_branch;     //
/**
 *  地址编码
 */
@property (nonatomic, copy) NSString *address_code;     //
/**
 *  门店类型
 */
@property (nonatomic, copy) NSString *type;             //
/**
 *  门店顺序
 */
@property (nonatomic, copy) NSString *store_order;
/**
 *  设备数量
 */
@property (nonatomic, copy) NSString *device_num;
/**
 *  图片地址
 */
@property (nonatomic, copy) NSString *imgURL;
/**
 *  签约人手机号
 */
@property (nonatomic, copy) NSString *sign_user_mobile;
/**
 *  签约人姓名
 */
@property (nonatomic, copy) NSString *sign_user_name;
/**
 *  签约人ID
 */
@property (nonatomic, copy) NSString *sign_user_id;

@end

//
//  ANStoreInfoModel.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/15.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANUserInfoModel.h"

@interface ANStoreInfoModel : NSObject

/**
 *  店铺名称
 */
@property (nonatomic, copy) NSString *title;
/**
 *  后缀名
 */
@property (nonatomic, copy) NSString *title_branch;
/**
 *  店铺地址
 */
@property (nonatomic, copy) NSString *address;
/**
 *  店铺ID
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  市场人员ID
 */
@property (nonatomic, copy) NSString *marketing_id;
/**
 *  签约人员相关信息
 */
@property (nonatomic, strong) ANUserInfoModel *marketingUserInfo;
/**
 *  店长用户相关信息
 */
@property (nonatomic, strong) ANUserInfoModel *storeUserInfo;
/**
 *  店长id
 */
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *owner_id;
@property (nonatomic, copy) NSString *type;

@end

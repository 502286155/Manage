//
//  ANUserInfoModel.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/15.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANUserInfoModel : NSObject

@property (nonatomic, copy) NSString *ID;
/**
 *  头像
 */
@property (nonatomic, copy) NSString *avatar;
/**
 *  手机号
 */
@property (nonatomic, copy) NSString *mobile;
/**
 *  真实姓名
 */
@property (nonatomic, copy) NSString *realname;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *user_name;

@end

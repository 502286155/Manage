//
//  ANAssignUserModel.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/22.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANAssignUserModel : NSObject
/**
 *  支配人ID
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  手机号
 */
@property (nonatomic, copy) NSString *mobile;
/**
 *  姓名
 */
@property (nonatomic, copy) NSString *realname;

@end

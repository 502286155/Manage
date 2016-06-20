//
//  ANSelectCheckInModel.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/18.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANSelectCheckInModel : NSObject

@property (nonatomic, copy) NSString *device_no;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *res_name;
@property (nonatomic, copy) NSString *device_num_str;
@property (nonatomic, copy) NSString *device_num;
/**
 *  是否开放
 */
@property (nonatomic, copy) NSString *allow_bind;

@end

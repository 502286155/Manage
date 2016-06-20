//
//  ANSendAddressModel.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/3/23.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANSendAddressModel.h"

@implementation ANSendAddressModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [ANSendAddressModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"ID" : @"id"
                     };
        }];
    }
    return self;
}

@end

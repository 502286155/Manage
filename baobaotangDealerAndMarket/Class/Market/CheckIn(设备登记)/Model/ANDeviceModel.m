//
//  ANDeviceModel.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/4/15.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANDeviceModel.h"

@implementation ANDeviceModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self replaceName];
        
    }
    return self;
}

- (void)replaceName
{
    [ANDeviceModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
}

@end

//
//  ANAssignUserModel.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/22.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANAssignUserModel.h"

@implementation ANAssignUserModel

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
    [ANAssignUserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
}


@end

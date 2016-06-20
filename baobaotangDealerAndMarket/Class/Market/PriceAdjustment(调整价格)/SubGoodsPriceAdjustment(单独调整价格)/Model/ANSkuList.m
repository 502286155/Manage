//
//  ANSkuList.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/2/25.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANSkuList.h"

@implementation ANSkuList

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
    
    [ANSkuList mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 };
    }];
}

@end

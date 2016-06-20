//
//  ANNewPurchasesModel.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/2/25.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANNewPurchasesModel.h"

@implementation ANNewPurchasesModel

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
    
    [ANNewPurchasesModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 };
    }];
}

@end

//
//  ANPurchaseDetailModel.m
//  baobaotang
//
//  Created by 高赛 on 15/12/8.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANPurchaseDetailModel.h"

@implementation ANPurchaseDetailModel

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
    
    [ANPurchaseDetailModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 };
    }];
}

@end

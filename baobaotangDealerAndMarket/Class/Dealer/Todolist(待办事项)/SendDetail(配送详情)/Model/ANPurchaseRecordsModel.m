//
//  ANPurchaseRecordsModel.m
//  baobaotang
//
//  Created by 高赛 on 15/12/7.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANPurchaseRecordsModel.h"

@implementation ANPurchaseRecordsModel

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
    
    [ANPurchaseRecordsModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 };
    }];
}

@end

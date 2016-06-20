//
//  ANPeopleManageModel.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/15.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANPeopleManageModel.h"

@implementation ANPeopleManageModel

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
    
    [ANPeopleManageModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
}

@end

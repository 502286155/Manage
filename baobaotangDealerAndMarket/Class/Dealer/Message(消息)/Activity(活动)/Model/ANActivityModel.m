//
//  ANActivityModel.m
//  baobaotang
//
//  Created by 高赛 on 15/12/9.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANActivityModel.h"

@implementation ANActivityModel

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
    
    [ANActivityModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id"
                 };
    }];
}

@end

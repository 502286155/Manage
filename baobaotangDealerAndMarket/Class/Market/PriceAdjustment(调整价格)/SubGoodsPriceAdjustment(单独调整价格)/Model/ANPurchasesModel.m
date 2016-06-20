//
//  ANPurchasesModel.m
//  baobaotang
//
//  Created by Eric on 15/12/3.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANPurchasesModel.h"
#import "NSObject+MJProperty.h"

@implementation ANPurchasesModel


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
    
    [ANPurchasesModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID" : @"id",
                 @"price" : @"sku_list[0].price",
                 @"sku_id" : @"sku_list[0].sku_id",
                 @"goods_id" : @"sku_list[0].goods_id",
                 @"stock" : @"sku_list[0].stock"
                 };
    }];
}

@end

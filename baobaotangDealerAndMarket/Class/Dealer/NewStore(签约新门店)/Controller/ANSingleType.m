//
//  ANSingleType.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/22.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANSingleType.h"
#import "ANHttpTool.h"

@interface ANSingleType()

@property (nonatomic, strong) ANStoreTypeModel *model;

@end

@implementation ANSingleType

SingleTonM(type)

- (void)typeBlock:(SingleTypeBlock)block
{
    self.typeBlock = block;
}

#pragma mark ----网络请求
- (void)requestData
{
    [ANHttpTool getWithUrl:@"/api/1/store/get_store_type" params:nil successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseTaskLoadData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)parseTaskLoadData:(id)data
{
    NSMutableArray *arr = [NSMutableArray array];
    
    NSDictionary *dict = data[@"response"];
    
    NSArray *keys = [dict allKeys];
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 intValue] < [obj2 intValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        if ([obj1 intValue] > [obj2 intValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    for (NSString *str in keys) {
        ANStoreTypeModel *storeModel = [[ANStoreTypeModel alloc] init];
        storeModel.typeID = str;
        storeModel.typeName = dict[str];
        [arr addObject:storeModel];
    }
    self.dataArr = arr;
    self.typeBlock(self.dataArr);
}

- (ANStoreTypeModel *)storeTypeModelWithTypeID:(NSString *)typeID
{
    for (ANStoreTypeModel *model in self.dataArr) {
        if ([model.typeID isEqualToString:typeID]) {
            self.model = model;
        }
    }
    return self.model;
}
- (ANStoreTypeModel *)storeTypeModelWithName:(NSString *)name
{
    for (ANStoreTypeModel *model in self.dataArr) {
        if ([model.typeName isEqualToString:name]) {
            self.model = model;
        }
    }
    return self.model;
}

@end

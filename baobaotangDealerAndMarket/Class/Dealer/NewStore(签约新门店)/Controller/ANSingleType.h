//
//  ANSingleType.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/22.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleTon.h"
#import "ANStoreTypeModel.h"

typedef void (^SingleTypeBlock)(NSArray *typeArr);

@interface ANSingleType : NSObject
/**
 *  数据数组
 */
@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, copy) SingleTypeBlock typeBlock;

SingleTonH(type)

- (void)typeBlock:(SingleTypeBlock)block;
/**
 *  发起网络请求类型数据
 */
- (void)requestData;
/**
 *  根据类型名称查找类型model
 */
- (ANStoreTypeModel *)storeTypeModelWithName:(NSString *)name;
/**
 *  根据类型ID查找类型model
 */
- (ANStoreTypeModel *)storeTypeModelWithTypeID:(NSString *)typeID;

@end

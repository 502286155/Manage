//
//  ANCupTypeModel.h
//  baobaotangDealerAndMarket
//
//  Created by Eric on 15/12/28.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANCupTypeModel : NSObject

/**
 *  一箱杯子的数量
 */
@property (nonatomic, copy) NSString *box2cup_num;

/**
 *  一箱爆米花需要杯子的数量
 */
@property (nonatomic, copy) NSString *box_cup_num;

/**
 *  爆米花箱数
 */
@property (nonatomic, copy) NSString *box_num;

/**
 *  共计需要多少箱杯子
 */
@property (nonatomic, copy) NSString *cup2box_num;

/**
 *  总计需要的杯子数量	number
 */
@property (nonatomic, copy) NSString *cup_num;

/**
 *  当前超发多少杯子
 */
@property (nonatomic, copy) NSString *excess_num;

/**
 *  否扣掉之前超发杯子数量
 */
@property (nonatomic, copy) NSString *less_cup_num;

/**
 *  用户超发杯子的数量
 */
@property (nonatomic, copy) NSString *store_excess_num;

/**
 *  实际发货需要多少箱杯子
 */
@property (nonatomic, copy) NSString *true_cup2box_num;

/**
 *  实际发货的杯子数量
 */
@property (nonatomic, copy) NSString *true_cup_num;

@end

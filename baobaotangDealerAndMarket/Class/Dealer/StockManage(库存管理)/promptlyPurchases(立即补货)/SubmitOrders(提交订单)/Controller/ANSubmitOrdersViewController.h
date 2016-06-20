//
//  ANSubmitOrdersViewController.h
//  baobaotang
//
//  Created by Eric on 15/11/4.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANSubmitOrdersViewController : UIViewController

/**
 *  数据源
 */
@property (nonatomic, strong) NSArray *dataArray;

/**
 *  总价
 */
@property (nonatomic, assign) float totalPrice;

/**
 *  小杯数量
 */
@property (nonatomic, assign) NSInteger smallCup;
/**
 *  中杯数量
 */
@property (nonatomic, assign) NSInteger middleCup;
/**
 *  大杯数量
 */
@property (nonatomic, assign) NSInteger bigCup;

/**
 *  较大杯数量
 */
@property (nonatomic, assign) NSInteger moreBigCup;
/**
 *  超大杯数量
 */
@property (nonatomic, assign) NSInteger superBigCup;
/**
 *  纸袋数量
 */
@property (nonatomic, assign) NSInteger paperBagCup;
/**
 *  杯型信息数据
 */
@property (nonatomic, strong) NSArray *cupListArr;


@property (nonatomic, assign) BOOL isLastOrder;

@property (nonatomic, assign) NSInteger totalBox;

@end

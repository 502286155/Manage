//
//  ANSubmitPurchasesModel.h
//  baobaotang
//
//  Created by Eric on 15/12/3.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANSubmitPurchasesModel : NSObject

/**
 *  商品id
 */
@property (nonatomic, copy) NSString *goods_id; //

/**
 *  商品数量
 */
@property (nonatomic, assign) NSInteger goods_num;  //

/**
 *  SKU id
 */
@property (nonatomic, copy) NSString *sku_id;   //

/**
 *  商品类型
 */
@property (nonatomic, copy) NSString *category_id;  //

/**
 *  商品图片
 */
@property (nonatomic, copy) NSString *cover;    //

/**
 *  商品标题
 */
@property (nonatomic, copy) NSString *title;    //

/**
 *  商品简介
 */
@property (nonatomic, copy) NSString *intro;    //

/**
 *  价格
 */
@property (nonatomic, copy) NSString *price;


@end

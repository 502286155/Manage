//
//  ANPurchasesModel.h
//  baobaotang
//
//  Created by Eric on 15/12/3.
//  Copyright © 2015年 Eric. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface ANPurchasesModel : NSObject

/**
 *  分类id(散装/零售)
 */
@property (nonatomic, copy) NSString *category_id;  

/**
 *  分类名称(散装/零售)
 */
@property (nonatomic, copy) NSString *category_name;

/**
 *  图片
 */
@property (nonatomic, copy) NSString *cover;    

/**
 *  id
 */
@property (nonatomic, copy) NSString *ID;

/**
 *  价格
 */
@property (nonatomic, copy) NSString *price;

/**
 *  sku_id
 */
@property (nonatomic, copy) NSString *sku_id;

/**
 *  goods_id
 */
@property (nonatomic, copy) NSString *goods_id;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  商品简介
 */
@property (nonatomic, copy) NSString *intro;

/**
 *  序号
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 *  商品数量
 */
@property (nonatomic, assign) NSInteger puchasesCount;
/**
 *  是否上架 0没上架  其他是上架
 */
@property (nonatomic, copy) NSString *is_sale;
/**
 *  是否热销
 */
@property (nonatomic, copy) NSString *is_hot;
/**
 *  是否新品
 */
@property (nonatomic, copy) NSString *is_new;
/**
 *  是否推荐
 */
@property (nonatomic, copy) NSString *is_recommend;

/**
 *  库存
 */
@property (nonatomic, copy) NSString *stock;

/**
 *  剩余的库存
 */
@property (nonatomic, assign) NSInteger surplusStock;

/**
 *  建议零售价
 */
@property (nonatomic, copy) NSString *market_price;

@end

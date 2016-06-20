//
//  ANNewPurchasesModel.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/2/25.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANSkuList.h"

@interface ANNewPurchasesModel : NSObject

/**
 *  分类ID
 */
@property (nonatomic, copy) NSString *category_id;
/**
 *  分类名称
 */
@property (nonatomic, copy) NSString *category_name;
/**
 *  封面
 */
@property (nonatomic, copy) NSString *cover;
/**
 *  id
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  商品描述
 */
@property (nonatomic, copy) NSString *intro;
/**
 *  是否爆品
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
 *  是否上架
 */
@property (nonatomic, copy) NSString *is_sale;
/**
 *  sku_list
 */
@property (nonatomic, strong) ANSkuList *skuList;
/**
 *  商品标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  建议零售价
 */
@property (nonatomic, copy) NSString *market_price;
/**
 *  剩余的库存
 */
@property (nonatomic, assign) NSInteger surplusStock;

@property (nonatomic, strong) NSIndexPath *indexPath;





@end

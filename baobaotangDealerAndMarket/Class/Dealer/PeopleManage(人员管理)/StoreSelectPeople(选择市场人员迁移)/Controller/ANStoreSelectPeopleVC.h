//
//  ANSelectMarketViewController.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/21.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANStoreSelectPeopleVC : UIViewController
/**
 *  控制器来源  1---门店迁移  0---支配人员
 */
@property (nonatomic, copy) NSString *sourceVC;
@property (nonatomic, strong) NSMutableArray *ownerIDArr;

@property (nonatomic, copy) NSString *marketing_id;

@end

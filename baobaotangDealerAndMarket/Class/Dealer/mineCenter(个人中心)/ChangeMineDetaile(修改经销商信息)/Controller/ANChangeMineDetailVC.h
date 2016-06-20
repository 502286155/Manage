//
//  ANChangeMineDetailVC.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/4/28.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANMineCenterModel.h"

@interface ANChangeMineDetailVC : UIViewController

@property (nonatomic, strong) ANMineCenterModel *model;

@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *nameValue;

@end

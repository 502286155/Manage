//
//  ANEditAddressViewController.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/4/29.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANSendAddressModel.h"

@interface ANEditAddressViewController : UIViewController

@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, strong) ANSendAddressModel *model;

@end

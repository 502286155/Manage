//
//  ANCancelStoreViewController.h
//  baobaotang
//
//  Created by 高赛 on 15/12/28.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANSubStoreDetailViewController.h"

@interface ANCancelStoreViewController : UIViewController

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *owner_id;
@property (nonatomic, copy) NSString *storeID;
@property (nonatomic, strong) ANSubStoreDetailViewController *subStoreDetail;

@end

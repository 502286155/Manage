//
//  ANCancelOrderViewController.h
//  baobaotang
//
//  Created by 高赛 on 15/12/28.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANCancelOrderViewController : UIViewController

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *storeID;
/**
 *  从哪个控制器里跳转过来  1 配送详情
 */
@property (nonatomic, copy) NSString *viewControllerNum;

@end

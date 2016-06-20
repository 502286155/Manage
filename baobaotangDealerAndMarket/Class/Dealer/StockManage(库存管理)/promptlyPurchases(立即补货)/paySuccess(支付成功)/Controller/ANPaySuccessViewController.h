//
//  ANPaySuccessViewController.h
//  baobaotang
//
//  Created by Eric on 15/11/6.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANPaySuccessViewController : UIViewController

@property (nonatomic, assign) BOOL isHomeVC;

@property (nonatomic, copy) NSString *order_id;

/**
 *  商户id
 */
@property (nonatomic, copy) NSString *store_id;

@end

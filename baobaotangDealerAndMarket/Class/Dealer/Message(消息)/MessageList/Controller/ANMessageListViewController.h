//
//  ANMessageListViewController.h
//  baobaotang
//
//  Created by 高赛 on 15/11/22.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANMessageModel.h"

@interface ANMessageListViewController : UIViewController

@property (nonatomic, strong) ANMessageModel *model;

@property (nonatomic, copy) NSString *res_name;

@end

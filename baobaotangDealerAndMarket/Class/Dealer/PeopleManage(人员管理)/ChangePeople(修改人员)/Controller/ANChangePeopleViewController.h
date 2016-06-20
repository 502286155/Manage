//
//  ANChangePeopleViewController.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/22.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPeopleDetailModel.h"

@protocol ANChangePeopleViewControllerDelegate <NSObject>

- (void)requestPeopleData;

@end

@interface ANChangePeopleViewController : UIViewController

@property (nonatomic, assign) id<ANChangePeopleViewControllerDelegate> delegate;
@property (nonatomic, strong) ANPeopleDetailModel *model;
@property (nonatomic, copy) NSString *marketing_id;

@end

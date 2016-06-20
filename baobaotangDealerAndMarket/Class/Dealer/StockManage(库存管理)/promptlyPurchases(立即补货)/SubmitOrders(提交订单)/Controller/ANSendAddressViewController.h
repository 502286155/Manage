//
//  ANSendAddressViewController.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/3/21.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANSendAddressModel.h"
@class ANSendAddressViewController;

@protocol ANSendAddressViewControllerDelegate <NSObject>

- (void)sendAddressViewController:(ANSendAddressViewController *)sendAddressViewController andDataArr:(NSMutableArray *)dataArr andAddressModel:(ANSendAddressModel *)addressModel;

@end

@interface ANSendAddressViewController : UIViewController

/*
 *  是否有数据
 */
@property (nonatomic, assign) BOOL isHaveData;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) id<ANSendAddressViewControllerDelegate> delegate;

@end

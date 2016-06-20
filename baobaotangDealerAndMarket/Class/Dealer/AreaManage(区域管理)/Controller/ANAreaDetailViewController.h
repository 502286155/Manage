//
//  ANAreaDetailViewController.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/19.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ANAreaDetailViewControllerDelegate <NSObject>

- (void)pushViewController:(UIViewController *)vc;

- (void)deleteStore:(NSString *)ownerID;

- (void)deleteStoreSuccess:(NSIndexPath *)indexPath;

@end

@interface ANAreaDetailViewController : UIViewController

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *owner_id;
@property (nonatomic, copy) NSString *subStoreID;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) id<ANAreaDetailViewControllerDelegate> delegate;

@end

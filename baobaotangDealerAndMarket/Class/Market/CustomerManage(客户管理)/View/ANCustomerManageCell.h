//
//  ANCustomerManageCell.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/24.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANCustomerModel.h"
#import "ANSubStoreModel.h"
@class ANCustomerManageCell;

@protocol ANCustomerManageCell <NSObject>

- (void)customerManageCell:(ANCustomerManageCell *)cell clickPhoneBtn:(UIButton *)btn withPhone:(NSString *)phone indexPath:(NSIndexPath *)indexPath;
- (void)customerManageCell:(ANCustomerManageCell *)cell clickCheckInBtn:(UIButton *)btn;

@end

@interface ANCustomerManageCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *modelDic;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<ANCustomerManageCell> delegate;

+ (instancetype)customermanageTabelView:(UITableView *)tableView;

@end

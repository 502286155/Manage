//
//  ANPurchasesTableViewCell.h
//  baobaotang
//
//  Created by 高赛 on 15/11/30.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPurchasesModel.h"


@protocol ANInventoryCheckCellDelegate <NSObject>

@optional
- (void)inventoryCheckTableViewCell:(UIView *)view button:(UIButton *)button priceText:(UITextField *)priceText indexPath:(NSIndexPath *)indexPath;

- (void)inventoryCheckTableviewcell:(UIView *)view textField:(UITextField *)textField indexPath:(NSIndexPath *)indexPath;

@end

@interface ANInventoryCheckCell : UITableViewCell




@property (nonatomic, strong) ANPurchasesModel *purchasesModel;

@property (nonatomic, assign) id <ANInventoryCheckCellDelegate> delegate;


+ (instancetype)inventoryCheckCellTableView:(UITableView *)tableView;

@end

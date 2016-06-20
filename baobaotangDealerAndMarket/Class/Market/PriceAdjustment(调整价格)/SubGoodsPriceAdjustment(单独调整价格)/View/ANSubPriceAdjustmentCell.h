//
//  ANPurchasesTableViewCell.h
//  baobaotang
//
//  Created by 高赛 on 15/11/30.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPurchasesModel.h"
#import "ANNewPurchasesModel.h"

@protocol ANSubPriceAdjustmentCellDelegate <NSObject>

@optional
- (void)subPriceAdjustmentTableViewCell:(UIView *)view button:(UIButton *)button priceText:(NSString *)priceText indexPath:(NSIndexPath *)indexPath;

@end

@interface ANSubPriceAdjustmentCell : UITableViewCell



@property (nonatomic, strong) ANNewPurchasesModel *purchasesNewModel;

@property (nonatomic, strong) ANPurchasesModel *purchasesModel;

@property (nonatomic, assign) id <ANSubPriceAdjustmentCellDelegate> delegate;


+ (instancetype)subPriceAdjustmentCellTableView:(UITableView *)tableView;

@end

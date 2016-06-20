//
//  ANPurchasesTableViewCell.h
//  baobaotang
//
//  Created by 高赛 on 15/11/30.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPurchasesModel.h"

typedef NS_ENUM(NSInteger, ButtonType){
    ButtonTypeSubtract,
    ButtonTypeAdd
};

@protocol ANPurchasesTableViewCellDelegate <NSObject>

@optional
- (void)purchasesTableViewCell:(UIView *)view button:(UIButton *)button indexPath:(NSIndexPath *)indexPath;
- (void)purchasesEditFinshedTextField:(UITextField *)textField indexPath:(NSIndexPath *)indexPath;


@end

@interface ANPurchasesTableViewCell : UITableViewCell




@property (weak, nonatomic) IBOutlet UILabel *numLabel;


@property (nonatomic, strong) ANPurchasesModel *purchasesModel;

@property (nonatomic, assign) id <ANPurchasesTableViewCellDelegate> delegate;


+ (instancetype)purchasesTableView:(UITableView *)tableView;

@end

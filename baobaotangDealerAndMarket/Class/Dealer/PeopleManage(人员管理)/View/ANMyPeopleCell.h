//
//  ANMyPeopleCell.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/17.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPeopleManageModel.h"
@class ANMyPeopleCell;

@protocol ANMyPeopleCellDelegate <NSObject>

- (void)myPeopleCell:(ANMyPeopleCell *)cell clickPeopleStoreListBtn:(UIButton *)btn withPeopleModel:(ANPeopleManageModel *)peopleModel;

@end

@interface ANMyPeopleCell : UITableViewCell

@property (nonatomic, weak) id<ANMyPeopleCellDelegate> delegate;

@property (nonatomic, strong) ANPeopleManageModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
+ (instancetype)myPeopleTableView:(UITableView *)tableView;

@end

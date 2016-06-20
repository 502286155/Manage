//
//  ANNewMessageCell.h
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/5/8.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANMessageList.h"
@class ANNewMessageCell;

@interface ANNewMessageCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) ANMessageList *model;
+ (instancetype)newMessageTableView:(UITableView *)tableView;

@end

//
//  ANMessageListCell.h
//  baobaotang
//
//  Created by 高赛 on 15/11/22.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANMessageListCell.h"
#import "ANMessageList.h"

@interface ANMessageListCell : UITableViewCell

@property (nonatomic, assign) BOOL isHiddenLine;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) ANMessageList *model;

+ (instancetype)messageListTableView:(UITableView *)tableView;

@end

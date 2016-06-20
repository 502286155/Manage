//
//  ANActivityMessageCell.h
//  baobaotang
//
//  Created by 高赛 on 15/12/9.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANActivityModel.h"

@interface ANActivityMessageCell : UITableViewCell

@property (nonatomic, strong) ANActivityModel *model;

+ (instancetype)activityMessageTableView:(UITableView *)tableView;

@end

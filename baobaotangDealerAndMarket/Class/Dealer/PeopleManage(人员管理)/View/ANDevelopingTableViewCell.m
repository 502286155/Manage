//
//  ANDevelopingTableViewCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/18.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANDevelopingTableViewCell.h"

@interface ANDevelopingTableViewCell()

/**
 *  回复按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;


@end

@implementation ANDevelopingTableViewCell

+ (instancetype)developingTableView:(UITableView *)tableView
{
    ANDevelopingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"developeCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANDevelopingTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}
- (IBAction)clickReplyBtn:(id)sender {
    ANLog(@"回复");
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

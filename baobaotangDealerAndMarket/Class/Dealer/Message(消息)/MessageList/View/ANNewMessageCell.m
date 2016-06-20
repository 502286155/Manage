//
//  ANNewMessageCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/5/8.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANNewMessageCell.h"

@interface ANNewMessageCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ANNewMessageCell

+ (instancetype)newMessageTableView:(UITableView *)tableView
{
    ANNewMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newMessageCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANNewMessageCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(ANMessageList *)model
{
    if (_model != model) {
        _model = model;
    }
    NSArray *arr = [model.add_time componentsSeparatedByString:@" "];
    self.timeLabel.text = arr[1];
    self.contentLabel.text = model.title;
}

@end

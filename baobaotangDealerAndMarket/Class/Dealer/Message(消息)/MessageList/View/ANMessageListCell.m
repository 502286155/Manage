//
//  ANMessageListCell.m
//  baobaotang
//
//  Created by 高赛 on 15/11/22.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANMessageListCell.h"

@interface ANMessageListCell()


@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ANMessageListCell

+ (instancetype)messageListTableView:(UITableView *)tableView
{
    ANMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageListCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANMessageListCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
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
    self.contentLabel.text = model.title;
    NSArray *arr = [model.add_time componentsSeparatedByString:@" "];
    self.timeLabel.text = arr[1];
}
- (void)setIsHiddenLine:(BOOL)isHiddenLine
{
    if (_isHiddenLine != isHiddenLine) {
        _isHiddenLine = isHiddenLine;
    }
    if (isHiddenLine) {
        self.lineView.hidden = YES;
    }
}

@end

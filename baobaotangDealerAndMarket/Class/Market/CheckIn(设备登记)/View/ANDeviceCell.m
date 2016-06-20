//
//  ANDeviceCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/4/11.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANDeviceCell.h"

@interface ANDeviceCell()

/**
 *  码内容
 */
@property (weak, nonatomic) IBOutlet UILabel *deviceNumLabel;
/**
 *  解绑按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *unwrapBtn;

@end

@implementation ANDeviceCell

+ (ANDeviceCell *)deviceTableView:(UITableView *)tableView
{
    ANDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceDetail"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANDeviceCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setModel:(ANDeviceModel *)model
{
    if (_model != model) {
        _model = model;
    }
    self.unwrapBtn.layer.borderColor = [UIColor colorWithRed:0.2784 green:0.1922 blue:0.3686 alpha:1.0].CGColor;
    self.unwrapBtn.layer.borderWidth = 1;
    self.deviceNumLabel.text = model.device_no;
}

- (IBAction)clickUnwrapBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deviceCell:clickUnwarpBtn:)]) {
        [self.delegate deviceCell:self clickUnwarpBtn:sender];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

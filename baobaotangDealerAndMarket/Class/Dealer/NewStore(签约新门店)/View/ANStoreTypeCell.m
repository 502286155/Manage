//
//  ANStoreTypeCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/9.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANStoreTypeCell.h"

@interface ANStoreTypeCell()

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation ANStoreTypeCell

+ (instancetype)storeTypeTableView:(UITableView *)tableView
{
    ANStoreTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ANStoreTypeCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANStoreTypeCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setModel:(ANStoreTypeModel *)model
{
    if (_model != model) {
        _model = model;
    }
    self.titleView.layer.borderColor = [UIColor colorWithRed:0.7961 green:0.7961 blue:0.7961 alpha:1.0].CGColor;
    self.titleLabel.text = model.typeName;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

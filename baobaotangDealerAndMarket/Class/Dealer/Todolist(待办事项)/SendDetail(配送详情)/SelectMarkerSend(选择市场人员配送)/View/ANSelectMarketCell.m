//
//  ANSelectMarketCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/21.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANSelectMarketCell.h"

@interface ANSelectMarketCell()


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ANSelectMarketCell

+ (ANSelectMarketCell *)selectMarketTabelView:(UITableView *)tableView
{
    ANSelectMarketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANSelectMarketCell" owner:nil options:nil].lastObject;
    }
    return cell;
}
- (void)setPeopleModel:(ANPeopleManageModel *)peopleModel
{
    if (_peopleModel != peopleModel) {
        _peopleModel = peopleModel;
    }
    self.nameLabel.text = peopleModel.realname;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

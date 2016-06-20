//
//  ANStoreSelectPeopleCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/21.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANStoreSelectPeopleCell.h"

@interface ANStoreSelectPeopleCell()


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation ANStoreSelectPeopleCell

+ (ANStoreSelectPeopleCell *)selectMarketTabelView:(UITableView *)tableView
{
    ANStoreSelectPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANStoreSelectPeopleCell" owner:nil options:nil].lastObject;
    }
    return cell;
}
- (void)setPeopleModel:(ANPeopleManageModel *)peopleModel
{
    if (_peopleModel != peopleModel) {
        _peopleModel = peopleModel;
    }
    self.nameLabel.text = peopleModel.realname;
    if (self.isSelect) {
        self.selectImageView.hidden = NO;
    }else {
        self.selectImageView.hidden = YES;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

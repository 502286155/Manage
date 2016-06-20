//
//  ANSelectCheckInCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/1/18.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANSelectCheckInCell.h"

@interface ANSelectCheckInCell ()

/**
 *  内容视图
 */
@property (weak, nonatomic) IBOutlet UIView *substanceView;
/**
 *  左边的视图
 */
@property (weak, nonatomic) IBOutlet UIView *leftLabel;

@property (weak, nonatomic) IBOutlet UIImageView *addImg;
@property (weak, nonatomic) IBOutlet UIImageView *gouImg;
/**
 *  中间文字
 */
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
/**
 *  上部文字
 */
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
/**
 *  底部文字
 */
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *topTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomTextLabel;

@end

@implementation ANSelectCheckInCell

+ (ANSelectCheckInCell *)selectCheckInCell:(UITableView *)tableView
{
    ANSelectCheckInCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANSelectCheckInCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setModel:(ANSelectCheckInModel *)model
{
    if (_model != model) {
        _model = model;
    }
    
    self.substanceView.layer.borderWidth = 1;
    self.substanceView.layer.borderColor = [UIColor colorWithRed:0.8706 green:0.8706 blue:0.8706 alpha:1.0].CGColor;
    self.substanceView.layer.cornerRadius = 3;
    self.substanceView.layer.masksToBounds = YES;
    
    if ([model.res_name isEqualToString:@"old_machine"]) {
        self.leftImage.image = [UIImage imageNamed:@"Device1"];
    }else if ([model.res_name isEqualToString:@"machine"]) {
        self.leftImage.image = [UIImage imageNamed:@"Device2"];
    }else if ([model.res_name isEqualToString:@"adbox"]) {
        self.leftImage.image = [UIImage imageNamed:@"Device3"];
    }else if ([model.res_name isEqualToString:@"ibeacon"]) {
        self.leftImage.image = [UIImage imageNamed:@"Device4"];
    }else if ([model.res_name isEqualToString:@"game_table"]) {
        self.leftImage.image = [UIImage imageNamed:@"Device5"];
    }
//    self.leftImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"Device%ld",indexPath.row + 1]];
    self.bottomTextLabel.text = model.device_num_str;
//    self.centerLabel.text = [NSString stringWithFormat:@"添加设备串码\n%@",model.device_num_str];
    
}

//- (void)setIndexPath:(NSIndexPath *)indexPath   //86 91
//{
//    if (_indexPath == nil) {
//        _indexPath = indexPath;
//    }
//    
//    self.substanceView.layer.borderWidth = 1;
//    self.substanceView.layer.borderColor = [UIColor colorWithRed:0.8706 green:0.8706 blue:0.8706 alpha:1.0].CGColor;
//    self.substanceView.layer.cornerRadius = 3;
//    self.substanceView.layer.masksToBounds = YES;
//    
//    self.leftImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"Device%ld",indexPath.row + 1]];
//    
//    if ([self.model.status isEqualToString:@""] || [self.model.status isEqualToString:@"1"]) {
//        self.gouImg.hidden = YES;
//        self.topLabel.hidden = YES;
//        self.bottomLabel.hidden = YES;
//    }else if ([self.model.status isEqualToString:@"2"]){
//        self.addImg.hidden = YES;
//        self.bottomLabel.text = [NSString stringWithFormat:@"设备串号:%@",self.model.device_no];
//        self.centerLabel.hidden = YES;
//    }
//}

@end

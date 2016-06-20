//
//  ANActivityMessageCell.m
//  baobaotang
//
//  Created by 高赛 on 15/12/9.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANActivityMessageCell.h"

@interface ANActivityMessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activityImg;

@end

@implementation ANActivityMessageCell

+ (instancetype)activityMessageTableView:(UITableView *)tableView
{
    ANActivityMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activity"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANActivityMessageCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setModel:(ANActivityModel *)model
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:model.add_time];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",dateStr,model.title];
    [self.activityImg sd_setImageWithURL:[NSURL URLWithString:model.preview_pic]];
//    ANLog(@"%@,%@",model.title,model.preview_pic);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

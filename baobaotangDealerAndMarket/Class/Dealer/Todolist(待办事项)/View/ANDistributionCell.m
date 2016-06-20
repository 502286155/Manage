//
//  ANDistributionCell.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/23.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANDistributionCell.h"

@interface ANDistributionCell()

/**
 *  时间label
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *  订单状态label
 */
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
/**
 *  签约人员
 */
@property (weak, nonatomic) IBOutlet UILabel *nameSignedLabel;
/**
 *  开始处理按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *beginSendBtn;
/**
 *  查看详情按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *seeDetailBtn;
/**
 *  配送完成按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *endSendBtn;
/**
 *  姓名Label
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  电话Label
 */
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
/**
 *  地址Label
 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
/**
 *  标题Label
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *  子视图
 */
@property (weak, nonatomic) IBOutlet UIView *childView;
/**
 *  完成视图
 */
@property (weak, nonatomic) IBOutlet UIView *endView;
/**
 *  处理Label
 */
@property (weak, nonatomic) IBOutlet UILabel *processLabel;
/**
 *  联系Label
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/**
 *  任务状态
 */
@property (weak, nonatomic) IBOutlet UILabel *taskStatusLabel;
/**
 *  撤销订单
 */
@property (weak, nonatomic) IBOutlet UILabel *undoOrderLabel;
/**
 *  底部视图订单状态
 */
@property (weak, nonatomic) IBOutlet UILabel *endOrderStatus;

@end

@implementation ANDistributionCell

+ (instancetype)distributionTableView:(UITableView *)tableView
{
    ANDistributionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"distributionCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANDistributionCell" owner:nil options:nil].lastObject;
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

//- (void)setIndexPath:(NSIndexPath *)indexPath
//{
//    if (_indexPath != indexPath) {
//        _indexPath = indexPath;
//    }
//    self.childView.layer.cornerRadius = 5;
//    self.childView.layer.masksToBounds = YES;
//    self.seeDetailBtn = [ANCommon setBtnRadiusAndBorder:self.seeDetailBtn];
//    self.endSendBtn = [ANCommon setBtnRadiusAndBorder:self.endSendBtn];
//    self.endView.hidden = YES;
//    if (_indexPath.row == 1) {
//        [self.endSendBtn setBackgroundColor:[UIColor colorWithRed:0.8745 green:0.2039 blue:0.3608 alpha:1.0]];
//        [self.endSendBtn setTitle:@"配送完成" forState:UIControlStateNormal];
//        self.orderStatusLabel.text = @"配送";
//    }
//    if (_indexPath.row == 2) {
//        self.endView.hidden = NO;
//        self.seeDetailBtn.hidden = YES;
//        self.endSendBtn.hidden = YES;
//        self.orderStatusLabel.text = @"到货";
//    }
//    if (_indexPath.row == 3) {
//        self.endView.hidden = NO;
//        self.seeDetailBtn.hidden = YES;
//        self.endSendBtn.hidden = YES;
//        self.processLabel.hidden = YES;
//        self.phoneLabel.hidden = YES;
//        self.endOrderStatus.hidden = YES;
//        self.undoOrderLabel.hidden = NO;
//        self.orderStatusLabel.text = @"撤单";
//    }
//    if (_indexPath.row == 4) {
//        self.endView.hidden = NO;
//        self.seeDetailBtn.hidden = YES;
//        self.endSendBtn.hidden = YES;
//        self.orderStatusLabel.text = @"配送";
//        self.endOrderStatus.text = @"处理";
//        self.taskStatusLabel.text = @"正在配送";
//    }
//    if (_indexPath.row == 5) {
//        self.endView.hidden = NO;
//        self.seeDetailBtn.hidden = YES;
//        self.endSendBtn.hidden = YES;
//        self.orderStatusLabel.text = @"到货";
//        self.endOrderStatus.text = @"送货完成";
//        self.taskStatusLabel.text = @"任务结束";
//    }
//    if (_indexPath.row == 6) {
//        self.endView.hidden = NO;
//        self.seeDetailBtn.hidden = YES;
//        self.endSendBtn.hidden = YES;
//        self.processLabel.text = @"指派: 高赛";
//        self.endOrderStatus.hidden = YES;
//        self.taskStatusLabel.text = @"等待响应";
//    }
//    if (_indexPath.row == 7) {
//        self.endView.hidden = NO;
//        self.seeDetailBtn.hidden = YES;
//        self.endSendBtn.hidden = YES;
//        self.processLabel.text = @"指派: 高赛";
//        self.endOrderStatus.hidden = YES;
//        self.taskStatusLabel.text = @"已发短信";
//    }
//}
- (void)setModel:(ANDistributionListModel *)model
{
    if (_model != model) {
        _model = model;
    }
    // 谁签约
    self.nameSignedLabel.text = [NSString stringWithFormat:@"%@签约",model.storeInfo.marketingUserInfo.realname];
    // 店名
    self.titleLabel.text = [NSString stringWithFormat:@"%@·%@",model.storeInfo.title,model.storeInfo.title_branch];
    // 店长名字
    self.nameLabel.text = [NSString stringWithFormat:@"%@ | Tel:%@ | %@",model.storeInfo.storeUserInfo.realname,model.storeInfo.storeUserInfo.mobile,model.storeInfo.address];
    NSString *typeID = [[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"];
    if ([typeID isEqualToString:@"5"]) {
        [self setDealerModel:model];
    }else if ([typeID isEqualToString:@"10"]) {
        [self setMarkerModel:model];
    }
}
// 设置经销商
- (void)setDealerModel:(ANDistributionListModel *)model
{
    if ([model.progress isEqualToString:@"1"]) {                //等待配送
        if ([model.is_assigned isEqualToString:@"0"]) {         //未指派人员
            // 时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [formatter dateFromString:model.add_time];
            [formatter setDateFormat:@"MM-dd HH:mm"];
            self.timeLabel.text = [formatter stringFromDate:date];
            // 订单状态
            self.orderStatusLabel.text = @"下单";
            self.childView.layer.cornerRadius = 5;
            self.childView.layer.masksToBounds = YES;
//            self.seeDetailBtn = [ANCommon setBtnRadiusAndBorder:self.seeDetailBtn];
//            self.endSendBtn = [ANCommon setBtnRadiusAndBorder:self.endSendBtn];
            self.seeDetailBtn.hidden = YES;
            self.endSendBtn.hidden = YES;
            self.beginSendBtn = [ANCommon setBtnRadiusAndBorder:self.beginSendBtn];
            self.beginSendBtn.hidden = NO;
            self.endView.hidden = YES;
        }else if ([model.is_assigned isEqualToString:@"1"]) {   //已指派人员
            // 时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [formatter dateFromString:model.add_time];
            [formatter setDateFormat:@"MM-dd HH:mm"];
            self.timeLabel.text = [formatter stringFromDate:date];
            // 订单状态
            self.orderStatusLabel.text = @"下单";
            // 信息视图
            self.endView.hidden = NO;
            // 查看详情按钮
            self.seeDetailBtn.hidden = YES;
            // 配送/处理按钮
            self.endSendBtn.hidden = YES;
            // 任务状态
            self.endOrderStatus.hidden = YES;
            if (![self.model.assigned_id isEqualToString:@"0"]) {  //指派自己去配送
                // 指派人姓名
                self.processLabel.text = [NSString stringWithFormat:@"指派:%@",self.model.assignUserModel.realname];
                // 指派人电话
                self.phoneLabel.text = [NSString stringWithFormat:@"Tel:%@",self.model.assignUserModel.mobile];
                self.taskStatusLabel.text = @"等待响应";
            }else {                                                //指派第三方人员配送
                // 指派人姓名
                self.processLabel.text = [NSString stringWithFormat:@"指派:%@",self.model.other_assigned_name];
                // 指派人电话
                self.phoneLabel.text = [NSString stringWithFormat:@"Tel:%@",self.model.other_assigned_mobile];
                self.taskStatusLabel.text = @"正在配送";
            }
        }
    }else if ([model.progress isEqualToString:@"5"]) {              // 正在配送
        // 时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:model.deliver_time];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        self.timeLabel.text = [formatter stringFromDate:date];
        // 上面的订单状态
        self.orderStatusLabel.text = @"配送";
        
        if (![self.model.assigned_id isEqualToString:@"0"]) {       // 指派自己配送
            if ([self.model.assignUserModel.ID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]])
            {
                self.beginSendBtn.hidden = YES;
                self.childView.layer.cornerRadius = 5;
                self.childView.layer.masksToBounds = YES;
                self.seeDetailBtn = [ANCommon setBtnRadiusAndBorder:self.seeDetailBtn];
                self.endSendBtn = [ANCommon setBtnRadiusAndBorder:self.endSendBtn];
                self.endView.hidden = YES;
                [self.endSendBtn setBackgroundColor:[UIColor colorWithRed:0.6908 green:0.0 blue:0.0142 alpha:1.0]];
                [self.endSendBtn setTitle:@"确认送达" forState:UIControlStateNormal];
                self.orderStatusLabel.text = @"配送";
            }else {
                // 信息视图
                self.endView.hidden = NO;
                // 查看详情按钮
                self.seeDetailBtn.hidden = YES;
                // 配送/处理按钮
                self.endSendBtn.hidden = YES;
                // 任务状态
                self.endOrderStatus.hidden = YES;
                // 指派人姓名
                self.processLabel.text = [NSString stringWithFormat:@"%@",self.model.assignUserModel.realname];
                // 指派人电话
                self.phoneLabel.text = [NSString stringWithFormat:@"Tel:%@",self.model.assignUserModel.mobile];
                // 任务状态
                self.endOrderStatus.hidden = NO;
                self.endOrderStatus.text = @"处理";
                self.taskStatusLabel.text = @"正在配送";
            }
        }else {                                                     // 指派第三方配送
            // 信息视图
            self.endView.hidden = NO;
            // 查看详情按钮
            self.seeDetailBtn.hidden = YES;
            // 配送/处理按钮
            self.endSendBtn.hidden = YES;
            // 任务状态
//            self.endOrderStatus.hidden = YES;
            // 指派人姓名
            self.processLabel.text = [NSString stringWithFormat:@"指派:%@",self.model.other_assigned_name];
            // 指派人电话
            self.phoneLabel.text = [NSString stringWithFormat:@"Tel:%@",self.model.other_assigned_mobile];
            self.taskStatusLabel.text = @"已发短信";
            self.endOrderStatus.text = @"处理";
        }
    }else if ([model.progress isEqualToString:@"10"]) {             // 配送完成
        // 时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:model.receiver_time];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        self.timeLabel.text = [formatter stringFromDate:date];
        // 上面的状态
        self.orderStatusLabel.text = @"到货";
        // 信息视图
        self.endView.hidden = NO;
        // 查看详情按钮
        self.seeDetailBtn.hidden = YES;
        // 配送/处理按钮
        self.endSendBtn.hidden = YES;
        // 任务状态
        self.endOrderStatus.hidden = NO;
        self.endOrderStatus.text = @"送货完成";
        // 后面任务状态
        if ([model.is_pay isEqualToString:@"1"]) {
            self.taskStatusLabel.text = @"已付款";
        }else {
            self.taskStatusLabel.text = @"未付款";
            self.taskStatusLabel.textColor = [UIColor redColor];
        }
        if (![self.model.assigned_id isEqualToString:@"0"]) {       //指派自己配送
            // 指派人姓名
            self.processLabel.text = [NSString stringWithFormat:@"%@",self.model.assignUserModel.realname];
            // 指派人电话
            self.phoneLabel.text = [NSString stringWithFormat:@"Tel:%@",self.model.assignUserModel.mobile];
        }else {                                                     //指派第三方配送
            // 指派人姓名
            self.processLabel.text = [NSString stringWithFormat:@"%@",self.model.other_assigned_name];
            // 指派人电话
            self.phoneLabel.text = [NSString stringWithFormat:@"Tel:%@",self.model.other_assigned_mobile];
        }
    }else if ([model.progress isEqualToString:@"15"]) {             //订单撤销
        // 时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:model.cancel_order_time];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        self.timeLabel.text = [formatter stringFromDate:date];
        
        self.endView.hidden = NO;
        self.seeDetailBtn.hidden = YES;
        self.endSendBtn.hidden = YES;
        self.processLabel.hidden = YES;
        self.phoneLabel.hidden = YES;
        self.endOrderStatus.hidden = YES;
        self.undoOrderLabel.text = [NSString stringWithFormat:@"%@撤销订单",self.model.cancel_order_type];
        self.undoOrderLabel.hidden = NO;
        self.orderStatusLabel.text = @"撤单";
    }
}
- (void)setMarkerModel:(ANDistributionListModel *)model
{
    if ([model.progress isEqualToString:@"1"]) {        // 等待配送
        // 时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:model.add_time];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        self.timeLabel.text = [formatter stringFromDate:date];
        // 订单状态
        self.orderStatusLabel.text = @"下单";
        if ([model.assigned_id isEqualToString:@"0"]) { // 已经指派第三人配送
            // 指派人姓名
            self.processLabel.text = [NSString stringWithFormat:@"指派:%@",self.model.other_assigned_name];
            // 指派人电话
            self.phoneLabel.text = [NSString stringWithFormat:@"Tel:%@",self.model.other_assigned_mobile];
            self.taskStatusLabel.text = @"已发短信";
            self.endOrderStatus.text = @"处理";
        }else if ([model.assignUserModel.ID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]) { // 指派自己等待响应
            self.childView.layer.cornerRadius = 5;
            self.childView.layer.masksToBounds = YES;
            self.seeDetailBtn = [ANCommon setBtnRadiusAndBorder:self.seeDetailBtn];
            self.endSendBtn = [ANCommon setBtnRadiusAndBorder:self.endSendBtn];
            self.endView.hidden = YES;
            [self.beginSendBtn setTitle:@"开始配送" forState:UIControlStateNormal];
        }else { //  指派给其他市场人员处理
            // 指派人姓名
            self.processLabel.text = [NSString stringWithFormat:@"指派:%@",self.model.assignUserModel.realname];
            // 指派人电话
            self.phoneLabel.text = [NSString stringWithFormat:@"Tel:%@",self.model.assignUserModel.mobile];
            self.taskStatusLabel.text = @"等待响应";
            self.endOrderStatus.text = @"处理";
        }
    }else if ([model.progress isEqualToString:@"5"]) {  // 配送中
        // 时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:model.deliver_time];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        self.timeLabel.text = [formatter stringFromDate:date];
        // 上面的订单状态
        self.orderStatusLabel.text = @"配送";
        if ([model.assigned_id isEqualToString:@"0"]) { // 已经指派第三方人员配送
            // 指派人姓名
            self.processLabel.text = [NSString stringWithFormat:@"指派:%@",self.model.other_assigned_name];
            // 指派人电话
            self.phoneLabel.text = [NSString stringWithFormat:@"Tel:%@",self.model.other_assigned_mobile];
            self.taskStatusLabel.text = @"已发短信";
            self.endOrderStatus.hidden = NO;
            self.endOrderStatus.text = @"处理";
        }else if ([model.assignUserModel.ID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]) {                                         // 指派自己配送
            self.childView.layer.cornerRadius = 5;
            self.childView.layer.masksToBounds = YES;
            self.beginSendBtn.hidden = YES;
            self.seeDetailBtn = [ANCommon setBtnRadiusAndBorder:self.seeDetailBtn];
            self.endSendBtn = [ANCommon setBtnRadiusAndBorder:self.endSendBtn];
            self.endView.hidden = YES;
            [self.endSendBtn setBackgroundColor:[UIColor colorWithRed:0.6908 green:0.0 blue:0.0142 alpha:1.0]];
            [self.endSendBtn setTitle:@"确认送达" forState:UIControlStateNormal];
            self.orderStatusLabel.text = @"配送";
        }else {
            // 指派人姓名
            self.processLabel.text = [NSString stringWithFormat:@"指派:%@",self.model.assignUserModel.realname];
            // 指派人电话
            self.phoneLabel.text = [NSString stringWithFormat:@"Tel:%@",self.model.assignUserModel.mobile];
            self.taskStatusLabel.text = @"正在配送";
            self.endOrderStatus.hidden = NO;
            self.endOrderStatus.text = @"处理";
        }
    }else if ([model.progress isEqualToString:@"10"]) { // 配送完成
        // 时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:model.receiver_time];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        self.timeLabel.text = [formatter stringFromDate:date];
        // 上面的状态
        self.orderStatusLabel.text = @"到货";
        // 信息视图
        self.endView.hidden = NO;
        // 查看详情按钮
        self.seeDetailBtn.hidden = YES;
        // 配送/处理按钮
        self.endSendBtn.hidden = YES;
        // 任务状态
        self.endOrderStatus.hidden = NO;
        self.endOrderStatus.text = @"送货完成";
        // 后面任务状态
        if ([model.is_pay isEqualToString:@"1"]) {
            self.taskStatusLabel.text = @"已付款";
        }else {
            self.taskStatusLabel.text = @"未付款";
            self.taskStatusLabel.textColor = [UIColor redColor];
        }
        if ([model.assigned_id isEqualToString:@"0"]) { // 指派第三方配送
            // 指派人姓名
            self.processLabel.text = [NSString stringWithFormat:@"%@",self.model.other_assigned_name];
            // 指派人电话
            self.phoneLabel.text = [NSString stringWithFormat:@"Tel:%@",self.model.other_assigned_mobile];
        }else if ([model.storeInfo.marketingUserInfo.ID isEqualToString:model.assignUserModel.ID]) {                                         //  指派自己配送
            // 指派人姓名
            self.processLabel.text = [NSString stringWithFormat:@"%@",self.model.storeInfo.marketingUserInfo.realname];
            // 指派人电话
            self.phoneLabel.text = [NSString stringWithFormat:@"Tel:%@",self.model.storeInfo.marketingUserInfo.mobile];
        }else {     // 指派其他市场人员配送
            self.processLabel.text = self.model.assignUserModel.realname;
            self.phoneLabel.text = [NSString stringWithFormat:@"Tel:%@",self.model.assignUserModel.mobile];
        }
    }else if ([model.progress isEqualToString:@"15"]) {
        // 时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:model.cancel_order_time];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        self.timeLabel.text = [formatter stringFromDate:date];
        
        self.endView.hidden = NO;
        self.seeDetailBtn.hidden = YES;
        self.endSendBtn.hidden = YES;
        self.processLabel.hidden = YES;
        self.phoneLabel.hidden = YES;
        self.endOrderStatus.hidden = YES;
        self.undoOrderLabel.text = [NSString stringWithFormat:@"%@撤销订单",self.model.cancel_order_type];
        self.undoOrderLabel.hidden = NO;
        self.orderStatusLabel.text = @"撤单";
    }
}

- (IBAction)clickSeeDetailBtn:(id)sender {
    ANLog(@"查看详情");
    if ([self.delegate respondsToSelector:@selector(distributioncell:clickSeeDetailBtn:)]) {
        [self.delegate distributioncell:self clickSeeDetailBtn:sender];
    }
}
- (IBAction)clickEndSendBtn:(id)sender {
    ANLog(@"结束配送");
    if ([self.delegate respondsToSelector:@selector(distributioncell:clickEndSendBtn:)]) {
        [self.delegate distributioncell:self clickEndSendBtn:sender];
    }
}

@end

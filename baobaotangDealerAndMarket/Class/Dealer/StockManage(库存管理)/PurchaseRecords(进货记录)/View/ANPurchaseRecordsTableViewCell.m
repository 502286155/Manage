//
//  ANPurchaseRecordsTableViewCell.m
//  baobaotang
//
//  Created by Eric on 15/11/5.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANPurchaseRecordsTableViewCell.h"

@interface ANPurchaseRecordsTableViewCell()

/**
 *  确认到货按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/**
 *  内容Label
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**
 *  时间Label
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *  订单号Label
 */
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
/**
 *  价格Label
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/**
 *  数量款数Label
 */
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
/**
 *  订单的状态   1=>等待配送 5=>配送中 10=>配送完成
 */
@property (nonatomic, assign) int orderType;
@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (weak, nonatomic) IBOutlet UIButton *logisticsBtn;

@end

@implementation ANPurchaseRecordsTableViewCell


/**
 *  cell的快速创建
 */
+ (instancetype)purchaseRecordsTableViewCell:(UITableView *)table
{
    static NSString *ID = @"purchaseRecords";
    ANPurchaseRecordsTableViewCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell  =[[[NSBundle mainBundle] loadNibNamed:@"ANPurchaseRecordsTableViewCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}


- (void)awakeFromNib
{
    self.sureBtn = [ANCommon setBtnRadiusAndBorder:self.sureBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ANPurchaseRecordsModel *)model
{
    if (_model != model) {
        _model = model;
    }
    self.logisticsBtn.layer.borderWidth = 1;
    self.logisticsBtn.layer.cornerRadius = 5;
    self.logisticsBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.logisticsBtn.layer.masksToBounds = YES;
    self.timeLabel.text = _model.add_time;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元", _model.price];
    self.orderLabel.text = [NSString stringWithFormat:@"单号:%@", _model.ID];
    self.numLabel.text = [NSString stringWithFormat:@"%@箱/%@款", _model.goods_num,_model.goods_type_num];
    if ([_model.progress isEqualToString:@"10"]) {  // 配送完成
        self.orderType = 10;
        self.finishLabel.hidden = NO;
        self.contentLabel.textColor = ANColor(94, 94, 94);
        self.contentLabel.text = @"订单完成 您已确认完成收货";
    }else if ([_model.progress isEqualToString:@"1"]) { //等待配送
#pragma mark 支付凭证
        self.orderType = 1;
        self.sureBtn.hidden = NO;
        [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.7178 green:0.0 blue:0.0152 alpha:1.0]];
        [self.sureBtn setTitle:@"撤销订单" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.contentLabel.text = @"下单成功,上传凭证后将立即发货";
        if ([self.model.is_payoff isEqualToString:@"1"]) {  // 支付凭证已上传
            self.logisticsBtn.hidden = YES;
            self.contentLabel.text = @"凭证确认成功 正在等待总部发货";
        }else {                                             // 未上传支付凭证
            self.logisticsBtn.hidden = NO;
            if ([self.model.payoff_person isEqualToString:@"暂无"]) {
                [self.logisticsBtn setTitle:@"上传凭证" forState:UIControlStateNormal];
            }else  {
                [self.logisticsBtn setTitle:@"编辑凭证" forState:UIControlStateNormal];
                self.contentLabel.text = @"已提交付款凭证 等待总部确认后发货";
            }
        }
    }else if ([_model.progress isEqualToString:@"5"]) {     // 配送中
#pragma mark 查看物流
        self.logisticsBtn.hidden = NO;
        self.orderType = 5;
        self.sureBtn.hidden = NO;
        [self.sureBtn setBackgroundColor:[UIColor colorWithRed:0.2118 green:0.1216 blue:0.3059 alpha:1.0]];
        self.contentLabel.text = @"正在配送 请注意收货后确认";
    }else if ([_model.progress isEqualToString:@"3"]){      // 付款成功还未配送
        self.finishLabel.hidden = NO;
        self.finishLabel.text = @"等待配送";
        self.contentLabel.text = @"付款成功 仓库正在安排发货";
    }
}

- (void)setIsBool:(BOOL)isBool
{
    if (_isBool != isBool) {
        _isBool = isBool;
    }
    if (_isBool) {
        [self.sureBtn setBackgroundColor:ANColor(84, 50, 119)];
        [self.sureBtn setTitle:@"再次进货" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.contentLabel.textColor = ANColor(94, 94, 94);
        self.contentLabel.text = @"已付款 已到货";
    }
}
- (IBAction)clickBtn:(id)sender {
    self.sureBtn.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(purchaseRecordsCell:clickBtn:orderType:orderID:)]) {
        [self.delegate purchaseRecordsCell:self clickBtn:sender orderType:self.orderType orderID:self.model.ID];
    }
}

- (IBAction)clickLogisticsBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(purchaseRecordsCell:clickLogisticsBtn:withModel:)]) {
        [self.delegate purchaseRecordsCell:self clickLogisticsBtn:sender withModel:self.model];
    }
}


@end

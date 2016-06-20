//
//  ANSubmitOrderesTableViewCell.m
//  baobaotang
//
//  Created by Eric on 15/11/4.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANSubmitOrderesTableViewCell.h"
#import "ANSubmitPurchasesModel.h"

@interface ANSubmitOrderesTableViewCell ()

/**
 *  商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

/**
 *  商品标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 *  商品介绍
 */
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

/**
 *  商品价格
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

/**
 *  商品数量
 */
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation ANSubmitOrderesTableViewCell





- (void)awakeFromNib {
    // Initialization code
}

/**
 *  cell的快速创建
 */
+ (instancetype)submitOrderTableViewCell:(UITableView *)table
{
    static NSString *ID = @"submitOrder";
    ANSubmitOrderesTableViewCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell  =[[[NSBundle mainBundle] loadNibNamed:@"ANSubmitOrderesTableViewCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
    
}


- (void)setModel:(ANSubmitPurchasesModel *)model
{
    if (_model != model) {
        _model = model;
    }
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:_model.cover] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    self.titleLabel.text = _model.title;
    self.introLabel.text = _model.intro;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元", _model.price];
    self.countLabel.text = [NSString stringWithFormat:@"数量 %ld箱", _model.goods_num];
}

- (void)setOrderListModel:(ANPurchaseOrderListModel *)orderListModel
{
    if (_orderListModel != orderListModel) {
        _orderListModel = orderListModel;
    }
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:orderListModel.goods_info[@"cover"]] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    self.titleLabel.text = orderListModel.goods_info[@"title"];
    self.introLabel.text = orderListModel.goods_info[@"intro"];
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",orderListModel.real_price];
    self.countLabel.text = [NSString stringWithFormat:@"数量 %@箱",orderListModel.goods_num];
}


@end

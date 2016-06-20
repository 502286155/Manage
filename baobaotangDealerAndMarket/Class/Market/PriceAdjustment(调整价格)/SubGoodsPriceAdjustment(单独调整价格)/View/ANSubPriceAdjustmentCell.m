//
//  ANPurchasesTableViewCell.m
//  baobaotang
//
//  Created by 高赛 on 15/11/30.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANSubPriceAdjustmentCell.h"

@interface ANSubPriceAdjustmentCell() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *prichLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UILabel *suggestPriceLabel;

/**
 *  价格的父视图
 */
@property (weak, nonatomic) IBOutlet UIView *PriceSuperView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UILabel *saleLabel;

@end

@implementation ANSubPriceAdjustmentCell

+ (instancetype)subPriceAdjustmentCellTableView:(UITableView *)tableView
{
    ANSubPriceAdjustmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ANSubPriceAdjustmentCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANSubPriceAdjustmentCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
//    self.subtractBtn.layer.borderWidth = 1;
//    self.addBtn.layer.borderWidth = 1;
    self.priceTextField.delegate = self;
    self.PriceSuperView.layer.borderColor = [UIColor colorWithRed:0.3447 green:0.3447 blue:0.3447 alpha:0.5].CGColor;
    
    
    [self.addBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headImg.layer.borderWidth = 1;
    self.headImg.layer.borderColor = [UIColor colorWithRed:0.8824 green:0.8824 blue:0.8824 alpha:0.5].CGColor;
//    self.subtractBtn.layer.borderColor = [UIColor colorWithRed:0.4196 green:0.4196 blue:0.4196 alpha:0.5].CGColor;
//    //    ANCOLOR(135, 135, 135, 1).CGColor;
//    self.addBtn.layer.borderColor = [UIColor colorWithRed:0.4196 green:0.4196 blue:0.4196 alpha:0.5].CGColor;
}

- (void)setPurchasesModel:(ANPurchasesModel *)purchasesModel
{
    if (_purchasesModel != purchasesModel) {
        _purchasesModel = purchasesModel;
    }
    
    self.indexPath = _purchasesModel.indexPath;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:_purchasesModel.cover] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ | %@", _purchasesModel.title, _purchasesModel.category_name];
    
    self.contentLabel.text = _purchasesModel.intro;
    
    self.prichLabel.text = [NSString stringWithFormat:@"%.1f元", [_purchasesModel.price floatValue]];
    
    self.suggestPriceLabel.text = [NSString stringWithFormat:@"建议定价:%@", _purchasesModel.market_price];
    if (_purchasesModel.puchasesCount < 1) {
        
    }else {
       
    }
//    if ([purchasesModel.is_sale intValue] == 0) {
//        [self.addBtn setImage:[UIImage imageNamed:@"add_icon2"] forState:UIControlStateNormal];
//        self.saleLabel.hidden = NO;
//        self.addBtn.enabled = NO;
//        self.prichLabel.hidden = YES;
//        
//    }
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.priceTextField.enabled = NO;
    }else {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.priceTextField.enabled = YES;
    }
}
- (void)setPurchasesNewModel:(ANNewPurchasesModel *)purchasesNewModel
{
    if (_purchasesNewModel != purchasesNewModel) {
        _purchasesNewModel = purchasesNewModel;
    }
    self.indexPath = _purchasesNewModel.indexPath;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:_purchasesNewModel.cover] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ | %@", _purchasesNewModel.title, _purchasesNewModel.category_name];
    
    self.contentLabel.text = _purchasesNewModel.intro;
    
    self.prichLabel.text = [NSString stringWithFormat:@"%.1f元", [_purchasesNewModel.skuList.price floatValue]];
    
    self.suggestPriceLabel.text = [NSString stringWithFormat:@"建议定价:%@", _purchasesNewModel.skuList.market_price];
}

- (void)buttonAction:(UIButton *)btn
{

    if ([self.delegate respondsToSelector:@selector(subPriceAdjustmentTableViewCell:button:priceText:indexPath:)]) {
        
        [self.delegate subPriceAdjustmentTableViewCell:self button:btn priceText:self.priceTextField.text indexPath:self.indexPath];
    }

}

/**
 *  限制输入小数点后两位
 */
bool isHaveDian = NO;

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian=NO;
    }
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0]; // 当前输入的字符
        if ((single >='0' && single<='9') || single=='.') // 数据格式正确
        {
            // 首字母不能为0和小数点
            if ([textField.text length] == 0) {
                if (single == '.' || single == '0') {
                    
                    textField.text = @"0.";
                    isHaveDian = YES;
                    return NO;
                }
            }
            if (single == '.') {
                if(!isHaveDian) { // text中还没有小数点
                
                    isHaveDian = YES;
                    return YES;
                } else {
//                    [self alertView:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            } else {
                if (isHaveDian) { //存在小数点
                
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    int tt = (int)range.location - (int)ran.location;
                    if (tt <= 1) {
                        return YES;
                    } else {
//                        [self alertView:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                } else {
                    return YES;
                }
            }
        } else { // 输入的数据格式不正确
//            [self alertView:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    } else {
        return YES;
    }
}

@end

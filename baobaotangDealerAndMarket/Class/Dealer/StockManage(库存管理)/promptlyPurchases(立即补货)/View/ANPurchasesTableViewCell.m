//
//  ANPurchasesTableViewCell.m
//  baobaotang
//
//  Created by 高赛 on 15/11/30.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANPurchasesTableViewCell.h"

@interface ANPurchasesTableViewCell() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *prichLabel;
@property (weak, nonatomic) IBOutlet UIButton *subtractBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
/**
 *  箱数
 */
@property (weak, nonatomic) IBOutlet UITextField *numTextField;

/**
 *  库存量
 */
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;


@end

@implementation ANPurchasesTableViewCell

+ (instancetype)purchasesTableView:(UITableView *)tableView
{
    ANPurchasesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ANPurchasesTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
//    self.subtractBtn.layer.borderWidth = 1;
//    self.addBtn.layer.borderWidth = 1;
    self.numLabel.layer.cornerRadius = 2;
    self.numLabel.layer.masksToBounds = YES;
    self.numLabel.layer.borderWidth = 1;
    self.numLabel.layer.borderColor = [UIColor colorWithRed:0.3447 green:0.3447 blue:0.3447 alpha:0.5].CGColor;
    
    self.subtractBtn.tag = ButtonTypeSubtract;
    self.addBtn.tag = ButtonTypeAdd;
    self.numTextField.delegate = self;
    
    [self.subtractBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
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
    
    self.prichLabel.text = [NSString stringWithFormat:@"%@元", _purchasesModel.price];
    
    self.stockLabel.text = [NSString stringWithFormat:@"%@箱", _purchasesModel.stock];
    
    if (_purchasesModel.puchasesCount != 0) {
        self.numTextField.text = [NSString stringWithFormat:@"%ld", (long)_purchasesModel.puchasesCount];
    }
    if (_purchasesModel.puchasesCount < 1) {
        [self.subtractBtn setImage:[UIImage imageNamed:@"subtract_iocn2"] forState:UIControlStateNormal];
        self.subtractBtn.enabled = NO;
    }else {
        [self.subtractBtn setImage:[UIImage imageNamed:@"subtract_iocn"] forState:UIControlStateNormal];
        self.subtractBtn.enabled = YES;
    }
    if ([purchasesModel.is_sale intValue] == 0) {
        [self.addBtn setImage:[UIImage imageNamed:@"add_icon2"] forState:UIControlStateNormal];
        self.saleLabel.hidden = NO;
        self.addBtn.enabled = NO;
        self.prichLabel.hidden = YES;
        self.numLabel.textColor = [UIColor colorWithRed:0.4747 green:0.4486 blue:0.5001 alpha:0.695576435810811];
    }
}

- (void)buttonAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(purchasesTableViewCell:button:indexPath:)]) {
        
        [self.delegate purchasesTableViewCell:self button:btn indexPath:self.indexPath];
    }
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(purchasesEditFinshedTextField:indexPath:)]) {
        [self.delegate purchasesEditFinshedTextField:textField indexPath:self.indexPath];
    }
}

- (IBAction)extSubButton:(id)sender {
    [self buttonAction:self.subtractBtn];
}

- (IBAction)extAddButton:(id)sender {
    [self buttonAction:self.addBtn];
}

@end

//
//  ANNewSelecteCupViewController.h
//  baobaotangDealerAndMarket
//
//  Created by Eric on 15/12/26.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UITextFieldCupType) {
    UITextFieldCupTypeSmall,
    UITextFieldCupTypeMiddle,
    UITextFieldCupTypeBig,
    UITextFieldCupTypeMoreBig,
    UITextFieldCupTypeSupperBig,
    UITextFieldCupTypePaperBag
};

@interface ANNewSelecteCupViewController : UIViewController

/**
 *  散装箱数
 */
@property (nonatomic, assign) NSInteger bulkCount;

/**
 *  数据源
 */
@property (nonatomic, strong) NSArray *dataArray;

/**
 *  总价
 */
@property (nonatomic, assign) float totalPrice;

/**
 *  总箱数
 */
@property (nonatomic, assign) NSInteger totalBox;
@property (nonatomic, copy) NSString *stordID;

@end

//
//  ANCommon.h
//  ACE
//
//  Created by Eric on 15/7/7.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ANCommon : NSObject

/**
 *  弹出提示框
 *
 *  @param message 提示信息
 */
+ (void)setAlertViewWithMessage:(NSString *)message;

/**
 *  弹出提示框(不带确认按钮)
 
 *
 *  @param message 提示信息
 */
- (void)setAlertView:(NSString *)message;

/**
 *  弹出带标题的提示框
 */
+ (void)setAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message andVC:(UIViewController *)viewController;
/**
 *  根据参数列表返回加密串
 */
+ (NSDictionary *)dicToSign:(NSDictionary *)dic;

/**
 *  获取用户token
 */
+ (NSString *)token;

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
/**
 *  设置UIButton的圆角与边框
 *
 *  @param view 要设置的控件
 *
 *  @return 设置好的控件
 */
+ (UIButton *)setBtnRadiusAndBorder:(UIButton *)btn;

/**
 *  设置Label的圆角与边框
 *
 *  @param view 要设置的控件
 *
 *  @return 设置好的控件
 */
+ (UILabel *)setRadiusAndBorder:(UILabel *)btn;

/**
 *  设置控件指定的圆角
 *
 *  @param view       需要设置的控件
 *  @param rectCorner 指定控件某个角
 */
+ (void)setDesignatRound:(UIView *)view rectCorner:(UIRectCorner)rectCorner;
/**
 *  在顶部弹出错误提示
 */
+ (UIView *)errorViewWithColor:(UIColor *)color Message:(NSString *)message;


@end

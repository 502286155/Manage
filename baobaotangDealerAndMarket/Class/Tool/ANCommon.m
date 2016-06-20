//
//  ANCommon.m
//  ACE
//
//  Created by Eric on 15/7/7.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import "ANCommon.h"
#import "NSDate+Expand.h"
#import "NSDictionary+Expand.h"

@interface ANCommon()

/**
 *  不带确认按钮的提示框
 */
@property (nonatomic, strong) UIAlertView *myAlert;

@end

@implementation ANCommon

/**
 *  网络请求参数构造(包括加密）
 *
 *  @param dic 原始字典数据
 *
 *  @return dic 组合完成的字典数据
 */
+ (NSDictionary *)dicToSign:(NSDictionary *)dic {
    
    NSString *signVals = [NSMutableString string];
    
    // 组合参数
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (![ANCommon token]) {
        [mutableDic setObject:PLATFORMID forKey:@"source"];
        [mutableDic setObject:[NSDate getTime] forKey:@"time"];
        [mutableDic setObject:PLATFORMKEY forKey:@"key"];
    } else {
        [mutableDic setObject:PLATFORMID forKey:@"source"];
        [mutableDic setObject:[NSDate getTime] forKey:@"time"];
        [mutableDic setObject:PLATFORMKEY forKey:@"key"];
        [mutableDic setObject:[ANCommon token] forKey:@"token"];
    }
    
    // 排序
    NSArray *paramsKeys = [self stringSort:mutableDic];
    if (paramsKeys) {
        for (NSString *key in paramsKeys) {
            NSString *val = [mutableDic objectForKey:key];
            // 过滤每个值中的空格
            val = [val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [mutableDic setObject:val forKey:key];
            signVals = [signVals stringByAppendingString:[NSString stringWithFormat:@"%@", val]];
        }
    }
    [mutableDic setObject:[signVals md5] forKey:@"sign"];
    [mutableDic setObject:@"manage" forKey:@"app_type"];
    [mutableDic setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"v"];
    // 令牌不用上传 只参与加密
    [mutableDic removeObjectForKey:@"key"];
    
    
    // 加密
    return mutableDic;
        
}

/**
 *  字典按照字母排序(升序)
 *
 *  @param dic 需要排序的字典
 *
 *  @return 返回排序完成的字典
 */
+ (NSArray *)stringSort:(NSDictionary *)dic{
    
    NSComparator cmptr = ^(id obj1, id obj2){
        if([[NSString stringWithFormat:@"%@",obj1] compare:[NSString stringWithFormat:@"%@",obj2] options:NSNumericSearch] > 0) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if([[NSString stringWithFormat:@"%@",obj1] compare:[NSString stringWithFormat:@"%@",obj2] options:NSNumericSearch] < 0) {
                return (NSComparisonResult)NSOrderedAscending;
            }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSMutableArray *arrKeys = (NSMutableArray *)[dic allKeys];
    
    NSArray *array = [arrKeys sortedArrayUsingComparator:cmptr];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSString *str in array) {
        [arr addObject:[dic objectForKey:str]];
    }
    
    return array;
}

/**
 *  获取用户token
 */
+ (NSString *)token
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}
/**
 *  弹出带标题的提示框
 */
+ (void)setAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message andVC:(UIViewController *)viewController
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:viewController cancelButtonTitle:@"呼叫" otherButtonTitles:@"取消", nil];
    [alertView show];
}
/**
 *  弹出提示框
 *
 *  @param message 提示信息
 */
+ (void)setAlertViewWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"确认"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}
/**
 *  弹出提示框(不带确认按钮)
 *
 *  @param message 提示信息
 */
- (void)setAlertView:(NSString *)message
{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
    self.myAlert = alertView;
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(performDismiss:) userInfo:nil repeats:NO];
    [alertView show];
    
}

/**
 *  设置Label的圆角与边框
 *
 *  @param view 要设置的控件
 *
 *  @return 设置好的控件
 */
+ (UILabel *)setRadiusAndBorder:(UILabel *)btn
{
    btn.layer.cornerRadius = 15;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor colorWithRed:235/255 green:240/255 blue:240/255 alpha:0.1].CGColor;
    return btn;
}
- (void)performDismiss:(NSTimer *)timer
{
    [self.myAlert dismissWithClickedButtonIndex:0 animated:YES];
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
/**
 *  设置UIButton的圆角与边框
 *
 *  @param view 要设置的控件
 *
 *  @return 设置好的控件
 */
+ (UIButton *)setBtnRadiusAndBorder:(UIButton *)btn
{
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor colorWithRed:235/255 green:240/255 blue:240/255 alpha:0.1].CGColor;
    return btn;
}
/**
 *  设置控件指定的圆角
 *
 *  @param view       需要设置的控件
 *  @param rectCorner 指定控件某个角
 */
+ (void)setDesignatRound:(UIView *)view rectCorner:(UIRectCorner)rectCorner
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}
+ (UIView *)errorViewWithColor:(UIColor *)color Message:(NSString *)message
{
    UIView *errorView = [[UIView alloc] initWithFrame:CGRectMake(0, -84, WIDTH, 64)];
    errorView.backgroundColor = color;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, WIDTH - 40, 44)];
    titleLabel.text = message;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.numberOfLines = 0;
    [errorView addSubview:titleLabel];
    return errorView;
}

@end

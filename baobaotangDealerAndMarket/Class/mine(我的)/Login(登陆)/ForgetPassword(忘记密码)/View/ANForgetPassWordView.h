//
//  ANForgetPassWordView.h
//  iZuChe
//
//  Created by 高赛 on 15/8/13.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ANForgetPassWordViewDelegate<NSObject>

/**
 *  获取验证码
 */
- (void)sendCaptcha:(NSString *)phone;

/**
 *  验证验证码
 */
- (void)sendCaptcha:(NSString *)phone verifyCode:(NSString *)verifyCode;

@end

@interface ANForgetPassWordView : UIView

/**
 *  代理
 */
@property (nonatomic, weak) id<ANForgetPassWordViewDelegate> delegate;

@end

//
//  ANForgetPassWordView.m
//  iZuChe
//
//  Created by 高赛 on 15/8/13.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import "ANForgetPassWordView.h"

@interface ANForgetPassWordView() <UITextFieldDelegate>

/**
 *  底层视图
 */
@property (nonatomic, strong) UIView *bottomView;
/**
 *  手机号
 */
@property (nonatomic, strong) UILabel *phoneLabel;
/**
 *  验证码
 */
@property (nonatomic, strong) UILabel *captchaLabel;
/**
 *  发送验证码按钮
 */
@property (nonatomic, strong) UIButton *sendCaptchaBtn;
/**
 *  手机号输入框
 */
@property (nonatomic, strong) UITextField *phoneText;
/**
 *  验证码输入框
 */
@property (nonatomic, strong) UITextField *captchaText;
/**
 *  按钮的下划线
 */
@property (nonatomic, strong) UILabel *promptLabel;
/**
 *  注册按钮
 */
@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation ANForgetPassWordView

/**
 *  初始化
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [ANNotificationCenter addObserver:self selector:@selector(setTime) name:@"setTime" object:nil];
        [self setSubView];
    }
    return self;
}

/**
 *  添加子视图
 */
- (void)setSubView
{
    [self addSubview:self.bottomView];
    
    [self addSubview:self.phoneLabel];
    [self addSubview:self.captchaLabel];
    
    [self addSubview:self.sendCaptchaBtn];
    
    [self addSubview:self.phoneText];
    [self addSubview:self.captchaText];
    
    [self.sendCaptchaBtn addSubview:self.promptLabel];
    [self addSubview:self.registerBtn];
}

#pragma mark ----懒加载
/**
 *  加载底部视图
 */
- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
// 手机号Label
- (UILabel *)phoneLabel
{
    if (_phoneLabel == nil) {
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
        _phoneLabel.text = @"     手机号:";
        _phoneLabel.textColor = ANColor(53, 32, 73);
        _phoneLabel.font = [UIFont systemFontOfSize:12];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(15, 49, WIDTH - 15, DEFALT_LINE_HEIGHT)];
        line.backgroundColor = DEFALT_LINE_COLOR;
        [_phoneLabel addSubview:line];
        
    }
    return _phoneLabel;
}
// 验证码Label
- (UILabel *)captchaLabel
{
    if (_captchaLabel == nil) {
        _captchaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 70, 50)];
        _captchaLabel.text = @"     验证码:";
        _captchaLabel.font = [UIFont systemFontOfSize:12];
        _captchaLabel.textColor = ANColor(53, 32, 73);
    }
    return _captchaLabel;
}
// 发送验证码button
- (UIButton *)sendCaptchaBtn
{
    if (_sendCaptchaBtn == nil) {
        _sendCaptchaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendCaptchaBtn.frame = CGRectMake(WIDTH - 95 - 15, 50, 95, 50);
//        [_sendCaptchaBtn setBackgroundColor:ANColor(88, 141, 169)];
        _sendCaptchaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sendCaptchaBtn setTitleColor:ANColor(53, 32, 73) forState:UIControlStateNormal];
        [_sendCaptchaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _sendCaptchaBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_sendCaptchaBtn addTarget:self action:@selector(clickSendCaptchaBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendCaptchaBtn;
}

// 按钮的下划线
- (UILabel *)promptLabel
{
    if (_promptLabel == nil) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 32, 59, 1)];
        _promptLabel.font = [UIFont systemFontOfSize:12];
        _promptLabel.backgroundColor = ANColor(53, 32, 73);
    }
    return _promptLabel;
}

// 手机号Text
- (UITextField *)phoneText
{
    if (_phoneText == nil) {
        _phoneText = [[UITextField alloc] initWithFrame:CGRectMake(70, 6, WIDTH - 15, 40)];
        _phoneText.font = [UIFont systemFontOfSize:12];
        _phoneText.placeholder = @"请输入您的手机号码";
        _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneText;
}
// 验证码Text
- (UITextField *)captchaText
{
    if (_captchaText == nil) {
        _captchaText = [[UITextField alloc] initWithFrame:CGRectMake(70, 6 + 50, WIDTH - 95 - 75 - 10, 40)];
        _captchaText.delegate = self;
        _captchaText.font = [UIFont systemFontOfSize:12];
        _captchaText.placeholder = @"请输入您的验证码";
        _captchaText.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _captchaText;
}


/**
 *  提交信息按钮
 */
- (UIButton *)registerBtn
{
    if (_registerBtn == nil) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.frame = CGRectMake(25, 143, WIDTH - 50, 44);
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _registerBtn.layer.cornerRadius = 3;
        _registerBtn.layer.masksToBounds = YES;
        [_registerBtn setTitle:@"获取新密码" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerBtn setBackgroundColor:[UIColor colorWithHexString:@"#d3d3d3"]];
        [_registerBtn addTarget:self action:@selector(clickRegisterBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

/**
 *  点击发送验证码按钮
 */
- (void)clickSendCaptchaBtn:(UIButton *)btn
{
    self.sendCaptchaBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.sendCaptchaBtn.enabled = YES;
    });
    if (self.phoneText.text.length != 11) {
        
    }
//    }else {
//        [self setTimeOut:60];
//        
//    }
    if ([self.delegate respondsToSelector:@selector(sendCaptcha:)]) {
        [self.delegate sendCaptcha:self.phoneText.text];
    }
}
- (void)setTime
{
    self.sendCaptchaBtn.enabled = NO;
    [self setTimeOut:60];
}

/**
 *  点击注册按钮
 */
- (void)clickRegisterBtn:(UIButton *)btn
{
    self.registerBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.registerBtn.enabled = YES;
    });
    if ([self.delegate respondsToSelector:@selector(sendCaptcha:verifyCode:)]) {
        [self.delegate sendCaptcha:self.phoneText.text verifyCode:self.captchaText.text];
    }
}

// 发送验证码后计时方法
- (void)setTimeOut:(int)longTime
{
    self.sendCaptchaBtn.enabled = NO;
    
    __block int timeout = longTime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            //dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.sendCaptchaBtn.enabled = YES;
                //设置界面的按钮显示 根据自己需求设置
                [self.sendCaptchaBtn setAttributedTitle:nil forState:UIControlStateNormal];
                [self.sendCaptchaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//                [_sendCaptchaBtn setBackgroundColor:ANColor(53, 32, 73)];
                [_sendCaptchaBtn setTitleColor:ANColor(53, 32, 73) forState:UIControlStateNormal];
            });
        }else{
            //int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"已发送 %ds", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strTime];
                [str addAttribute:NSForegroundColorAttributeName value:ANColor(53, 32, 73) range:NSMakeRange(0, 4)];
                [str addAttribute:NSForegroundColorAttributeName value:ANColor(53, 32, 73) range:NSMakeRange(4, str.length - 4)];
                
//                [self.sendCaptchaBtn setBackgroundColor:ANColor(239, 240, 241)];
                [self.sendCaptchaBtn setAttributedTitle:str forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.captchaText && string.length != 0) {
        self.registerBtn.backgroundColor = [UIColor colorWithHexString:@"#352049"];
    }
    
    return YES;
}















@end

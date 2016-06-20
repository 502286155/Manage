//
//  ANNavigationController.m
//  ACE
//
//  Created by Eric on 15/6/30.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import "ANNavigationController.h"

@interface ANNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation ANNavigationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 恢复自定义失去的手势功能
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = self;
    }
    
}

+ (void)setNavigationBarBlack:(UIViewController *)Controller
{
    
}
+ (void)setNavigationBarDefault:(UIViewController *)Controller
{
    
}

/**
 *  第一次使用这个类的时候调用（一个类只会调用一次）
 */
+ (void)initialize
{
    // 1.设置导航栏主题
    [self setupNavBarTheme];
    
    // 2.设置导航栏按钮主题
    [self setupBarButtonItemTheme];
    
}

/**
 *  设置导航栏按钮主题
 */
+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置背景
    if (iOS7) {
        
    } else {
//        [item setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [item setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_pushed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//        [item setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_disable"] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    }
    
    // 设置文字的属性
    //    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    //    textAttrs[UITextAttributeTextColor] = iOS7 ? [UIColor orangeColor] : [UIColor grayColor];
    //    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    //    textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize: iOS7 ? 15 : 13];
    //    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    //    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
    //
    //    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    //    disableTextAttrs[UITextAttributeTextColor] = [UIColor grayColor];
    //    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];

    // 这几行的方法以废弃
    //    textAttrs[UITextAttributeTextColor] = iOS7 ? [UIColor orangeColor] : [UIColor grayColor];
    //    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    //    textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:iOS7 ? 15 : 12];
    //使用这几行的方法来代替
    textAttrs[NSForegroundColorAttributeName] = iOS7 ? [UIColor grayColor] : [UIColor grayColor];
//    textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:iOS7 ? 15 : 12];
    // 结束
    
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
    
    //    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    //    disableTextAttrs[UITextAttributeTextColor] =  [UIColor lightGrayColor];
    //    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    
}

/**
 *  设置导航栏主题
 */
+ (void)setupNavBarTheme
{
    // 取出appearance对象
//    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 设置背景
    if (iOS7) {
        
    } else {
        
//        [navBar setBackgroundImage:[UIImage imageWithName:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    // 设置标题属性
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
//    textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
//    //Use NSShadowAttributeName with an NSShadow instance as the value
//    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:19];
//    [navBar setTitleTextAttributes:textAttrs];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:true];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count == 1) {
        self.interactivePopGestureRecognizer.enabled = NO;
    } else {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end

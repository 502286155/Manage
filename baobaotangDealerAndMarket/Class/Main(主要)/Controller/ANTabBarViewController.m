//
//  ANTabBarViewController.m
//  ACE
//
//  Created by Eric on 15/6/30.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import "ANTabBarViewController.h"
#import "ANTabBar.h"
#import "UIImage+AN.h"
#import "ANNavigationController.h"
//#import "ANHomeTableViewController.h"
//#import "ANPersonViewController.h"
//#import "ANTranslucentView.h"
//#import "ANNewProjectTaskViewController.h"
//#import "ANNewPriviceTaskViewController.h"
//#import "ANNewJobLogViewController.h"
//#import "ANNewAttendanceViewController.h"


@interface ANTabBarViewController ()<ANTabBarDelegate>

/**
 *  自定义的tabbar
 */
@property (nonatomic, weak) ANTabBar *customTabBar;

//@property (nonatomic, weak) ANTranslucentView *translucetView;
//@property (nonatomic, weak) ANTranslucentView *transView;

@end

@implementation ANTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化tabbar
    [self setupTabbar];
    
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
   
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
    
}

/**
 *  初始化tabbar
 */
- (void)setupTabbar
{
    ANTabBar *customTabBar = [[ANTabBar alloc] init];
    customTabBar.delegate = self;
    customTabBar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

/**
 *  监听tabbar按钮的状态
 *
 *  @param tabBar 原来选中的控制器
 *  @param from   最新选中的控制器
 */
- (void)tabBar:(ANTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to
{
    self.selectedIndex = to;
}


- (void)setupAllChildViewControllers
{
//    // 1.首页
//    ANHomeTableViewController *home = [[ANHomeTableViewController alloc] init];
//    [self setupChildViewController:home title:nil imageName:@"btn_home" selectedImageName:@"btn_home_selected"];
//    
//    // 4.我
//    ANPersonViewController *me = [[ANPersonViewController alloc] init];
//    [self setupChildViewController:me title:nil imageName:@"btn_user" selectedImageName:@"btn_user_selected"];
    
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    
    // 1.设置控制器的属性
    childVc.title = title;
    
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageWithName:imageName];
    
    // 设置选中图标
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    
    // 设置选中的图标
    if (iOS7) {
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = [UIImage imageWithName:selectedImageName];
    }
    
    // 2.包装一个导航控制器
    ANNavigationController *nav = [[ANNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

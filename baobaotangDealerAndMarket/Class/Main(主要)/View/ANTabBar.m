//
//  ANTabBar.m
//  ACE
//
//  Created by Eric on 15/6/30.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import "ANTabBar.h"
#import "ANTabBarButton.h"
#import "UIImage+AN.h"

@interface ANTabBar ()

@property (nonatomic, strong) NSMutableArray *tabBarButtons;
@property (nonatomic, weak) UIButton *plusButton;
@property (nonatomic, weak) ANTabBarButton *selectedButton;



@end

@implementation ANTabBar

- (NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (!iOS7) {
            
//            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"tabbar_background"]];
            self.backgroundColor = [UIColor whiteColor];
        }
        
        // 添加一个加号按钮
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button"] forState:UIControlStateNormal];
//        [plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
//        
        [plusButton setImage:[UIImage imageWithName:@"btn_publish"] forState:UIControlStateNormal];
        [plusButton setImage:[UIImage imageWithName:@"btn_publish"] forState:UIControlStateHighlighted];
        
//        plusButton.bounds = CGRectMake(0, 0, plusButton.currentBackgroundImage.size.width, plusButton.currentBackgroundImage.size.height);
        plusButton.bounds = CGRectMake(0, 0, 45, 45);
        [plusButton addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
        plusButton.backgroundColor = [UIColor whiteColor];
        [self addSubview:plusButton];
        self.plusButton = plusButton;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)plusButtonClick
{
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickedPlusButton:)]) {
        [self.delegate tabBarDidClickedPlusButton:self];
    }
}

- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    // 1.创建按钮
    ANTabBarButton *button = [ANTabBarButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    
    // 添加按钮到数组中
    [self.tabBarButtons addObject:button];
    
    // 2.设置数据
    button.item = item;
    
    // 3.监听按钮点击
    [button addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchDown];
    
    // 4.默认选中第0个按钮
    if (self.tabBarButtons.count == 1) {
        [self buttonClickedAction:button];
    }
    
}

/**
 *  监听按钮点击
 */
- (void)buttonClickedAction:(ANTabBarButton *)button
{
    // 1.通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:(int)self.selectedButton.tag to:(int)button.tag];
    }
    
    // 2.设置按钮的状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整加号按钮的位置
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    self.plusButton.center = CGPointMake(w * 0.5, h * 0.5);
    
    CGFloat buttonW = w / self.subviews.count;
    CGFloat buttonH = h;
    CGFloat buttonY = 0;
    
    for (int index = 0; index < self.tabBarButtons.count; index++) {
        
        // 1.取出按钮
        ANTabBarButton *button = self.tabBarButtons[index];
        
        // 2.设置按钮的frame
        CGFloat buttonX = index * buttonW;
        if (index > 0) {
            buttonX += buttonW;
        }
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 3.绑定tag
        button.tag = index;
    }
}

@end

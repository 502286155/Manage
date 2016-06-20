//
//  ANTabBar.h
//  ACE
//
//  Created by Eric on 15/6/30.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ANTabBar;

@protocol ANTabBarDelegate <NSObject>

@optional
- (void)tabBar:(ANTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;

- (void)tabBarDidClickedPlusButton:(ANTabBar *)tabBar;

@end

@interface ANTabBar : UIView

@property (nonatomic, weak) id<ANTabBarDelegate> delegate;




- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@end

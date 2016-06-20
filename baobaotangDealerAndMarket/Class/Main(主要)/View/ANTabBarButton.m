//
//  ANTabBarButton.m
//  ACE
//
//  Created by Eric on 15/6/30.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#define ANTabBarButtonImageRatio 0.6

// 按钮的默认文字颜色
#define ANTabBarButtonTitleColor (iOS7 ? [UIColor blackColor] : [UIColor whiteColor])
// 按钮的选中文字颜色
#define ANTabBarButtonTitleSelectedColor (iOS7 ? ANColor(212, 35, 27) : ANColor(212, 35, 27))


#import "ANTabBarButton.h"
#import "ANBadgeButton.h"
#import "UIImage+AN.h"

@interface ANTabBarButton ()

/**
 *  提醒数字
 */
@property (nonatomic, weak) ANBadgeButton *badgeButton;



@end

@implementation ANTabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 设置图片和文字居中
        self.imageView.contentMode = UIViewContentModeCenter;
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.font = [UIFont systemFontOfSize:11];
//        
//        [self setTitleColor:ANTabBarButtonTitleColor forState:UIControlStateNormal];
//        [self setTitleColor:ANTabBarButtonTitleSelectedColor forState:UIControlStateSelected];
        
        // 设置button的背景图片
        if (!iOS7) {// 非iOS7下，设置按钮选中时的背景
            [self setBackgroundImage:[UIImage imageWithName:@"tabbar_slider"] forState:UIControlStateSelected];
        }
        
        // 添加一个提醒数字按钮
        ANBadgeButton *badgeButton = [ANBadgeButton buttonWithType:UIButtonTypeCustom];
        
        badgeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self addSubview:badgeButton];
        self.badgeButton = badgeButton;
    }
    return self;
}

// 重写去掉高亮状态
- (void)setHighlighted:(BOOL)highlighted{
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * ANTabBarButtonImageRatio;
    return CGRectMake(0, 10, imageW, imageH);
}

//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    CGFloat titleW = contentRect.size.width;
//    CGFloat titleH = contentRect.size.height * (1 - ANTabBarButtonImageRatio);
//    CGFloat titleY = contentRect.size.height * ANTabBarButtonImageRatio;
//    return CGRectMake(0, titleY, titleW, titleH);
//}

- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    // KVO 监听属性改变
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    
    //
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

/**
 *  在self被销毁的时候移除监听
 */
- (void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
    
}

/**
 *  监听到某个对象的属性改变了，就会调用
 *
 *  @param keyPath 属性名
 *  @param object  哪个对象的属性被改变
 *  @param change  属性发生的改变
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
//    [self setTitle:self.item.title forState:UIControlStateNormal];
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    
    // 设置提醒数字
    self.badgeButton.badgeValue = self.item.badgeValue;
    
    // 设置提醒数字的位置
    CGFloat badgeY = 5;
    CGFloat badgeX = self.frame.size.width - self.badgeButton.frame.size.width - 10;
    CGRect badgeF = self.badgeButton.frame;
    badgeF.origin.x = badgeX;
    badgeF.origin.y = badgeY;
    self.badgeButton.frame = badgeF;
    
}


@end

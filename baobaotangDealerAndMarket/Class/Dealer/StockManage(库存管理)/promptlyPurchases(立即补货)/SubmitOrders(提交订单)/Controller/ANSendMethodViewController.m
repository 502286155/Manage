//
//  ANSendMethodViewController.m
//  baobaotang
//
//  Created by 高赛 on 15/11/26.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANSendMethodViewController.h"

@interface ANSendMethodViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondImg;
@property (weak, nonatomic) IBOutlet UIImageView *thridImg;
@property (nonatomic, assign) int selectNum;


@end

@implementation ANSendMethodViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"经销商进货配送方式页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"经销商进货配送方式页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];
    self.selectNum = 1;
}
/**
 *  设置navgation
 */
- (void)setNavgation
{
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"配送方式";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
/**
 *  返回的点击事件
 */
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickFirstBtn:(id)sender {
    self.firstImg.hidden = NO;
    self.secondImg.hidden = YES;
    self.thridImg.hidden = YES;
    self.selectNum = 1;
}
- (IBAction)clickSecondBtn:(id)sender {
//    self.firstImg.hidden = YES;
//    self.secondImg.hidden = NO;
//    self.thridImg.hidden = YES;
//    self.selectNum = 2;
}
- (IBAction)clickThridBtn:(id)sender {
//    self.firstImg.hidden = YES;
//    self.secondImg.hidden = YES;
//    self.thridImg.hidden = NO;
//    self.selectNum = 3;
}
- (IBAction)clickSureBtn:(id)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.selectNum == 1) {
        [dict setObject:@"免费送货上门" forKey:@"name"];
        [ANNotificationCenter postNotificationName:@"send" object:nil userInfo:dict];
    }else if (self.selectNum == 2) {
        [dict setObject:@"上门自提" forKey:@"name"];
        [ANNotificationCenter postNotificationName:@"send" object:nil userInfo:dict];
    }else {
        [dict setObject:@"三小时闪送" forKey:@"name"];
        [ANNotificationCenter postNotificationName:@"send" object:nil userInfo:dict];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end

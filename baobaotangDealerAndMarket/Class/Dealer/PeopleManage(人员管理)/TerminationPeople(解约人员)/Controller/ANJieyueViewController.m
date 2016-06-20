//
//  ANJieyueViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/22.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANJieyueViewController.h"

@interface ANJieyueViewController ()

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@end

@implementation ANJieyueViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"解约人员页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"解约人员页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];
    [self setSubView];
    self.sureBtn.layer.cornerRadius = 8;
    self.sureBtn.layer.masksToBounds = YES;
}
#pragma mark ---- 自定义方法
// 设置nav
- (void)setNavgation
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"人员管理";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
- (void)setSubView
{
    self.sureBtn = [ANCommon setBtnRadiusAndBorder:self.sureBtn];
}
// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickSureBtn:(id)sender {
    ANLog(@"确认解约");
}


@end

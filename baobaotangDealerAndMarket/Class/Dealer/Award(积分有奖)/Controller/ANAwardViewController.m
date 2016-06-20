//
//  ANAwardViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/18.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANAwardViewController.h"
#import "ANAwardCell.h"

@interface ANAwardViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ANAwardViewController

#pragma mark ----生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"积分有奖"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"积分有奖"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavgation];
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
    self.navigationItem.title = @"积分有奖";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ----UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANAwardCell *cell = [ANAwardCell awardTableViewCell:tableView];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end

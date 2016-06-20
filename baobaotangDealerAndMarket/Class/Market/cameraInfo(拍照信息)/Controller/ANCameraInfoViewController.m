//
//  ANCameraInfoViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/24.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANCameraInfoViewController.h"
#import "ANCameraInfoTableViewCell.h"

@interface ANCameraInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ANCameraInfoViewController

#pragma mark ---- 声明周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavgation];
}
#pragma mark ---- 自定义方法
// 设置nav
- (void)setNavgation
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"拍照任务";
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
    ANCameraInfoTableViewCell *cell = [ANCameraInfoTableViewCell cameraInfoTableView:tableView];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 322;
}

/**
 *  切换任务
 */
- (IBAction)changePageAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        ANLog(@"全部");
    }else if (sender.selectedSegmentIndex == 1) {
        ANLog(@"宣传");
    }else if (sender.selectedSegmentIndex == 2) {
        ANLog(@"巡店");
    }else if (sender.selectedSegmentIndex == 3) {
        ANLog(@"违规");
    }
}


@end

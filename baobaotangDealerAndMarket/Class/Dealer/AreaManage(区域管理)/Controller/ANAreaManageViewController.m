//
//  ANAreaManageViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/16.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANAreaManageViewController.h"
#import "ANAreaCell.h"
#import "ANAreaListViewController.h"

@interface ANAreaManageViewController ()<UITableViewDataSource, UITableViewDelegate>
/**
 *  是按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
/**
 *  是图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *yesImg;
/**
 *  否按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *noBtn;
/**
 *  否图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *noImg;


@end

@implementation ANAreaManageViewController

#pragma mark --- 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    self.navigationItem.title = @"我的门店";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    // 设置右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_location_white"] style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBtn)];
    
}
// 返回的点击事件
- (void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 核销记录的点击事件
- (void)clickRightBtn
{
    ANLog(@"地点");
}
- (IBAction)clickYesBtn:(id)sender {
    ANLog(@"是");
}
- (IBAction)clickNoBtn:(id)sender {
    ANLog(@"否");
}


#pragma mark ---- UITableViewDelegate
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
    ANAreaCell *cell = [ANAreaCell areaTabelView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ANAreaListViewController *areaList = [[ANAreaListViewController alloc] init];
//    [self.navigationController pushViewController:areaList animated:YES];
}

@end

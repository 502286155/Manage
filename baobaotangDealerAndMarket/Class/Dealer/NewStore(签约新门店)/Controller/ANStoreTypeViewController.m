//
//  ANStoreTypeViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/12/9.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "ANStoreTypeViewController.h"
#import "ANStoreTypeCell.h"
#import "ANHttpTool.h"
#import "ANSingleType.h"

@interface ANStoreTypeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, strong) NSArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ANStoreTypeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"签约新门店门店类型页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"签约新门店门店类型页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];
    ANSingleType *singleType = [ANSingleType sharetype];
    if (singleType.dataArr == nil) {
        [singleType typeBlock:^(NSArray *typeArr) {
            self.dataArr = typeArr;
            [self.tableView reloadData];
        }];
        [singleType requestData];
    }else {
        self.dataArr = singleType.dataArr;
    }
}
#pragma mark ---- 自定义方法
// 设置nav
- (void)setNavgation
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithName:@"nav_backgrand_image"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClickType)];
    // 设置标题
    self.navigationItem.title = @"店铺属性";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}
// 返回的点击事件
- (void)returnClickType
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickCancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mar ---- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANStoreTypeCell *cell = [ANStoreTypeCell storeTypeTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    ANStoreTypeModel *model = self.dataArr[indexPath.row];
    [dict setObject:model.typeName forKey:@"name"];
    [dict setObject:model.typeID forKey:@"typeID"];
    [ANNotificationCenter postNotificationName:@"type" object:nil userInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ----网络请求
- (void)requestData
{
    [ANHttpTool getWithUrl:@"/api/1/store/get_store_type" params:nil successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseTaskLoadData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)parseTaskLoadData:(id)data
{
    ANLog(@"%@",data);
    NSMutableArray *arr = [NSMutableArray array];
    
    NSDictionary *dict = data[@"response"];
    
    NSArray *keys = [dict allKeys];
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 intValue] < [obj2 intValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        if ([obj1 intValue] > [obj2 intValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    for (NSString *str in keys) {
        ANStoreTypeModel *storeModel = [[ANStoreTypeModel alloc] init];
        storeModel.typeID = str;
        storeModel.typeName = dict[str];
        [arr addObject:storeModel];
    }
    self.dataArr = arr;
    [self.tableView reloadData];
}

@end

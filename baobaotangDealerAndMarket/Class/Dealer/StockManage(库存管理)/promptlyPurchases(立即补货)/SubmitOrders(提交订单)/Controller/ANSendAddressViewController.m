//
//  ANSendAddressViewController.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 16/3/21.
//  Copyright © 2016年 高赛. All rights reserved.
//

#import "ANSendAddressViewController.h"
#import "ANSendAddressTableViewCell.h"
#import "ANHttpTool.h"
#import "ANSendAddressModel.h"

@interface ANSendAddressViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ANSendAddressViewController

- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];
    if (self.dataArr.count == 0) {
        [self requestData];
    }
}

- (void)setNavgation
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    
    self.navigationItem.title = @"配送地址";
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
}
- (void)returnBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
    ANSendAddressTableViewCell *cell = [ANSendAddressTableViewCell sendAddressTableView:tableView];
    
    cell.addressModel = self.dataArr[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ANSendAddressModel *addressModel = self.dataArr[indexPath.row];
    
    for (ANSendAddressModel *model in self.dataArr) {
        if (addressModel == model) {
            model.is_default = @"1";
        }else {
            model.is_default = @"0";
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(sendAddressViewController:andDataArr:andAddressModel:)]) {
        [self.delegate sendAddressViewController:self andDataArr:self.dataArr andAddressModel:self.dataArr[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)requestData
{
    NSDictionary *params = [ANCommon dicToSign:[NSDictionary dictionary]];
    ANLog(@"%@",params);
    [ANHttpTool postWithUrl:@"/api/1/dealers/get_dealer_address_list" params:params successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [self parseData:responseObject];
    } errorBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
    
}
- (void)parseData:(id)data
{
    self.dataArr = [ANSendAddressModel mj_objectArrayWithKeyValuesArray:data[@"response"]];
    [self.tableView reloadData];
}

@end

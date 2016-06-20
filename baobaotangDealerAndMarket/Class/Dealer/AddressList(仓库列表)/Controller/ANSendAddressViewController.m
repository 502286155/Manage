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
#import "ANEditAddressViewController.h"
#import "ANNavigationController.h"

@interface ANSendAddressViewController ()<UITableViewDataSource, UITableViewDelegate, ANSendAddressTableViewCellDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL isFrist;

@property (nonatomic, copy) NSString *addressID;

@end

@implementation ANSendAddressViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isFrist) {
        [self requestData];
    }else {
        self.isFrist = YES;
    }
}

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
    cell.delegate = self;
    cell.addressModel = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isMineVC) {
        
    }else {
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
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ANSendAddressModel *model = self.dataArr[indexPath.row];
        self.addressID = model.ID;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要删除该仓库,删除后不可恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
- (void)sendAddressCell:(ANSendAddressTableViewCell *)cell clickInfoBtn:(UIButton *)btn
{
    ANEditAddressViewController *editAddressVC = [[ANEditAddressViewController alloc] init];
    editAddressVC.model = cell.addressModel;
    [self presentViewController:[[ANNavigationController alloc] initWithRootViewController:editAddressVC] animated:YES completion:nil];
//    [self presentViewController:editAddressVC animated:YES completion:nil];
}

- (IBAction)clickAddAddressBtn:(id)sender {
    ANEditAddressViewController *editAddressVC = [[ANEditAddressViewController alloc] init];
    editAddressVC.isAdd = YES;
//    [self presentViewController:editAddressVC animated:YES completion:nil];
    [self presentViewController:[[ANNavigationController alloc] initWithRootViewController:editAddressVC] animated:YES completion:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteAddress:self.addressID];
    }
}


- (void)requestData
{
    NSDictionary *params = [ANCommon dicToSign:[NSDictionary dictionary]];
    ANLog(@"%@",params);
    [ANHttpTool postWithUrl:@"/api/1/dealers/get_dealer_address_list" params:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [self parseData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
        if ([responseObject[@"message"] isEqualToString:@"暂无仓库地址数据"]) {
            self.dataArr = [NSMutableArray array];
            [self.tableView reloadData];
        }
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
    
}
- (void)parseData:(id)data
{
    self.dataArr = [ANSendAddressModel mj_objectArrayWithKeyValuesArray:data[@"response"]];
    [self.tableView reloadData];
}

- (void)deleteAddress:(NSString *)addressID
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:addressID forKey:@"address_id"];
    params = (NSMutableDictionary *)[ANCommon dicToSign:params];
    [ANHttpTool postWithUrl:@"/api/1/dealers/delete_dealer_address" params:params successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
//        [[ANCommon alloc] setAlertView:responseObject[@"message"]];
        [self requestData];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"%@",responseObject);
        [ANCommon setAlertViewWithMessage:responseObject[@"message"]];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"%@",error);
    }];
}

@end

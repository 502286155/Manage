//
//  ANActivityMessageViewController.m
//  baobaotang
//
//  Created by 高赛 on 15/12/9.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANActivityMessageViewController.h"
#import "ANActivityMessageCell.h"
#import "ANHttpTool.h"
#import "ANActivityModel.h"
#import "MJRefresh.h"
#import "ANDetailViewController.h"

@interface ANActivityMessageViewController ()<UITableViewDataSource, UITableViewDelegate>

/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  数据数组
 */
@property (nonatomic, strong) NSMutableArray *dataArr;
/**
 *  上传的页码
 */
@property (nonatomic, strong) NSNumber *pageNo;
/**
 *  请求下来的页码
 */
@property (nonatomic, strong) NSNumber *pages;
/**
 *  没有信息
 */
@property (weak, nonatomic) IBOutlet UIView *noInfoView;

@end

@implementation ANActivityMessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"消息活动/公告页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"消息活动/公告页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];
    self.pageNo = [NSNumber numberWithLong:1];
    [self setTableViewRefresh];
}
#pragma mark ----自定义方法
/**
 *  设置navgation
 */
- (void)setNavgation
{
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"活动列表";
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
//    [self requestData];
}
/**
 *  设置加载刷新
 */
- (void)setTableViewRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    [self.tableView.mj_header beginRefreshing];
}
- (void)setRefreshNum
{
    if (self.pageNo >= self.pages) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }else {
        self.pageNo = [NSNumber numberWithLong:[self.pageNo longValue] + 1];
        [self footRequestData];
    }
}
#pragma mark ----UITableViewDelegate
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
    ANActivityMessageCell *cell = [ANActivityMessageCell activityMessageTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.32472826 * HIGH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ANActivityModel *model = self.dataArr[indexPath.row];
    ANDetailViewController *detailVC = [[ANDetailViewController alloc] init];
    detailVC.aboutUsUrl = model.url;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark ---- 网络请求
- (void)requestData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [parmDict setObject:self.res_name forKey:@"res_name"];
    [parmDict setObject:@"1" forKey:@"page_no"];
    [ANHttpTool postWithUrl:@"/api/1/message_center/get_message_list" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseTaskLoadData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
        [self.tableView.mj_header endRefreshing];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)parseTaskLoadData:(NSDictionary *)json
{
    self.dataArr = [NSMutableArray array];
    NSArray *tempArr = json[@"response"][@"data"];
    NSDictionary *pageDic = json[@"response"][@"page"];
    self.pages = pageDic[@"pages"];
    self.pageNo = self.pages;
    self.pageNo = [NSNumber numberWithLong:1];
    for (NSDictionary *dict in tempArr) {
        NSArray *arr = dict[@"record_list"];
        for (NSDictionary *dic in arr) {
            [self.dataArr addObject:[ANActivityModel mj_objectWithKeyValues:dic]];
        }
    }
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setRefreshNum)];
    self.noInfoView.hidden = YES;
}
//上拉加载请求数据
- (void)footRequestData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [parmDict setObject:self.res_name forKey:@"res_name"];
    [parmDict setObject:@"1" forKey:@"page_no"];
    [ANHttpTool postWithUrl:@"/api/1/message_center/get_message_list" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self footParseTaskLoadData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@",error);
    }];
}
- (void)footParseTaskLoadData:(NSDictionary *)json
{
    NSArray *tempArr = json[@"response"][@"data"];
    NSDictionary *pageDic = json[@"response"][@"page"];
    self.pages = pageDic[@"pages"];
    for (NSDictionary *dict in tempArr) {
        NSArray *arr = dict[@"record_list"];
        for (NSDictionary *dic in arr) {
            [self.dataArr addObject:[ANActivityModel mj_objectWithKeyValues:dic]];
        }
    }
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
}


@end

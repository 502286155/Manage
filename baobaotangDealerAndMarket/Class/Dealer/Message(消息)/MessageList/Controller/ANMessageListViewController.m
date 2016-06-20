//
//  ANMessageListViewController.m
//  baobaotang
//
//  Created by 高赛 on 15/11/22.
//  Copyright © 2015年 Eric. All rights reserved.
//

#import "ANMessageListViewController.h"
#import "ANMessageListCell.h"
#import "ANHttpTool.h"
#import "ANMessageList.h"
#import "MJRefresh.h"
#import "ANDetailViewController.h"
#import "ANNewMessageCell.h"

@interface ANMessageListViewController ()<UITableViewDelegate, UITableViewDataSource>

/**
 *  标题数组
 */
@property (nonatomic, strong) NSMutableArray *titleDateArr;
/**
 *  数据数组
 */
@property (nonatomic, strong) NSMutableArray *dataArr;
/**
 *  请求下来的总页码
 */
@property (nonatomic, strong) NSNumber *pages;
/**
 *  要上传的页码
 */
@property (nonatomic, strong) NSNumber *pageNo;
/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  没有信息视图
 */
@property (weak, nonatomic) IBOutlet UIView *noInfoView;

@end

@implementation ANMessageListViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"消息列表页"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"消息列表页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavgation];
    
    self.pageNo = [NSNumber numberWithLong:1];
//    [self requestData];
    
    [self setTableViewRefresh];
}
/**
 *  设置navgation
 */
- (void)setNavgation
{
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_button_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(returnClick)];
    // 设置标题
    self.navigationItem.title = @"消息中心";
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.model.res_name isEqualToString:@"notice"]) {
        return 40;
    }else {
        ANMessageList *model = self.dataArr[indexPath.section][indexPath.row];
        ANLog(@"%f",[model returnCellHeight]);
        return [model returnCellHeight];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count != 0) {
        NSArray *arr = self.dataArr[section];
        return arr.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.model.res_name isEqualToString:@"notice"]) {
        ANMessageListCell *cell = [ANMessageListCell messageListTableView:tableView];
        NSArray *arr = self.dataArr[indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
        cell.model = arr[indexPath.row];
        if (arr.count == indexPath.row + 1) {
            cell.isHiddenLine = YES;
        }
        return cell;
    }else {
        ANNewMessageCell *cell = [ANNewMessageCell newMessageTableView:tableView];
        NSArray *arr = self.dataArr[indexPath.section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
        cell.model = arr[indexPath.row];
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, WIDTH, 15)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    NSString *timeStr = self.titleDateArr[section];
    ANLog(@"%@",timeStr);
    NSArray *strArr = [timeStr componentsSeparatedByString:@" "];
    titleLabel.text = strArr[0];
    
    titleLabel.textColor = ANColor(54, 31, 78);
    [headView addSubview:titleLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.8392 green:0.8392 blue:0.8392 alpha:1.0];
//    [headView addSubview:line];
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    view.backgroundColor = [UIColor colorWithRed:0.9647 green:0.9647 blue:0.9647 alpha:1.0];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.model.res_name isEqualToString:@"notice"]) {
        ANMessageList *model = self.dataArr[indexPath.section][indexPath.row];
        ANDetailViewController *detailVC = [[ANDetailViewController alloc] init];
        detailVC.aboutUsUrl = model.url;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark ----网络请求
//正常请求数据
- (void)requestData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    if (self.res_name) {
        [parmDict setObject:self.res_name forKey:@"res_name"];
    }else {
        [parmDict setObject:self.model.res_name forKey:@"res_name"];
    }
    [parmDict setObject:@"1" forKey:@"page_no"];
    [ANHttpTool postWithUrl:@"/api/1/message_center/get_message_list" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self parseTaskLoadData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
        if ([responseObject[@"message"] isEqualToString:@"暂无消息记录"]) {
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@,",error);
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)parseTaskLoadData:(NSDictionary *)json
{
    self.titleDateArr = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    NSArray *tempArr = json[@"response"][@"data"];
    NSDictionary *pageDic = json[@"response"][@"page"];
    self.pages = pageDic[@"pages"];
    self.pageNo = [NSNumber numberWithLong:1];
    for (NSDictionary *dict in tempArr) {
        [self.titleDateArr addObject:dict[@"date"]];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"record_list"]) {
            [arr addObject:[ANMessageList mj_objectWithKeyValues:dic]];
        }
        [self.dataArr addObject:arr];
    }
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    if ([self.pages isEqualToNumber:@1]) {
        
    }else {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setRefreshNum)];
    }
    self.noInfoView.hidden = YES;
}
// 上拉加载
- (void)footRequestData
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [parmDict setObject:self.model.res_name forKey:@"res_name"];
    [parmDict setObject:[NSString stringWithFormat:@"%@",self.pageNo] forKey:@"page_no"];
    [ANHttpTool postWithUrl:@"/api/1/message_center/get_message_list" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [self footParseTaskLoadData:responseObject];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"error:%@",responseObject);
        if ([responseObject[@"message"] isEqualToString:@"暂无消息记录"]) {
        }
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@,",error);
    }];
}
- (void)footParseTaskLoadData:(NSDictionary *)json
{
    NSArray *tempArr = json[@"response"][@"data"];
    NSDictionary *pageDic = json[@"response"][@"page"];
    self.pages = pageDic[@"pages"];
    for (NSDictionary *dict in tempArr) {
        if ([dict[@"date"] isEqualToString:self.titleDateArr.lastObject]) {
            NSMutableArray *arr = self.dataArr.lastObject;
            for (NSDictionary *dic in dict[@"record_list"]) {
                [arr addObject:[ANMessageList mj_objectWithKeyValues:dic]];
            }
        }else {
            [self.titleDateArr addObject:dict[@"date"]];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dic in dict[@"record_list"]) {
                [arr addObject:[ANMessageList mj_objectWithKeyValues:dic]];
            }
            [self.dataArr addObject:arr];
        }
    }
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
}

@end

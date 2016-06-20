//
//  UpdateVersion.m
//  CreditBank
//
//  Created by 王德康 on 15/5/9.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import "UpdateVersion.h"
#import "PrefixHeader.pch"
#import "UpdateM.h"
#import "ANHttpTool.h"

@interface UpdateVersion ()
@property(nonatomic, strong) UpdateM *updateM;
@end

@implementation UpdateVersion
#pragma mark -- Update method

- (void)checkUpdateVersionWith:(NSString *)res_name {
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    parmDict = (NSMutableDictionary *)[ANCommon dicToSign:parmDict];
    [parmDict setObject:res_name forKey:@"res_name"];
    
    ANLog(@"%@",parmDict);
    
    [ANHttpTool postWithUrl:@"/api/1/version/get_version" params:parmDict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"版本更新 %@",responseObject);
        // 字典转模型
        self.updateM = [UpdateM mj_objectWithKeyValues:responseObject[@"response"]];
        
        // 调用显示对话框方法
        [self updateVersion:self.updateM];
    } errorBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        ANLog(@"版本更新error:%@", responseObject);
    } failBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        ANLog(@"fail:%@", error);
    }];
}

/**
 *  更新提示新版本
 *
 *  @param update update description
 */
- (void)updateVersion:(UpdateM *)update {
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSComparisonResult result = [currentVersion compare:update.version];
    
    if (-1 == result) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"软件更新" message:update.desc delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:nil];
        alertView.delegate     = self;
        [alertView show];
    }
}

#pragma mark -- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ANLog(@"%ld", buttonIndex);
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateM.link]];
    }
}

- (void)dealloc {
    ANLog(@"UpdateViewController-dealloc");
}

@end

//
//  AppDelegate.m
//  baobaotangDealerAndMarket
//
//  Created by 高赛 on 15/11/16.
//  Copyright © 2015年 高赛. All rights reserved.
//

#import "AppDelegate.h"
#import "ANNavigationController.h"
#import "ANHomePageViewController.h"
#import "ANLoginViewController.h"
#import "ANMarketHomepageViewController.h"
#import "JPUSHService.h"
#import "Push.h"
#import "ANCustomerSuccessViewController.h"
#import "MobClick.h"

@interface AppDelegate ()

// 推送实例
@property(nonatomic, strong) Push *pushApns;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //友盟统计设置
    [MobClick startWithAppkey:@"56c58c6de0f55a148a00118b" reportPolicy:BATCH channelId:@""];
    [MobClick setLogEnabled:YES];
    
    // 启动方式
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {   //点击通知启动
        ANLog(@"点击通知启动");
        // 延迟0.5秒，保证后面控制器加载完毕
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            if (userInfo) {
                [self.pushApns apnsNotificationMessage:userInfo callStatus:YES];
            }
        });
    }else {                     //正常启动
        ANLog(@"正常启动");
    }
    
    
    [NSThread sleepForTimeInterval:2.0];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = ANColor(52, 32, 73);
    // 市场
//    ANMarketHomepageViewController *homeVC = [[ANMarketHomepageViewController alloc] init];
    // 经销商
//    ANHomePageViewController *homeVC = [[ANHomePageViewController alloc] init];
    // 登陆
    
    if (5 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"] integerValue]) { // 经销商首页
        ANHomePageViewController *homeVC = [[ANHomePageViewController alloc] init];
//        ANCustomerSuccessViewController *homeVC = [[ANCustomerSuccessViewController alloc] init];
        self.window.rootViewController = [[ANNavigationController alloc] initWithRootViewController:homeVC];
    }else if (10 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"reloID"] integerValue]) { // 市场人员首页
        ANMarketHomepageViewController *marketVC = [[ANMarketHomepageViewController alloc] init];
        self.window.rootViewController = [[ANNavigationController alloc] initWithRootViewController:marketVC];
    } else {
        
        ANLoginViewController *longinVC = [[ANLoginViewController alloc] init];
        self.window.rootViewController = [[ANNavigationController alloc] initWithRootViewController:longinVC];
    }
    
    [self.window makeKeyAndVisible];
    
    Push *pushApns = [[Push alloc] init];
    self.pushApns = pushApns;
    
    // Required
    [Push registationAPNSNotification:launchOptions];
    
    
    // 延迟0.5秒，保证后面控制器加载完毕
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            [self.pushApns apnsNotificationMessage:userInfo callStatus:YES];
            //
            //            NSString *mes =  [NSString stringWithFormat:@"%@", userInfo];
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息推送" message:mes delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil, nil];
            //            [alert show];
        }
    });
    
    
    // 消除通知图标
    [application setApplicationIconBadgeNumber:0];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [JPUSHService handleRemoteNotification:userInfo];
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    

    NSLog(@"this is iOS7 Remote Notification");
    [self.pushApns apnsNotificationMessage:userInfo callStatus:NO];
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if ([self.pushApns getCurrentVC]) {
        ANNavigationController *vc = (ANNavigationController *)[self.pushApns getCurrentVC];
        ANLog(@"%@",vc.childViewControllers);
        if ([vc.childViewControllers.lastObject isKindOfClass:[ANHomePageViewController class]]) {
            [(ANHomePageViewController *)vc.childViewControllers.lastObject requestHomeData];
        }        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

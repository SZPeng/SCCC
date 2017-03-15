//
//  AppDelegate.m
//  SCCBBS
//
//  Created by co188 on 16/10/25.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MyTableBarController.h"
#import <UMMobClick/MobClick.h>
#import "BaiduMobStat.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "WeiboSDK+Statistics.h"
#import "SubViewController.h"
#import "WXApi.h"
#import "SCCHeader.h"
#import "tools.h"
#import "EnterViewController.h"
#import <AlipaySDK/AlipaySDK.h>

#define __kFirstVersion @"kFirestVersion"
@interface AppDelegate ()<JPUSHRegisterDelegate,WeiboSDKDelegate,WXApiDelegate>

@end

@implementation AppDelegate

// 启动百度移动统计
- (void)startBaiduMobileStat{
    [WXApi registerApp:WEIXINAPPKEY];
    
//    [[TencentOAuth alloc]initWithAppId:@"aaaaa" andDelegate:self];
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.enableDebugOn = YES;
    [statTracker startWithAppId:@"2bf1983158"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [NSThread sleepForTimeInterval:2]; // 设置启动页面停留时间
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WEIBOKEY];
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    [self startBaiduMobileStat];
    UMConfigInstance.appKey = @"5811915e4ad15656950022d2";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    NSString *key = (NSString *)kCFBundleVersionKey;
    
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] valueForKey:__kFirstVersion];
    
    if (![lastVersion isEqualToString:version]) {
        SubViewController *vc = [[SubViewController alloc] init];
        [vc setCallback:^{
            [self startAppM:launchOptions];
            [[NSUserDefaults standardUserDefaults] setValue:version forKey:__kFirstVersion];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
        self.window.rootViewController = vc;
    }
    else
    {
        [self startAppM:launchOptions];
        NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSLog(@"%@",userInfo);
        NSString *string = [NSString stringWithFormat:@"%@",userInfo[@"name"]];
        NSDictionary *dic = @{@"name":string};
        NSLog(@"%@",userInfo[@"name"]);
        if(userInfo[@"name"]){
            if([string isEqualToString:@"0"]){
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"name"];
            }else{
                [[NSUserDefaults standardUserDefaults]setValue:userInfo[@"name"] forKey:@"name"];
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"ThisIsANoticafication" object:dic];
            }
        }

    }

    

    // Override point for customization after application launch.
    return YES;
}

-(void)startAppM:(NSDictionary *)launchOptions
{
    self.window.rootViewController = [MyTableBarController new];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger)
//                                                                                                                                                 )completionHandler {
//    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]
//        ]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler(UNNotificationPresentationOptionAlert);
//    // 需要执 这个 法,选择 是否提醒 户,有Badge、Sound、Alert三种类型可以选择设置
//}

//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)
//                                                                                                                                                            ())completionHandler {
//    // Required
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler(); // 系统要求执 这个 法
//}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
}

#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"%@",userInfo);
//    UNNotificationRequest *request = notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//    
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
//    
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//        
//        
//    }
//    else {
//        // 判断为本地通知
//        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
//    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"%@",userInfo);
    NSString *string = [NSString stringWithFormat:@"%@",userInfo[@"name"]];
    NSDictionary *dic = @{@"name":string};
    if([string isEqualToString:@"0"]){
        
    }else{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ThisIsANoticafication" object:dic];
    }
    
//    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//    
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
//    
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    else {
//        // 判断为本地通知
//        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
//    }
    completionHandler();  // 系统要求执行这个方法
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
}

// iOS9 以上用这个方法接收
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSDictionary * dic = options;
    NSLog(@"%@", dic);
    EnterViewController *vc = [EnterViewController new];
    if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.sina.weibo"]) {
        NSLog(@"新浪微博~");
        
        return [WeiboSDK handleOpenURL:url delegate:vc];
    }else if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"]){
        
        return [WXApi handleOpenURL:url delegate:vc];
    }else if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.mqq"]){
        
        //        [WTThirdPartyLoginManager didReceiveTencentUrl:url];
        return [TencentOAuth HandleOpenURL:url];
    }else if([url.host isEqualToString:@"safepay"]){
        // 支付跳转支付宝钱包进行支付，处理支付结果
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ziFuNoti" object:nil userInfo:resultDic];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}
// iOS9 以下用这个方法接收
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"%@",url);
    
     EnterViewController *vc = [EnterViewController new];
    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
        
        return [WeiboSDK handleOpenURL:url delegate:vc];
        
    }else if ([sourceApplication isEqualToString:@"com.tencent.xin"]){
        
        return [WXApi handleOpenURL:url delegate:vc];
        
    }else if ([sourceApplication isEqualToString:@"com.tencent.mqq"]){
        
        //        [WTShareManager didReceiveTencentUrl:url];
        return [TencentOAuth HandleOpenURL:url];
    }else if ([url.host isEqualToString:@"safepay"]){
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ziFuNoti" object:nil userInfo:resultDic];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    
    
    return YES;
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:WBAuthorizeResponse.class])  //用户登录的回调
    {
        
        NSString *title = NSLocalizedString(@"认证结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        
        NSLog(@"token %@", [(WBAuthorizeResponse *) response accessToken]);
        NSLog(@"uid %@", [(WBAuthorizeResponse *) response userID]);
        NSDictionary *dic = @{@"token":[(WBAuthorizeResponse *) response accessToken],@"uid":[(WBAuthorizeResponse *) response userID]};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weiBoNoti" object:nil userInfo:dic];
//        [alert show];
        

    }
}
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [WeiboSDK handleOpenURL:url delegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return [WeiboSDK handleOpenURL:url delegate:self ];
//}


@end

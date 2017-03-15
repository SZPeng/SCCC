//
//  SCCHeader.h
//  SCCBBS
//
//  Created by co188 on 16/10/27.
//  Copyright © 2016年 co188. All rights reserved.
//

#ifndef SCCHeader_h
#define SCCHeader_h

#pragma mark - 设备类型
#define kiPhone4     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kiPhone5     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kiPhone6     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define  GRAYTEXT   [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f]
#pragma mark - 设备信息
#define kIOS_VERSION    [[[UIDevice currentDevice] systemVersion] floatValue]
#define kDEVICE_MODEL   [[UIDevice currentDevice] model]
#define kIS_IPAD        ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define kisRetina       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kAPP_NAME            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define kAPP_VERSION         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kAPP_SUB_VERSION     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define kUDeviceIdentifier   [[UIDevice currentDevice] uniqueDeviceIdentifier]


#pragma mark - 常用宏定义
#define kWS(weakSelf)          __weak __typeof(&*self)weakSelf = self;
#define kSCREEN_WIDTH          ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT         ([UIScreen mainScreen].bounds.size.height)
#define kUSER_DEFAULT          [NSUserDefaults standardUserDefaults]
#define kNOTIFICATION_DEFAULT  [NSNotificationCenter defaultCenter]
#define kIMAGENAMED(_pointer)  [UIImage imageNamed:[UIUtil imageName:_pointer]]
#define kLOADIMAGE(file,ext)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

#define kScreenWidthScaleSize           (MIN(SCREEN_WIDTH,SCREEN_HEIGHT)/320.0)
#define kScreenWidthScaleSizeByIphone6  (MIN(SCREEN_WIDTH,SCREEN_HEIGHT)/375.0)

#define kDegreesToRadian(x)         (M_PI * (x) / 180.0)
#define kRadianToDegrees(radian)    (radian*180.0)/(M_PI)


#pragma mark - ios版本判断

#define kIOS5_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define kIOS6_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define kIOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define kIOS8_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )


#pragma mark - 是否为空或是[NSNull null]

#define kNotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define kIsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

#pragma mark - 图片资源获取
#define kIMGFROMBUNDLE( X )     [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:X ofType:@""]]
#define kIMGNAMED( X )         [UIImage imageNamed:X]

#pragma mark - 颜色
#define kCOLOR_RGB(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define kCOLOR_RGBA(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define  FA   [UIColor colorWithRed:1.00f green:0.15f blue:0.26f alpha:1.00f]
#define  FB   [UIColor colorWithRed:0.16f green:0.69f blue:0.79f alpha:1.00f]
#define FC    [UIColor colorWithRed:0.96f green:0.45f blue:0.00f alpha:1.00f];


#define FD1   [UIColor colorWithRed:0.81f green:0.81f blue:0.81f alpha:1.00f]
#define FD2   [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f]


#define FEa   [UIColor colorWithRed:1.00f green:0.15f blue:0.26f alpha:1.00f]
#define FEb   [UIColor colorWithRed:0.16f green:0.73f blue:0.83f alpha:1.00f]
#define FEc   [UIColor colorWithRed:1.00f green:0.47f blue:0.00f alpha:1.00f]
#define FE1   [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f]
#define FE2   [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.00f]
#define FE3   [UIColor colorWithRed:0.27f green:0.27f blue:0.27f alpha:1.00f]
#define FE4   [UIColor colorWithRed:0.65f green:0.65f blue:0.65f alpha:1.00f]
#define FE5   [UIColor colorWithRed:0.65f green:0.65f blue:0.65f alpha:1.00f]
#define FE6   [UIColor colorWithRed:0.81f green:0.81f blue:0.81f alpha:1.00f]

#define FE7   [UIColor colorWithRed:0.19f green:1.00f blue:0.16f alpha:1.00f]


#define FFa   [UIColor colorWithRed:1.00f green:0.15f blue:0.26f alpha:1.00f]
#define FFb   [UIColor colorWithRed:0.16f green:0.73f blue:0.83f alpha:1.00f]
#define FFc   [UIColor colorWithRed:1.00f green:0.47f blue:0.00f alpha:1.00f]
#define FF1   [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f]
#define FF2   [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:1.00f]

#define FG1   [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f]
#define FG2   [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f]
#define FG3   [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:1.00f]
#define FG4   [UIColor colorWithRed:0.11f green:0.11f blue:0.11f alpha:1.00f]
#define   WIN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define   WIN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define BACKCOLO  [UIColor colorWithRed:0.96f green:0.97f blue:0.97f alpha:1.00f]
#define BACKTAB [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f]
#define LINECOLO [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f]
#define CELLCOLO [UIColor colorWithRed:0.27f green:0.27f blue:0.27f alpha:1.00f]

#define TTG    [UIColor colorWithRed:0.00f green:0.70f blue:0.16f alpha:1.00f]
#define TTG1   [UIColor colorWithRed:0.39f green:0.74f blue:0.00f alpha:1.00f] //导航色
#define TTG2   [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f] //线色
#define TTG3   [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:1.00f] //字色
#define TTG4   [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f]  //text字色
#define TTG5    [UIColor colorWithRed:0.52f green:0.52f blue:0.52f alpha:1.00f] //忘记密码字色
#define TTG6   [UIColor colorWithRed:0.97f green:0.47f blue:0.42f alpha:1.00f]  //价格字体颜色
#define TTG7    [UIColor colorWithRed:0.55f green:0.56f blue:0.54f alpha:1.00f]  //过去价格字体颜色
#define  BACKCL  [UIColor colorWithRed:0.96f green:0.97f blue:0.97f alpha:1.00f] //背景颜色

#define MTEXTCOLO   [UIColor colorWithRed:0.69f green:0.69f blue:0.69f alpha:1.00f]  //我的页面字体颜色
#define MLINE     [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f]  //我的cell线
#define CELLBAC  [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f] //cell的背景颜色
#define UUT  [UIColor colorWithRed:0.22f green:0.14f blue:0.09f alpha:1.00f] //新改的表头颜色
#define NOGOODSCOLOR  [UIColor colorWithRed:0.74f green:0.75f blue:0.75f alpha:1.00f] //没有物品的字体颜色

//土木登录线框颜色
// 土木在线域名
#define API_HOST      @"https://app.co188.com/sso/apigateway"
#define PHPHOST       @"https://app.co188.com/bbs/forum.php?action="
#define FIRFTPAGE     @"https://app.co188.com/bbs/index.php"
#define COMMUNITY     @"http://app.co188.com/bbs/forum.php?action=group"
#define MYTIZHI       @"https://app.co188.com/bbs/my.php?"
#define MYCALLBACK    @"https://app.co188.com/bbs/my.php?action=reply"
#define FAVOURITE     @"https://app.co188.com/bbs/my.php?action=favorite"
#define DELETEFAV     @"https://app.co188.com/bbs/my.php?action=deletefavorite"
#define BANKUAI       @"https://app.co188.com/bbs/my.php?action=forum"
#define VERSION       @"1.0"
#define BANKDT        @"http://app.co188.com/bbs/list.php?"  //版块详情

#define WEIBOKEY      @"4281350467"
#define WEIXINAPPKEY   @"wxb8da59523a7f0abd"
#define WEIXINSECRITE  @"ccb6b92feabe221c8a77c73b164d3de1"
#define TENGCENTAPPID   @"101027731"
#define ZHIFUBAOAPPID   @"2017020905585284"

#define TMLINECOLO    [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f]
#define TMHEADCOLO    [UIColor colorWithRed:0.00f green:0.55f blue:0.93f alpha:1.00f]

#define  A333         [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f]
#define  A666         [UIColor colorWithRed:0.39f green:0.39f blue:0.39f alpha:1.00f]
#define  A999         [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f]
#define  Ad6d6d6      [UIColor colorWithRed:0.82f green:0.82f blue:0.82f alpha:1.00f]
#define  Ae1e2e6      [UIColor colorWithRed:0.87f green:0.87f blue:0.89f alpha:1.00f]
#define  A58baff      [UIColor colorWithRed:0.35f green:0.73f blue:1.00f alpha:1.00f]
#define  Ac6c6c6      [UIColor colorWithRed:0.78f green:0.78f blue:0.78f alpha:1.00f]
#define  Af8f8f8      [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f]
#define  A008cee      [UIColor colorWithRed:0.00f green:0.55f blue:0.93f alpha:1.00f]
#define  Af4f5f9      [UIColor colorWithRed:0.96f green:0.96f blue:0.98f alpha:1.00f]
#define  Aff0000      [UIColor colorWithRed:1.00f green:0.00f blue:0.00f alpha:1.00f]
#define  A77c6fe      [UIColor colorWithRed:0.47f green:0.78f blue:0.99f alpha:1.00f]
#define  A999999      [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f]

#define A79767b       [UIColor colorWithRed:0.47f green:0.46f blue:0.48f alpha:1.00f]

#define Aefefef       [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f]
#define Acbcbcb       [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f]
#define A888          [UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.00f]
#define FFA800        [UIColor colorWithRed:1.00f green:0.66f blue:0.00f alpha:1.00f]
#define BEBEBE        [UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.00f]
#define A666666       [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f]
#define FFA800        [UIColor colorWithRed:1.00f green:0.66f blue:0.00f alpha:1.00f]
#define LINECOLOR       [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f]
#define F5F5F5        [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f]

#pragma mark - 定义字号
#define kFONT_TITLE(X)     [UIFont systemFontSize:X]
#define kFONT_CONTENT(X)   [UIFont systemFontSize:X]

#define UMAPPKEY  @"5680e05d67e58e3116001428"

#pragma mark - 其他

#define  userHeadImage  @"http://120.27.130.65/dbn/download.do?id="

#define XIANSH  @"http://120.27.130.65/dbn/"
#define CHESHI  @"http://58.216.230.206/dbn/"

#define BINDVIEWWIDTH        (ScreenBounds.size.width * 290.0 / 320.0)


#define SCREEN_WIDTH_SCALE SCREEN_WIDTH / 375.0
#define SCREEN_HEIGHT_SCALE SCREEN_HEIGHT / 667.0

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


#define BACKGROUNDCOLOR [UIColor colorWithRed:239.0/255.0 green:34.0/255.0 blue:109.0/255.0 alpha:1.0]
#define TextColor [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]
//线条描边
#define GrayLine [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0]
#define CELLLINECOLO [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f]    //cell的线条颜色
#define DarkGrayLine [UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1.0]
#define ThemeColor [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]

#define NotNilAndNull(_ref) (((_ref) != nil) && (![(_ref)isEqual:[NSNull null]]))
#define IsNilOrNull(_ref) (((_re

#endif /* SCCHeader_h */

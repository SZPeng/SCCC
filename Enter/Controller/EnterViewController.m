//
//  EnterViewController.m
//  SCCBBS
//
//  Created by co188 on 16/10/27.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "EnterViewController.h"
#import "SCCHeader.h"
#import "ZhuCeViewController.h"
#import "BackMViewController.h"
#import "tools.h"
#import "SCCAFnetTool.h"
#import <MBProgressHUD.h>
#import "WeiboSDK.h"
#import "WeiboSDK+Statistics.h"
#import "WXApi.h"
#import "SCCAFnetTool.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "SCCWebViewController.h"

@interface EnterViewController ()<UITextFieldDelegate,UIAlertViewDelegate,TencentSessionDelegate, TencentLoginDelegate,WBHttpRequestDelegate,WeiboSDKDelegate,WXApiDelegate>
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIImageView *_PhoneNum;
    UITextField *_PhoneT;
    UILabel *_Line;
    UIImageView *_Mima;
    UITextField *_MimaT;
    UIButton *_EnterBtn;
    UIButton *_qqBtn;
    UILabel *_qqLab;
    UIButton *_weiBoBtn;
    UILabel *_weiBoLab;
    UIButton *_weiXinBtn;
    UILabel *_weiXinLab;
    NSInteger _num;
    
    NSInteger _hasQQ;
    NSInteger _hasWC;
    NSInteger _hasWB;
    
    NSString *_isShenHe;
}
@property (nonatomic, strong)NSString * access_token;

@property (nonatomic, strong)TencentOAuth * tencentOAuth;
@property (nonatomic, strong)NSMutableArray * tencentPermissions;
@end

@implementation EnterViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _num = 0;
        _hasQQ = 0;
        _hasWB = 0;
        _hasWC = 0;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    
//    self.navigationController.navigationBarHidden = NO;
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.userInteractionEnabled = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backClick) name:@"weiixnEnter" object:nil];
    [self prepareData];
    //weiBoNoti
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(receiveNotificiation:) name:@"weiBoNoti" object:nil];
}

-(void)prepareData
{
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    [afTool getMessage:@"https://app.co188.com/bbs/t.php" useDictonary:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        _isShenHe = [NSString stringWithFormat:@"%@",responseObject[@"result"]];
        [self createUI];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}

-(void)createUI
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toucheBegan)];
    [self.view addGestureRecognizer:tap];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"登录";
    _label.textAlignment = NSTextAlignmentCenter;
    
    _label.font = [UIFont systemFontOfSize:18];//[UIFont fontWithName:@"STHeitiTC-Light" size:18];
    _label.textColor = [UIColor whiteColor];
    _label.center = CGPointMake(headView.center.x, _label.center.y);
    [headView addSubview:_label];
    
    _leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 0, 40, 44)];
    _leftBtn.imageEdgeInsets=UIEdgeInsetsMake(10, 6, 9, 15);
    [_leftBtn setImage:[UIImage imageNamed:@"back"]  forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.center = CGPointMake(_leftBtn.center.x, _label.center.y);
    [headView addSubview:_leftBtn];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 63.5, WIN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    [headView addSubview:line];
    
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(44, 131, WIN_WIDTH -88, 50)];
    firstView.layer.borderWidth = 0.5;
    firstView.layer.borderColor = TMLINECOLO.CGColor;
    firstView.layer.cornerRadius = 3;
    [self.view addSubview:firstView];
    
    _PhoneNum = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
    //    _PhoneNum.backgroundColor = [UIColor redColor];
    _PhoneNum.image = [UIImage imageNamed:@"user"];
    [firstView addSubview:_PhoneNum];
    
    _PhoneT = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, firstView.frame.size.width - 60 , 30)];
    _PhoneT.placeholder = @"请输入手机号码";
    _PhoneT.textAlignment = NSTextAlignmentLeft;
    _PhoneT.textColor = TTG3;
    _PhoneT.tag = 10;
    //    _PhoneT.keyboardType = UIKeyboardTypeNumberPad;
    _PhoneT.delegate = self;
    _PhoneT.returnKeyType =  UIReturnKeyDone;
    _PhoneT.font = [UIFont fontWithName:@"STHeitiTC-Light" size:15];
    [firstView addSubview:_PhoneT];
    
    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(firstView.frame) + 18, WIN_WIDTH -88, 50)];
    secondView.layer.borderWidth = 0.5;
    secondView.layer.borderColor = TMLINECOLO.CGColor;
    secondView.layer.cornerRadius = 3;
    [self.view addSubview:secondView];
    
    _Mima = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
    //    _Mima.backgroundColor = [UIColor redColor];
    _Mima.image = [UIImage imageNamed:@"PASSWORD"];
    [secondView addSubview:_Mima];
    
    _MimaT = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, firstView.frame.size.width - 60 , 30)];
    _MimaT.placeholder = @"请输入密码";
    _MimaT.textAlignment = NSTextAlignmentLeft;
    _MimaT.textColor = TTG3;
    _MimaT.secureTextEntry = YES;
    _MimaT.delegate = self;
    _MimaT.returnKeyType =  UIReturnKeyDone;
    _MimaT.font = [UIFont fontWithName:@"STHeitiTC-Light" size:15];
    [secondView addSubview:_MimaT];
    
    _EnterBtn = [[UIButton alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(secondView.frame) + 35, WIN_WIDTH - 88, 50)];
    _EnterBtn.backgroundColor = [UIColor colorWithRed:0.00f green:0.55f blue:0.93f alpha:1.00f];
    _EnterBtn.layer.cornerRadius = 3;
    [_EnterBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [_EnterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _EnterBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17];
    [_EnterBtn addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_EnterBtn];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(_EnterBtn.frame) + 20, 60, 30)];
    [leftBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitleColor:TMHEADCOLO forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(ZuCheAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 60 - 44, CGRectGetMaxY(_EnterBtn.frame) + 20, 60, 30)];
    [rightBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:TMHEADCOLO forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(ForgetAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(27, WIN_HEIGHT - 132, 109, 0.5)];
    leftLab.backgroundColor = Ae1e2e6;
    [self.view addSubview:leftLab];
    UILabel *sanFangLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLab.frame), WIN_HEIGHT - 142, WIN_WIDTH - 272, 20)];
    sanFangLab.text = @"第三方直接登录";
    sanFangLab.font = [UIFont systemFontOfSize:10];
    sanFangLab.textColor = BEBEBE;
    sanFangLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:sanFangLab];
    
    UILabel *rightLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sanFangLab.frame), WIN_HEIGHT - 132, 109, 0.5)];
    rightLab.backgroundColor = Ae1e2e6;
    [self.view addSubview:rightLab];
    
    UIImageView *imageGo = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2 - 7, CGRectGetMaxY(sanFangLab.frame) + 13, 14, 9)];
    imageGo.image = [UIImage imageNamed:@"jiantou-"];
    [self.view addSubview:imageGo];
    if([WXApi isWXAppInstalled]){
        _qqBtn = [[UIButton alloc]initWithFrame:CGRectMake((WIN_WIDTH-190)/2, CGRectGetMaxY(imageGo.frame) + 14, 40, 40)];
        [_qqBtn setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        [_qqBtn addTarget:self action:@selector(qqAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_qqBtn];
        
        _qqLab = [[UILabel alloc]initWithFrame:CGRectMake((WIN_WIDTH-190)/2, CGRectGetMaxY(_qqBtn.frame) + 9, 40, 20)];
        _qqLab.text = @"QQ";
        _qqLab.textColor = A333;
        _qqLab.font = [UIFont systemFontOfSize:12];
        _qqLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_qqLab];
        
        _weiBoBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_qqBtn.frame) + 35, CGRectGetMaxY(imageGo.frame) + 14, 40, 40)];
        [_weiBoBtn setBackgroundImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
        [self.view addSubview:_weiBoBtn];
        
        _weiBoLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_qqBtn.frame) + 35, CGRectGetMaxY(_weiBoBtn.frame) + 9, 40, 20)];
        _weiBoLab.text = @"微博";
        _weiBoLab.textColor = A333;
        [_weiBoBtn addTarget:self action:@selector(weiboAction) forControlEvents:UIControlEventTouchUpInside];
        _weiBoLab.font = [UIFont systemFontOfSize:12];
        _weiBoLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_weiBoLab];
        
        _weiXinBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_weiBoBtn.frame) + 35, CGRectGetMaxY(imageGo.frame) + 14, 40, 40)];
        [_weiXinBtn setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
        [_weiXinBtn addTarget:self action:@selector(weixinAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_weiXinBtn];
        
        _weiXinLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_weiBoBtn.frame) + 35, CGRectGetMaxY(_weiBoBtn.frame) + 9, 40, 20)];
        _weiXinLab.text = @"微信";
        _weiXinLab.textColor = A333;
        _weiXinLab.font = [UIFont systemFontOfSize:12];
        _weiXinLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_weiXinLab];
    } else {
        _qqBtn = [[UIButton alloc]initWithFrame:CGRectMake((WIN_WIDTH-190)/2, CGRectGetMaxY(imageGo.frame) + 14, 40, 40)];
        [_qqBtn setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        [_qqBtn addTarget:self action:@selector(qqAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_qqBtn];
        
        _qqLab = [[UILabel alloc]initWithFrame:CGRectMake((WIN_WIDTH-190)/2, CGRectGetMaxY(_qqBtn.frame) + 9, 40, 20)];
        _qqLab.text = @"QQ";
        _qqLab.textColor = A333;
        _qqLab.font = [UIFont systemFontOfSize:12];
        _qqLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_qqLab];
        
        _weiBoBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_qqBtn.frame) + 110, CGRectGetMaxY(imageGo.frame) + 14, 40, 40)];
        [_weiBoBtn setBackgroundImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
        [self.view addSubview:_weiBoBtn];
        
        _weiBoLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_qqBtn.frame) + 110, CGRectGetMaxY(_weiBoBtn.frame) + 9, 40, 20)];
        _weiBoLab.text = @"微博";
        _weiBoLab.textColor = A333;
        [_weiBoBtn addTarget:self action:@selector(weiboAction) forControlEvents:UIControlEventTouchUpInside];
        _weiBoLab.font = [UIFont systemFontOfSize:12];
        _weiBoLab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_weiBoLab];
    }
    
}
-(void)ForgetAction:(UIButton *)btn
{
    BackMViewController *vc = [BackMViewController new];
    [self.navigationController  pushViewController:vc animated:YES];
}

-(void)ZuCheAction:(UIButton *)button
{
    ZhuCeViewController *vc = [ZhuCeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    //[self presentViewController:vc animated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark-- 登录
-(void)enterAction
{
    if(!(_PhoneT.text.length  > 0)){
        [tools alert:@"用户名不能为空"];
    }else{
        if(!(_MimaT.text.length > 0)){
            [tools alert:@"密码不能为空"];
        }else{
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode=MBProgressHUDAnimationFade;
            NSString *str = _PhoneT.text;
            str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = @{@"account":str,@"password":_MimaT.text,@"version":VERSION,@"charset":@"utf-8"};
            //初始化Manager
            NSString *urlString = [NSString stringWithFormat:@"%@/member/login",API_HOST];
            SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
            [afTool postMessage:urlString useDictonary:dic progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                NSDictionary *dic = responseObject[@"data"];
                NSString *string = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if([string isEqualToString:@"0"]){
                    
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"sticket"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"stime"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"susername"];
                    NSString *stime = [NSString stringWithFormat:@"%@",dic[@"s_time"]];
                    NSString *sticket = [NSString stringWithFormat:@"%@",dic[@"s_ticket"]];
                    NSString *susername = [NSString stringWithFormat:@"%@",dic[@"s_username"]];
                    [[NSUserDefaults standardUserDefaults]setValue:sticket forKey:@"sticket"];
                    [[NSUserDefaults standardUserDefaults]setValue:stime forKey:@"stime"];
                    [[NSUserDefaults standardUserDefaults]setValue:susername forKey:@"susername"];
                    [self dismissViewControllerAnimated:YES completion:nil];
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                    [alert show];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"enter" object:nil];
                }else{
                    [tools alert:responseObject[@"msg"]];
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0)
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)toucheBegan
{
    [_MimaT resignFirstResponder];
    [_PhoneT resignFirstResponder];
}

-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent ;
}

#pragma mark-微博
-(void)weiboAction
{
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wb4281350467"]]) { //这里的wbxxxxxxxxx是URL schemes
//        [WeiboSDK registerApp:WEIBOKEY];
//        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//        request.redirectURI = @"http://co188.com";
//        [WeiboSDK sendRequest:request];
//    }else{
//        [tools alert:@"请安装微博客户端"];
//    }
    
//    if([WeiboSDK isWeiboAppInstalled]){
//        [WeiboSDK registerApp:WEIBOKEY];
//        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//        request.redirectURI = @"http://co188.com";
//        [WeiboSDK sendRequest:request];
//    }else{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id350962117"]];
//
//    }
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WEIBOKEY];
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://co188.com";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

//- (void)receiveNotificiation:(NSNotification*)sender{
//    
//    NSString *token = [sender.userInfo objectForKey:@"token"];
//    NSString *uid = [sender.userInfo objectForKey:@"uid"];
//    [self getWeiBoUserInfo:uid token:token];
//                      
//}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSLog(@"token %@", [(WBAuthorizeResponse *) response accessToken]);
    NSLog(@"uid %@", [(WBAuthorizeResponse *) response userID]);
    
    [self getWeiBoUserInfo:[(WBAuthorizeResponse *) response userID] token:[(WBAuthorizeResponse *) response accessToken]];
}
-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];                //打印接收到的数据，可以根据需要而从字典里取出来
    NSLog(@"%@",dic);
}

- (void)getWeiBoUserInfo:(NSString *)uid token:(NSString *)token
{
    NSString *url =[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@&source=%@",uid,token,WEIBOKEY];
    NSURL *zoneUrl = [NSURL URLWithString:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    // 创建任务
    NSURLSessionDataTask * task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:zoneUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@", [NSThread currentThread]);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dic);
        NSString *errorStr = dic[@"error"];
        if(errorStr.length > 0){
            
        }else{
            [self thirdWayEnter:@"weibo" withOpenid:[dic valueForKeyPath:@"idstr"] withName:[dic valueForKeyPath:@"screen_name"] accessToken:token];
        }
    }];
    // 启动任务
    [task resume];
}

#pragma mark-qq
-(void)qqAction
{
//    if([QQApiInterface isQQInstalled]){
//        // 注册QQ
//        _tencentOAuth = [[TencentOAuth alloc]initWithAppId:TENGCENTAPPID andDelegate:self];
//        // 这个是说到时候你去qq那拿什么信息
//        _tencentPermissions = [NSMutableArray arrayWithArray:@[/** 获取用户信息 */
//                                                               kOPEN_PERMISSION_GET_USER_INFO,
//                                                               /** 移动端获取用户信息 */
//                                                               kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
//                                                               /** 获取登录用户自己的详细信息 */
//                                                               kOPEN_PERMISSION_GET_INFO]];
//        
//        [_tencentOAuth authorize:_tencentPermissions];
//
//    }else{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id444934666"]];
//    }
    // 注册QQ
    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:TENGCENTAPPID andDelegate:self];
    // 这个是说到时候你去qq那拿什么信息
    _tencentPermissions = [NSMutableArray arrayWithArray:@[/** 获取用户信息 */
                                                           kOPEN_PERMISSION_GET_USER_INFO,
                                                           /** 移动端获取用户信息 */
                                                           kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                                           /** 获取登录用户自己的详细信息 */
                                                           kOPEN_PERMISSION_GET_INFO]];
    
    [_tencentOAuth authorize:_tencentPermissions];
}

#pragma mark - TencentLoginDelegate
//委托
- (void)tencentDidLogin
{
    [_tencentOAuth getUserInfo];
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    NSLog(@"respons:%@",response.jsonResponse);  
    if (response.retCode == URLREQUEST_SUCCEED)
    {
        NSLog(@"%@", response.jsonResponse);
        NSLog(@"openID %@", [_tencentOAuth openId]);
        NSDictionary *paramter = @{@"third_id" : [_tencentOAuth openId],
                                   @"third_name" : [response.jsonResponse valueForKeyPath:@"nickname"],
                                   @"third_image" : [response.jsonResponse valueForKeyPath:@"figureurl_qq_2"],
                                   @"access_token" : [_tencentOAuth accessToken]};
         [self thirdWayEnter:@"qq" withOpenid:[_tencentOAuth openId] withName:[response.jsonResponse valueForKeyPath:@"nickname"] accessToken:[_tencentOAuth accessToken]];
    }
    else
    {
        NSLog(@"登录失败!");
    }
}

- (void)tencentDidLogout
{
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    
}

- (void)tencentDidNotNetWork
{
    
}


#pragma mark- weixin
-(void)weixinAction
{
    
    if([WXApi isWXAppInstalled]){
        [WXApi registerApp:WEIXINAPPKEY];
        // 微信注册
        SendAuthReq* req =[[SendAuthReq alloc ] init ];
        req.scope = @"snsapi_userinfo" ;
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id414478124"]];
    }
}

#pragma mark - WXApiDelegate
-(void)onResp:(BaseResp*)resp
{
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (resp.errCode == 0) {
        NSString *code = aresp.code;
        [self getWeiXinUserInfoWithCode:code];
    }else{
//        [tools alert:@"未授权"];
    }
}

- (void)getWeiXinUserInfoWithCode:(NSString *)code
{
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    NSBlockOperation * getAccessTokenOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSString * urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WEIXINAPPKEY,WEIXINSECRITE,code];
        NSURL * url = [NSURL URLWithString:urlStr];
        NSString *responseStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *responseData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        self.access_token = [dic objectForKey:@"access_token"];
    }];
    
    NSBlockOperation * getUserInfoOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSString *urlStr =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self.access_token,WEIXINAPPKEY];
        NSURL * url = [NSURL URLWithString:urlStr];
        NSString *responseStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *responseData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        NSLog(@"%@",dic);
        NSDictionary *paramter = @{@"third_id" :dic[@"openid"],
                                   @"third_name" :dic[@"nickname"],
                                   @"third_image":dic[@"headimgurl"],
                                   @"access_token":self.access_token};
        [self thirdWayEnter:@"wx" withOpenid:dic[@"unionid"] withName:dic[@"nickname"] accessToken:self.access_token];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                _resultBlock;
//            self.resultBlock(paramter, nil);
        }];
    }];
    
    [getUserInfoOperation addDependency:getAccessTokenOperation];
    
    [queue addOperation:getAccessTokenOperation];
    [queue addOperation:getUserInfoOperation];
}

-(void)thirdWayEnter:(NSString *)name withOpenid:(NSString *)openid withName:(NSString *)useName accessToken:(NSString *)token
{
    useName = [useName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"openid":openid,@"site":name,@"nickname":useName,@"charset":@"utf-8",@"access_token":token};
    //初始化Manager
    NSString *urlString = [NSString stringWithFormat:@"%@/member/getThirdLogin",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    [afTool postMessage:urlString useDictonary:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dic = responseObject[@"data"];
            NSDictionary *data = dic[@"logindata"];
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"sticket"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"stime"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"susername"];
            NSString *stime = [NSString stringWithFormat:@"%@",data[@"""s_time"""]];
            NSString *sticket = [NSString stringWithFormat:@"%@",data[@"""s_ticket"""]];
            NSString *susername = [NSString stringWithFormat:@"%@",data[@"""s_username"""]];
            [[NSUserDefaults standardUserDefaults]setValue:sticket forKey:@"sticket"];
            [[NSUserDefaults standardUserDefaults]setValue:stime forKey:@"stime"];
            [[NSUserDefaults standardUserDefaults]setValue:susername forKey:@"susername"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"weiixnEnter" object:nil];
//            [self dismissViewControllerAnimated:YES completion:nil];
            
            //                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            //                    [alert show];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"enter" object:nil];
        }else{
            [tools alert:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}
@end

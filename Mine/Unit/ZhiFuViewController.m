//
//  ZhiFuViewController.m
//  SCCBBS
//
//  Created by co188 on 17/1/12.
//  Copyright © 2017年 co188. All rights reserved.
//

#import "ZhiFuViewController.h"
#import "SCCHeader.h"
#import <AlipaySDK/AlipaySDK.h>
#import "SCCAFnetTool.h"
#import <MBProgressHUD.h>
#import "MessageTool.h"
#import "tools.h"
#import "Order.h"
#import "RSADataSigner.h"
#import "ZhiFuResultController.h"
#import "WXApi.h"

@interface ZhiFuViewController ()<WXApiDelegate>
{
    UILabel *_label;
    UIButton *_leftBtn;
    
    NSString *_body;
    NSString *_MONEY;
    NSString *_orderid;
    NSString *_prvateKey;
}
@end

@implementation ZhiFuViewController

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ziFuResult:) name:@"ziFuNoti" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"支付方式";
    _label.textAlignment = NSTextAlignmentCenter;
    
    _label.font = [UIFont systemFontOfSize:18];
    _label.textColor = [UIColor whiteColor];
    _label.center = CGPointMake(headView.center.x, _label.center.y);
    [headView addSubview:_label];
    
    _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 40, 44)];
    _leftBtn.imageEdgeInsets=UIEdgeInsetsMake(10, 6, 9, 15);
    [_leftBtn setImage:[UIImage imageNamed:@"back"]  forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.center = CGPointMake(_leftBtn.center.x, _label.center.y);
    [headView addSubview:_leftBtn];

    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI
{
    UILabel *firstLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 74, 150, 19)];
    firstLab.text = @"充值工程点";
    firstLab.textColor = A333;
    firstLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:firstLab];
    
    UILabel *dianLab = [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH - 100, 74, 88, 19)];
    dianLab.text = [NSString stringWithFormat:@"%@ 点",_dianShu];
    dianLab.textColor = A333;
    dianLab.font = [UIFont systemFontOfSize:14];
    dianLab.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:dianLab];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(firstLab.frame) + 10, WIN_WIDTH - 24, 0.5)];
    line.backgroundColor = Ae1e2e6;
    [self.view addSubview:line];
    
    UILabel *secLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(line.frame) + 10, 150, 19)];
    secLab.text = @"应付金额";
    secLab.textColor = A333;
    secLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:secLab];
    
    UILabel *moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH - 100, CGRectGetMaxY(line.frame) + 10, 88, 19)];
    moneyLab.text = [NSString stringWithFormat:@"¥ %@",_price];
    moneyLab.textColor = FFA800;
    moneyLab.font = [UIFont systemFontOfSize:14];
    moneyLab.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:moneyLab];
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(secLab.frame) + 10, WIN_WIDTH - 0, 0.5)];
    line2.backgroundColor = Ae1e2e6;
    [self.view addSubview:line2];
    
    UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame), WIN_WIDTH, 15)];
    cellView.backgroundColor = Af4f5f9;
    [self.view addSubview:cellView];
    
    UILabel *payStyle = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(cellView.frame) + 12, WIN_WIDTH - 24, 19)];
    payStyle.text = @"请选择支付方式";
    payStyle.textColor = A999;
    payStyle.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:payStyle];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(payStyle.frame) + 30, 27, 27)];
    imgView.image = [UIImage imageNamed:@"zhifubao"];
    [self.view addSubview:imgView];
    
    UILabel *weixinLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 19, CGRectGetMinY(imgView.frame), 100, 27)];
    weixinLab.textColor = A333;
    weixinLab.text = @"支付宝";
    weixinLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:weixinLab];
    UIView *WXView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(payStyle.frame) + 18.5, WIN_WIDTH, 50)];
    [self.view addSubview:WXView];
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(WXView.frame), WIN_WIDTH - 24, 0.5)];
    lineLab.backgroundColor = Ae1e2e6;
    [self.view addSubview:lineLab];
    
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(payStyle.frame) + 20, WIN_WIDTH, 47)];
    coverView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhifuAction)];
    [coverView addGestureRecognizer:tap];
    [self.view addSubview:coverView];
    
    UIImageView *ZFImg = [[UIImageView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lineLab.frame) + 11.5, 27, 27)];
    ZFImg.image = [UIImage imageNamed:@"weixin-1"];
    [self.view addSubview:ZFImg];
    
    UILabel *zfLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ZFImg.frame) + 19, CGRectGetMinY(ZFImg.frame), 100, 27)];
    zfLab.textColor = A333;
    zfLab.text = @"微信";
    zfLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:zfLab];
    UIView *ZFView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineLab.frame), WIN_WIDTH, 50)];
    [self.view addSubview:ZFView];
    
    
    UIView *coverWXView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineLab.frame), WIN_WIDTH, 47)];
    coverView.userInteractionEnabled = YES;
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WXZhiFuAction)];
    [coverWXView addGestureRecognizer:Tap];
    [self.view addSubview:coverWXView];

    UILabel *lastLine = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ZFView.frame), WIN_WIDTH, 0.5)];
    lastLine.backgroundColor = Ae1e2e6;
    [self.view addSubview:lastLine];
    
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)zhifuAction
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/charge/pointPay",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:_pid forKey:@"pid"];
    [messageDic setObject:_price forKey:@"money"];
    [messageDic setObject:@"7" forKey:@"gate"];
    [messageDic setObject:VERSION forKey:@"version"];
    NSLog(@"%@",messageDic);
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dataDic = responseObject[@"data"];
            _body = dataDic[@"body"];
            _MONEY = dataDic[@"money"];
            _orderid = dataDic[@"orderid"];
            _prvateKey = dataDic[@"prvate_key"];
            [self gotoZhiFu];
        }else if([code isEqualToString:@"500"]){
            [tools alert:responseObject[@"msg"]];
        }else if([code isEqualToString:@"401"]){
            [tools alert:responseObject[@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)gotoZhiFu
{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    // NOTE: app_id设置
    order.app_id = ZHIFUBAOAPPID;
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    // NOTE: 支付版本
    order.version = @"1.0";
    order.notify_url = @"http://paytest.co188.com/app/alipay_notify.php";
    // NOTE: sign_type
    order.sign_type = @"RSA";
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = _body;
    order.biz_content.subject = _body;
    order.biz_content.out_trade_no = _orderid; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    CGFloat money = _MONEY.floatValue;
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f",money]; //商品价格
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:_prvateKey];
    signedString = [signer signString:orderInfo withRSA2:NO];
    NSLog(@"%@",signedString);
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"tumuzaixian";
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

-(void)ziFuResult:(NSNotification *)noti
{
    NSDictionary * infoDic = noti.userInfo;
    NSLog(@"reslut = %@",infoDic);
    NSString *resultStatus = [NSString stringWithFormat:@"%@",infoDic[@"resultStatus"]];
    if([resultStatus isEqualToString:@"9000"]){
        ZhiFuResultController *vc = [ZhiFuResultController new];
        vc.congDian = _dianShu;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
}

#pragma mark-微信支付

-(void)WXZhiFuAction
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/charge/pointPay",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:_pid forKey:@"pid"];
    [messageDic setObject:_price forKey:@"money"];
    [messageDic setObject:@"8" forKey:@"gate"];
    [messageDic setObject:VERSION forKey:@"version"];
    NSLog(@"%@",messageDic);
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            
        }else if([code isEqualToString:@"500"]){
            [tools alert:responseObject[@"msg"]];
        }else if([code isEqualToString:@"401"]){
            [tools alert:responseObject[@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}
-(void)weixinPay {
   
//    PayReq* req             = [[PayReq alloc] init];
//    req.partnerId           = _partnerid;
//    req.prepayId            = _prepayid;
//    req.nonceStr            = _noncestr;
//    req.timeStamp           = [_timestamp intValue];
//    req.package             = _package;
//    req.sign                = _sign;
//    [WXApi sendReq:req];
}
#pragma mark-WXApiDelegate
-(void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"myMoney" object:nil];
//                [self goSuccess];
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                [tools  alert:@"支付失败"];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
}

@end

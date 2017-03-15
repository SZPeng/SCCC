//
//  SCCZhiFuTool.m
//  SCCBBS
//
//  Created by co188 on 17/2/22.
//  Copyright © 2017年 co188. All rights reserved.
//

#import "SCCZhiFuTool.h"
#import <UIKit/UIKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "RSADataSigner.h"
#import "WXApi.h"
@implementation SCCZhiFuTool

-(void)zhuFuBaopay:(NSString *)notify_url withBody:(NSString *)body withOrderid:(NSString *)orderid withMoney:(NSString *)money withPrvateKey:(NSString *)prvateKey
{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    // NOTE: app_id设置
    order.app_id = @"";  //appKey
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
    order.notify_url = notify_url;
    // NOTE: sign_type
    order.sign_type = @"RSA";
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = body;
    order.biz_content.subject = body;
    order.biz_content.out_trade_no = orderid; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    CGFloat Money = money.floatValue;
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f",Money]; //商品价格
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:prvateKey];
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

-(void)weiXinPay:(NSString *)partnerId withPrepayStr:(NSString *)prepayId withNonceStr:(NSString *)nonceStr withTimeStamp:(NSString *)timeStamp withPackage:(NSString *)package withSign:(NSString *)sign
{
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = partnerId;
        req.prepayId            = prepayId;
        req.nonceStr            = nonceStr;
        req.timeStamp           = [timeStamp intValue];
        req.package             = package;
        req.sign                = sign;
        [WXApi sendReq:req];
}


@end

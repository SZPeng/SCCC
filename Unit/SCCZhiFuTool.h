//
//  SCCZhiFuTool.h
//  SCCBBS
//
//  Created by co188 on 17/2/22.
//  Copyright © 2017年 co188. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCCZhiFuTool : NSObject


#pragma mark- 支付宝
-(void)zhuFuBaopay:(NSString *)notify_url withBody:(NSString *)body withOrderid:(NSString *)orderid withMoney:(NSString *)money withPrvateKey:(NSString *)prvateKey;

#pragma mark- 微信
-(void)weiXinPay:(NSString *)partnerId withPrepayID:(NSString *)prepayId withNonceStr:(NSString *)nonceStr withTimeStamp:(NSString *)timeStamp withPackage:(NSString *)package withSign:(NSString *)sign;
@end

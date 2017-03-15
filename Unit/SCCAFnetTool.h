//
//  SCCAFnetTool.h
//  SCCBBS
//
//  Created by co188 on 16/10/28.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@interface SCCAFnetTool : NSObject

-(AFHTTPSessionManager *)getManager;

-(void)getMessage:(NSString *)urlString useDictonary:(NSDictionary *)dic progress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;

-(void)postMessage:(NSString *)urlString useDictonary:(NSDictionary *)dic progress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;

@end

//
//  SCCAFnetTool.m
//  SCCBBS
//
//  Created by co188 on 16/10/28.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "SCCAFnetTool.h"

@implementation SCCAFnetTool

-(AFHTTPSessionManager *)getManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return manager;
}

-(void)getMessage:(NSString *)urlString useDictonary:(NSDictionary *)dic progress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    AFHTTPSessionManager *manager = [self getManager];
    [manager GET:urlString parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
    
}
-(void)postMessage:(NSString *)urlString useDictonary:(NSDictionary *)dic progress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    AFHTTPSessionManager *manager = [self getManager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    [manager POST:urlString parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
        NSLog(@"%@",error);
    }];
}
@end

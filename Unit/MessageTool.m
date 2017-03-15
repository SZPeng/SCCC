//
//  MessageTool.m
//  SCCBBS
//
//  Created by co188 on 16/11/1.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "MessageTool.h"

@implementation MessageTool

+(NSMutableDictionary *)getMessage
{
    NSString *stime = [[NSUserDefaults standardUserDefaults]valueForKey:@"stime"];
    NSString *susername = [[NSUserDefaults standardUserDefaults]valueForKey:@"susername"];
    NSString *sticket = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
//    NSDictionary  *dic = @{@"time":stime,@"ticket":sticket,@"username":susername};
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:stime,@"time",sticket,@"ticket",susername,@"username",nil];
    return dic2;
}
@end

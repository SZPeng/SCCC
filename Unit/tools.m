//
//  tools.m
//  环信练习
//
//  Created by Apple zfwj on 15/10/17.
//  Copyright © 2015年 Apple zfwj. All rights reserved.
//

#import "tools.h"

@implementation tools

+(void)alert:(NSString *)msg

{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
@end

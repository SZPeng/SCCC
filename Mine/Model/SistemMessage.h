//
//  SistemMessage.h
//  SCCBBS
//
//  Created by co188 on 16/11/14.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SistemMessage : NSObject

@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *msgid;
@property(nonatomic,copy)NSString *show_time;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *message;

@end

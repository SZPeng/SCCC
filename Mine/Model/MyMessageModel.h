//
//  MyMessageModel.h
//  SCCBBS
//
//  Created by co188 on 16/11/11.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMessageModel : NSObject

@property(nonatomic,copy)NSString *msgid;
@property(nonatomic,copy)NSString *subject;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *headImg;
@end

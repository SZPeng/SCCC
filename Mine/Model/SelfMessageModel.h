//
//  SelfMessageModel.h
//  SCCBBS
//
//  Created by co188 on 16/11/14.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelfMessageModel : NSObject

@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *mid;
@property(nonatomic,copy)NSString *myself;
@property(nonatomic,copy)NSString *time;
@end

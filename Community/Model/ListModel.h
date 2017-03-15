//
//  ListModel.h
//  SCCBBS
//
//  Created by co188 on 16/11/24.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject

@property(nonatomic,copy)NSString *author;
@property(nonatomic,copy)NSString *dateline;
@property(nonatomic,copy)NSString *imgnum;
@property(nonatomic,copy)NSString *subject;
@property(nonatomic,copy)NSString *tid;
@property(nonatomic,copy)NSString *views;
@property(nonatomic,copy)NSString *authorid;

@property(nonatomic,copy)NSString *collected;
@property(nonatomic,strong)NSArray *imgArray;

@end

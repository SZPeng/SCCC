//
//  RepliesViewController.h
//  SCCBBS
//
//  Created by co188 on 16/11/28.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "ViewController.h"

@interface RepliesViewController : ViewController

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *tid;

@property(nonatomic,copy)NSString *pid;

@property (nonatomic,strong)void(^callBack)();

@property(nonatomic,copy)NSString *isHuiFu;

@property(nonatomic,copy)NSString *isLouZu; //是不是楼主
@end

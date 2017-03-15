//
//  FaTieViewController.h
//  SCCBBS
//
//  Created by co188 on 16/11/28.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "ViewController.h"

@interface FaTieViewController : ViewController

@property(nonatomic,copy)NSString *fid;

@property (nonatomic,strong)void(^callBack)();
@end

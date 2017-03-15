//
//  DetailViewController.h
//  SCCBBS
//
//  Created by co188 on 16/10/31.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "ViewController.h"

@interface DetailViewController : ViewController

@property(nonatomic,copy)NSString *urlString;

@property(nonatomic,copy)NSString *tid;
@property(nonatomic,copy)NSString *authorid;

@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *imgUrl;

@property(nonatomic,copy)NSString *collected;

@property(nonatomic,copy)NSString *comeFrom;

@property(nonatomic,strong)void(^callBack)();
@end

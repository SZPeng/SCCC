//
//  SCCTitleMenuViewController.h
//  YBZF
//
//  Created by chunchendeMac on 15/11/19.
//  Copyright © 2015年 ChunChen.App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCTitleMenuViewController : UIViewController


@property (nonatomic, strong) void(^callBack)();

@property (nonatomic, strong) void(^Back)();

+(id)shareSccTitle;
@end

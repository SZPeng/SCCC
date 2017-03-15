//
//  MineHeadView.h
//  SCCBBS
//
//  Created by co188 on 16/11/8.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineHeadView : UIView

@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *numTuMu;
@property(nonatomic,copy)NSString *numProgect;
@property(nonatomic,copy)NSString *numQianDao;
@property(nonatomic,copy)NSString *tuMuText;
@property(nonatomic,copy)NSString *progectText;
@property(nonatomic,copy)NSString *qianDao;

@property(nonatomic,copy)NSString *signature;

@property(nonatomic,copy)NSString *dengStyle;
@property(nonatomic,copy)NSString *vipLevel;

@property(nonatomic,strong)void(^callBack)(NSInteger num);
@property(nonatomic,strong)void(^clickBack)();

@property(nonatomic,strong)void(^headCallBack)();
@end

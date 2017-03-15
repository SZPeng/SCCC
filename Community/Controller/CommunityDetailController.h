//
//  CommunityDetailController.h
//  SCCBBS
//
//  Created by co188 on 16/11/24.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "ViewController.h"
#import "HistoryTable.h"

#import "ConsultationTable.h"

@interface CommunityDetailController : ViewController

@property(nonatomic,copy)NSString *nameTitle;
@property(nonatomic,copy)NSString *fid;

@property(nonatomic,strong)HistoryTable*tableObj;

@property(nonatomic,strong)ConsultationTable*table;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *firstId;


@end

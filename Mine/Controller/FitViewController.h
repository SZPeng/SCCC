//
//  FitViewController.h
//  SCCBBS
//
//  Created by co188 on 16/11/10.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "ViewController.h"
#import "ConsultationTable.h"
#import "HistoryTable.h"

@interface FitViewController : ViewController
@property(nonatomic,strong)ConsultationTable*table;
@property(nonatomic,strong)HistoryTable*tableObj;

@end

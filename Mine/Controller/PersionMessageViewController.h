//
//  PersionMessageViewController.h
//  SCCBBS
//
//  Created by co188 on 17/1/12.
//  Copyright © 2017年 co188. All rights reserved.
//

#import "ViewController.h"
#import "HistoryTable.h"
#import "ConsultationTable.h"

@interface PersionMessageViewController : ViewController

@property(nonatomic,copy)NSString *idString;
@property(nonatomic,strong)HistoryTable*tableObj;

@property(nonatomic,strong)ConsultationTable*table;
@end

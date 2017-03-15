//
//  HistoryTable.m
//  SCCBBS
//
//  Created by co188 on 16/12/8.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "HistoryTable.h"

@implementation HistoryTable
static HistoryTable* _instance = nil;

//+(HistoryTable *)share
//{
//    
//    static dispatch_once_t onceToken ;
//    dispatch_once(&onceToken, ^{
//        _instance = [[super allocWithZone:NULL] init] ;
//    });
//    return _instance;
//    
//}
-(PYStructure *)structure{
 
    PYStructure * st = [[PYStructure alloc] init];
    [st addWithField:@"tid" andType:PYStructureTypeNormalText];
    [st addWithField:@"titleStr" andType:PYStructureTypeNormalText];
    [st addWithField:@"dateline" andType:PYStructureTypeNormalText];
    [st addWithField:@"imgUrl" andType:PYStructureTypeNormalText];
    [st addWithField:@"authorid" andType:PYStructureTypeNormalText];
    [st addWithField:@"numViews" andType:PYStructureTypeNormalText];
    //model.views
    
    return st;
}

-(NSString *)tableName{
    return @"sccHistory";
}

@end

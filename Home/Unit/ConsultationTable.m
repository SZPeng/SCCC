//
//  ConsultationTable.m
//  SCCBBS
//
//  Created by co188 on 16/11/23.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "ConsultationTable.h"

@implementation ConsultationTable

-(PYStructure *)structure{
    PYStructure * st = [[PYStructure alloc] init];
    [st addWithField:@"name" andType:PYStructureTypeNormalText];
    
    return st;
}

-(NSString *)tableName{
    return @"sccConsultation";
}
@end

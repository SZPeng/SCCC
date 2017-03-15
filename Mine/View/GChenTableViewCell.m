//
//  GChenTableViewCell.m
//  SCCBBS
//
//  Created by co188 on 17/1/11.
//  Copyright © 2017年 co188. All rights reserved.
//

#import "GChenTableViewCell.h"
#import "SCCHeader.h"
@implementation GChenTableViewCell

-(void)setModel:(GChenModel *)model
{
    _model = model;
    _titleLab.text = model.detail;
    NSString *str = [model.time substringToIndex:10];
    _timeLab.text = str;
    
    _numlab.textColor = FFA800;
    _lineLab.backgroundColor = Ae1e2e6;
    
    _numlab.text = [NSString stringWithFormat:@"%@",model.num];
}


@end

//
//  MyMessageCell.m
//  SCCBBS
//
//  Created by co188 on 16/11/11.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "MyMessageCell.h"
#import <UIImageView+WebCache.h>
#import "SCCHeader.h"
@implementation MyMessageCell

-(void)setModel:(MyMessageModel *)model
{
    _lineLab.backgroundColor = Ad6d6d6;
    _model = model;
    _nameLab.text = model.subject;
    _nameLab.textColor = A333;
    _timeLab.text = model.time;
    _timeLab.textColor = A999;
    _messageLab.text = model.message;
    _messageLab.textColor = A999;
    _messageLab.font = [UIFont systemFontOfSize:13];
    [_headImg sd_setImageWithURL:[NSURL URLWithString:model.headImg]];
    _headImg.layer.cornerRadius = 26.5;
    _headImg.clipsToBounds = YES;
}


@end

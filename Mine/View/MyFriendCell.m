//
//  MyFriendCell.m
//  SCCBBS
//
//  Created by co188 on 17/1/17.
//  Copyright © 2017年 co188. All rights reserved.
//

#import "MyFriendCell.h"
#import <UIImageView+WebCache.h>
#import "SCCHeader.h"
@implementation MyFriendCell

-(void)setModel:(MyFriendModel *)model
{
    _model = model;
    [_headImg sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    _headImg.layer.cornerRadius = 26;
    _headImg.clipsToBounds = YES;
    
    _nameLab.text = model.username;
    _nameLab.font = [UIFont systemFontOfSize:16];
    _nameLab.textColor = A333;
    
    _qianLab.textColor = A999;
    _qianLab.font = [UIFont systemFontOfSize:12];
    _qianLab.text = model.sightml;
    
    _persionMes.textColor = A008cee;
    _persionMes.font = [UIFont systemFontOfSize:10];
    
    _lineLab.backgroundColor = Ad6d6d6;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendMessage)];
    [_coverView addGestureRecognizer:tap];
}
-(void)sendMessage
{
    _callBack(_model.username);
}
@end

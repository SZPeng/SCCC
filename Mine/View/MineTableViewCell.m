//
//  MineTableViewCell.m
//  SCCBBS
//
//  Created by co188 on 16/11/8.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "MineTableViewCell.h"
#import "SCCHeader.h"
@implementation MineTableViewCell

-(void)setModel:(MineModel *)model
{
    _model = model;
    _titleLab.text = model.title;
    _titleLab.textColor = A333;
    _lineLab.backgroundColor = Ae1e2e6;
    switch (model.img.integerValue) {
        case 1:
            _headIMg.image = [UIImage imageNamed:@"tieiz"];
            _lineWidth.constant = 17;
            break;
        case 2:
            _headIMg.image = [UIImage imageNamed:@"replay-1"];
            _lineWidth.constant = 17;
            break;
        case 3:
            _headIMg.image = [UIImage imageNamed:@"news-1"];
            _lineWidth.constant = 0;
            break;
        case 4:
            _headIMg.image = [UIImage imageNamed:@"setting-1"];
            _lineWidth.constant = 17;
            break;
        case 5:
            _headIMg.image = [UIImage imageNamed:@"yijian-1"];
            _lineWidth.constant = 0;
            break;
        case 6:
            _headIMg.image = [UIImage imageNamed:@"chongzhi-1"];
            _lineWidth.constant = 0;
        default:
            break;
    }
    _headIMg.clipsToBounds = YES;
    if([_name isEqualToString:@"1"]){
        _titleLab.textColor = A999;
    }
}

@end

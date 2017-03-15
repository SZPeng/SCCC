//
//  SecTableViewCell.m
//  SCCQuShan
//
//  Created by HitoiMac001 on 16/7/12.
//  Copyright © 2016年 HitoiMac001. All rights reserved.
//

#import "SecTableViewCell.h"
#import "SCCHeader.h"
@implementation SecTableViewCell

-(void)setModel:(leftModel *)model
{
    _SecLabel.text = model.name;
    _SecLabel.textColor = A888;
    _lineLab.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.80f alpha:1.00f];
    _SecLabel.font = [UIFont systemFontOfSize:13];//[UIFont fontWithName:@"STHeitiTC-Light" size:13];
    if(_index == 0){
        _SecLabel.textColor = TMHEADCOLO;
    }
}

@end

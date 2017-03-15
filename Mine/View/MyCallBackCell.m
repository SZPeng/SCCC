//
//  MyCallBackCell.m
//  SCCBBS
//
//  Created by co188 on 16/11/16.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "MyCallBackCell.h"
#import "SCCHeader.h"
@implementation MyCallBackCell
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    NSLog(@"%@",text);
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

-(void)setModel:(MyCallBackModel *)model
{
    CGSize common = [self sizeWithText:@"www" font:[UIFont systemFontOfSize:18] maxW:1000];
    _model = model;
    NSLog(@"%@",model.subject);
    _titleLab.text = model.subject;
    CGSize titleSize = [self sizeWithText:model.subject font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 24];
    if(titleSize.height / common.height > 2){
        _titleLabHeight.constant = common.height*2 + 3;
    }else{
        _titleLabHeight.constant = titleSize.height + 3;
    }
    
    _titleLab.font = [UIFont systemFontOfSize:18];
    _titleLab.textColor = A333;
    _titleLab.numberOfLines = 2;
    _PersionLab.text = [NSString stringWithFormat:@"最新回复: %@",model.lastposter];
    _PersionLab.textColor = A999;
    _PersionLab.font = [UIFont systemFontOfSize:15];
    
    //8小时误差
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
//    NSString *string = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:model.lastpost.doubleValue]];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.lastpost.doubleValue]];
    _timeLab.text = time;
    _timeLab.textColor = A999;
    _timeLab.font = [UIFont systemFontOfSize:15];
    
    _lineLab.backgroundColor = Ae1e2e6;
    
}

@end

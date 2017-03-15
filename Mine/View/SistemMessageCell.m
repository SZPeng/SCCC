//
//  SistemMessageCell.m
//  SCCBBS
//
//  Created by co188 on 16/11/11.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "SistemMessageCell.h"
#import "SCCHeader.h"
@implementation SistemMessageCell

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

-(void)setModel:(SistemMessage *)model
{
    _timeLab.text = model.date;
    _timeLab.textColor = A999;
    _messageLab.text = model.message;
    _messageLab.numberOfLines = 0;
    
    CGSize messageSize = [self sizeWithText:model.message font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 44];
    _messageLab.font = [UIFont systemFontOfSize:18];
    _messageLabHeight.constant = messageSize.height;
    _messageLab.textColor = A333;
    
    [_showBtn setTitleColor:A008cee forState:UIControlStateNormal];
    _backView.layer.borderWidth = 0.5;
    _backView.layer.borderColor = Ad6d6d6.CGColor;
    _backView.backgroundColor = [UIColor whiteColor];
    
    _showBtn.hidden = YES;
    
}

@end

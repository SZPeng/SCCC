//
//  SearchCell.m
//  SCCBBS
//
//  Created by co188 on 16/11/23.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "SearchCell.h"
#import "SCCHeader.h"
@implementation SearchCell

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

-(void)setModel:(SearchModle *)model
{
    _model = model;
    _lineLab.backgroundColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.91f alpha:1.00f];
    _messageLab.text = model.subject;
    CGSize mHeight = [self sizeWithText:model.subject font:[UIFont systemFontOfSize:17] maxW:WIN_WIDTH - 24];
    CGSize TwoSize = [self sizeWithText:@"uuu" font:[UIFont systemFontOfSize:17]];
    if(mHeight.height / TwoSize.height > 2){
        _messageHeigh.constant = TwoSize.height * 2 + 2;
    }else{
       _messageHeigh.constant = mHeight.height + 2;
    }
    
    _messageLab.textColor = A333;
    _messageLab.numberOfLines = 2;
    
    _messageLab.font = [UIFont systemFontOfSize:17];
    
    _nameLab.text = model.author;
    _nameLab.textColor = A999;
    
    _timelab.text = model.time;
    _timelab.textColor = A999;
    
    _biaoLab.text = model.forumname;
    _biaoLab.textColor = A999;
}
@end

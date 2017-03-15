//
//  SPictureCell.m
//  SCCBBS
//
//  Created by co188 on 16/11/24.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "SPictureCell.h"
#import "SCCHeader.h"
#import <UIImageView+WebCache.h>
#import "imgModel.h"
@implementation SPictureCell

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

-(void)setModel:(ListModel *)model
{
    _model = model;
    
    _messageLab.text = model.subject;
    _messageLab.textColor = A333;
    _messageLab.numberOfLines = 2;
    CGSize mesSize = [self sizeWithText:model.subject font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 121];
    CGSize mSize = [self sizeWithText:@"sss" font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 121];
    if(mesSize.height / mSize.height > 2){
        _messageHeight.constant = mSize.height * 2 + 3.5;
    }else{
        _messageHeight.constant = mesSize.height + 3.5;
    }
    _nameLab.text = model.author;
    _nameLab.textColor  = A999;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    //    NSString *string = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:model.lastpost.doubleValue]];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.dateline.doubleValue]];
    _timeLab.text = time;
    _timeLab.textColor = A999;
    
    _numLan.text = [NSString stringWithFormat:@"%@阅读",model.views];
    _numLan.textColor = A999;
    imgModel *Model = model.imgArray[0];
    
    NSLog(@"%@",Model.imgName);
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:Model.imgName]];
    
    _imgView.contentMode = UIViewContentModeScaleToFill;
    _imgView.clipsToBounds = YES;

}
@end

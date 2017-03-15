//
//  HomeTableViewCell.m
//  SCCBBS
//
//  Created by co188 on 16/10/31.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "SCCHeader.h"
#import <UIImageView+WebCache.h>
@implementation HomeTableViewCell

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

-(void)setModel:(HomeModel *)model
{
    _model = model;
    CGSize detailSiz = [self sizeWithText:model.title font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 152];
     CGSize detailSize = [self sizeWithText:@"我的" font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 152];
    if(detailSiz.height/detailSize.height > 2){
        _descripHeight.constant = detailSize.height * 2 + 5;
    }else{
      _descripHeight.constant = detailSiz.height + 5;
    }
    _descriptionLab.text = model.title;
    _descriptionLab.font = [UIFont systemFontOfSize:18];
    _descriptionLab.numberOfLines = 2;
    _descriptionLab.textColor = [UIColor colorWithRed:0.12f green:0.12f blue:0.12f alpha:1.00f];
    
    NSLog(@"%@",model.imgsrc);
    [_headImg sd_setImageWithURL:[NSURL URLWithString:model.imgsrc]];
    _headImg.clipsToBounds = YES;
    
    CGSize tagSiz = [self sizeWithText:model.stitle font:[UIFont systemFontOfSize:13] maxW:WIN_WIDTH - 152];
    CGSize numSiz = [self sizeWithText:[NSString stringWithFormat:@"%@阅读",model.views] font:[UIFont systemFontOfSize:13] maxW:WIN_WIDTH - 152];
    _tagWidth.constant = tagSiz.width + 5;
    _numWidth.constant = numSiz.width + 5;
    
    _tagLab.text = model.stitle;
    _tagLab.font =[UIFont fontWithName:@"STHeitiTC-Light" size:13];
    _tagLab.textColor = [UIColor colorWithRed:0.21f green:0.58f blue:0.94f alpha:1.00f];
    _numLab.text = [NSString stringWithFormat:@"%@阅读",model.views];
    _numLab.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13];
    _lineLab.backgroundColor = [UIColor colorWithRed:0.88f green:0.89f blue:0.90f alpha:1.00f];
}

@end

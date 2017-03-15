//
//  MineHeadView.m
//  SCCBBS
//
//  Created by co188 on 16/11/8.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "MineHeadView.h"
#import "SCCHeader.h"
#import <UIImageView+WebCache.h>
@interface MineHeadView ()
{
    UILabel *_label;
    UIImageView *_imgView;
    UILabel *_lab;
    UIView *_botmView;
    UIImageView *_imageView;
    UIImageView *_vipImg;
    UIImageView *_nianImg;
    UILabel *_qianMingLab;
}

@end
@implementation MineHeadView

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
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    UIView *backImg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 87)];
//    backImg.image = [UIImage imageNamed:@"background"];
    backImg.backgroundColor = [UIColor whiteColor];
    [self addSubview:backImg];
    _botmView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backImg.frame), WIN_WIDTH, 67)];
    _botmView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_botmView];

    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 60, 60)];
    _imageView.image = [UIImage imageNamed:@"yuan"];
    [backImg addSubview:_imageView];
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    _imgView.layer.cornerRadius = 30;
    _imgView.clipsToBounds = YES;
    
    _imgView.backgroundColor = [UIColor whiteColor];
    [_imageView addSubview:_imgView];
    
    _lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame) + 15, 18, 100, 20)];
    _lab.font = [UIFont systemFontOfSize:16];
    _lab.textAlignment = NSTextAlignmentLeft;
    _lab.textColor = A333;
    [backImg addSubview:_lab];
    _vipImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lab.frame) + 10, 18, 14, 14)];
    NSInteger vipLevel = [_vipLevel integerValue];
    if(vipLevel > 0 && vipLevel < 6){
        if(vipLevel == 1){
            _vipImg.image = [UIImage imageNamed:@"v1"];
        }else if(vipLevel == 2){
            _vipImg.image = [UIImage imageNamed:@"v2"];
        }else if(vipLevel == 3){
            _vipImg.image = [UIImage imageNamed:@"v3"];
        }else if(vipLevel == 4){
            _vipImg.image = [UIImage imageNamed:@"v4"];
        }else if(vipLevel == 5){
            _vipImg.image = [UIImage imageNamed:@"v5"];
        }else{
            _vipImg.hidden = YES;
        }
    }
    [backImg addSubview:_vipImg];
    _nianImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_vipImg.frame) + 10, 18, 14, 14)];
    _nianImg.image = [UIImage imageNamed:@"nian"];
    if(vipLevel > 0 && vipLevel < 6){
        
    }else{
        _nianImg.hidden = YES;
    }
    [backImg addSubview:_nianImg];
    
    _qianMingLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame) + 15, CGRectGetMaxY(_lab.frame) + 9, 200, 18)];
    _qianMingLab.textColor = A888;
   
    
    _qianMingLab.font = [UIFont systemFontOfSize:13];
    [backImg addSubview:_qianMingLab];
    
    UIImageView *goImg = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH - 22, 37, 7, 13)];
    goImg.image = [UIImage imageNamed:@"arrow"];
    [backImg addSubview:goImg];
    
    backImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction)];
    [backImg addGestureRecognizer:tap];
    
    for(int i = 0;i<3;i++){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i * WIN_WIDTH/3, 0, WIN_WIDTH/3, 67)];
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
        [view addGestureRecognizer:tap];
        view.tag = i;
        [_botmView addSubview:view];
        UILabel *numLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 16, WIN_WIDTH/3, 16)];
        numLab.textAlignment = NSTextAlignmentCenter;
        numLab.font = [UIFont systemFontOfSize:18];
        numLab.tag = (i + 1)*10;
        numLab.textColor = A333;
        [view addSubview:numLab];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(numLab.frame) + 7, WIN_WIDTH/3, 10)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:14];
        titleLab.textColor = A999;
        titleLab.tag = (i + 1)*100;
        [view addSubview:titleLab];
        if(i < 2){
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH/3-0.5, 17, 0.5, 32)];
            line.backgroundColor = Ad6d6d6;
            [view addSubview:line];
        }
        UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _botmView.frame.size.height - 0.5, WIN_WIDTH, 0.5)];
        lineLab.backgroundColor = Ae1e2e6;
        [_botmView addSubview:lineLab];
    }

    UIImageView *shadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH , .5)];
    shadow.backgroundColor = Ae1e2e6;
//    shadow.image = [UIImage imageNamed:@"shadow"];
    [_botmView addSubview:shadow];
    return self;
}

-(void)clickAction:(UITapGestureRecognizer *)tap
{
    if(tap.view.tag == 2){
        _callBack(2);
    }else{
        _callBack(tap.view.tag);
    }
}
-(void)setQianDao:(NSString *)qianDao
{
    CGSize nameSize = [self sizeWithText:_name font:[UIFont systemFontOfSize:16]];
    _lab.frame = CGRectMake(CGRectGetMaxX(_imageView.frame) + 15, 18, nameSize.width, 20);
    _vipImg.frame = CGRectMake(CGRectGetMaxX(_lab.frame) + 10, 18, 14, 14);
    _nianImg.frame = CGRectMake(CGRectGetMaxX(_vipImg.frame) + 10, 18, 14, 14);
    _qianDao = qianDao;
    _lab.text = _name;
    if(_signature.length > 0){
        _qianMingLab.text = _signature;
    }else{
        _qianMingLab.text = @"还没有个性签名，赶快去编辑吧！";
    }
     [_imgView sd_setImageWithURL:[NSURL URLWithString:_imgUrl]];
    for(int i = 0;i<3;i++){
        UIView *view = (UIView *)[_botmView viewWithTag:i];
        UILabel *numLab = (UILabel *)[view viewWithTag:(i+1)*10];
        UILabel *textlab = (UILabel *)[view viewWithTag:(i+1)*100];
        if(i == 0){
            numLab.text = _numTuMu;
            textlab.text = _tuMuText;
        }else if(i == 1){
            numLab.text = _numProgect;
            textlab.text = _progectText;
        }else{
            numLab.text = _numQianDao;
            textlab.text = qianDao;
        }
    }
}

-(void)clickAction
{
    _headCallBack();
}

@end

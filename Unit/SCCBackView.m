//
//  SCCBackView.m
//  SCCBBS
//
//  Created by co188 on 16/11/18.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "SCCBackView.h"
#import "SCCHeader.h"

@interface SCCBackView ()
{
    UILabel *_label;
}
@end

@implementation SCCBackView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2 - 99, 100, 198,189)];
    imgView.image = [UIImage imageNamed:@"kong"];
    [self addSubview:imgView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(imgView.frame) + 24, WIN_WIDTH - 50, 20)];
    _label.text = _message;
    _label.font = [UIFont systemFontOfSize:14];
    _label.textColor = Ac6c6c6;
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
    return self;
}

-(void)setMessage:(NSString *)message
{
    _message = message;
    
    _label.text = message;
}

@end

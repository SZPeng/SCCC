//
//  TextView.m
//  带有PlaceHolder的TextView
//
//  Created by huangdl on 15/9/9.
//  Copyright (c) 2015年 黄驿. All rights reserved.
//

#import "TextView.h"

@implementation TextView
{
    UIView *_coverView;
    UILabel *_placeHolderLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1].CGColor;
        _coverView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:_coverView];
        _coverView.backgroundColor = [UIColor clearColor];
        _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(6, 7, 200, 15)];
        [_coverView addSubview:_placeHolderLabel];
        _placeHolderLabel.font = [UIFont systemFontOfSize:14];
        _placeHolderLabel.textColor = [UIColor grayColor];
        self.font = [UIFont systemFontOfSize:14];
        
        
        [_coverView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes)]];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notAction) name:UITextViewTextDidBeginEditingNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notAction) name:UITextViewTextDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notAction) name:UITextViewTextDidEndEditingNotification object:nil];
        
    }
    return self;
}

-(void)notAction
{
    NSString *str = self.text;
    _coverView.hidden = str.length != 0;
}

-(void)tapGes
{
    [self becomeFirstResponder];
}

-(void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    _placeHolderLabel.text = placeHolder;
}

-(void)setBorderStyle:(UITextBorderStyle)borderStyle
{
    if (borderStyle == UITextBorderStyleRoundedRect) {
        self.layer.cornerRadius = 5;
    }
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    _placeHolderLabel.font = font;
    CGRect frame = _placeHolderLabel.frame;
    frame.size.height = font.lineHeight;
    _placeHolderLabel.frame = frame;
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

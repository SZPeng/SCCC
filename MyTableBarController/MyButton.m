//
//  MyButton.m
//  SCCQuShan
//
//  Created by HitoiMac001 on 16/6/8.
//  Copyright © 2016年 HitoiMac001. All rights reserved.
//


#import "MyButton.h"
#import "SCCHeader.h"
@implementation MyButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.titleLabel.font = [UIFont systemFontOfSize:12];//[UIFont fontWithName:@"STHeitiTC-Light" size:12];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [self setTitleColor:[UIColor colorWithRed:0.97f green:1.00f blue:0.92f alpha:1.00f] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self setTitleColor:[UIColor colorWithRed:0.00f green:0.55f blue:0.93f alpha:1.00f] forState:UIControlStateSelected];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 32, contentRect.size.width, 12);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - 18)/2, 7, 18, 18);
}

-(void)setHighlighted:(BOOL)highlighted
{
    
}


@end

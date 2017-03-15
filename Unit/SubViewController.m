//
//  SubViewController.m
//  侧边栏练习
//
//  Created by chunchendeMac on 15/10/14.
//  Copyright © 2015年 chunchenMac. All rights reserved.
//

#import "SubViewController.h"
#import "UIImage+IFTTTLaunchImage.h"
#import "SCCHeader.h"

@interface SubViewController ()<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
    NSArray *_imageArray;
}
@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    
    [self uiConfig];
}

-(void)prepareData
{
    _imageArray = [[NSMutableArray  alloc]initWithObjects:@"1",@"2",@"3",nil ];
}
-(void)uiConfig
{
    NSInteger osVersion = floor([[[UIDevice currentDevice] systemVersion] floatValue])*100;
    CGFloat width = WIN_WIDTH;
    CGFloat height = WIN_HEIGHT;
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scroll.contentSize = CGSizeMake(width*_imageArray.count, height);
    scroll.pagingEnabled = YES;
    scroll.userInteractionEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.delegate = self;
    scroll.bounces = NO;
    
    for (int i=0; i<_imageArray.count; i++) {
        UIImageView *imv = [[UIImageView alloc] init];
        //4.0    4.7 英寸
       if(WIN_WIDTH < 414)
        {
            if(osVersion > 320){
                imv.image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页b%@1",_imageArray[i]]];
            }
            else
            {
                imv.image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页b%@",_imageArray[i]]];
            }
        }
        //5.5英寸
        else
        {
            imv.image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页b%@2",_imageArray[i]]];
        }
        imv.frame = CGRectMake(width*i, 0, width, height);
        [scroll addSubview:imv];
        if(i == 0){
            imv.userInteractionEnabled = YES;
            CGFloat Width;
            CGFloat Height;
            if(WIN_WIDTH < 414){
                if(WIN_WIDTH > 320){
                    Height =  20;
                    Width =   WIN_WIDTH - 14 - 74;
                }else{
                    Height =  20;
                    Width =   WIN_WIDTH - 14 - 74;
                }
            } else {
                Height = 40;
                Width =   WIN_WIDTH - 74 - 26;
            }
            UIButton *btn1 = [[UIButton alloc]init];
            btn1.frame = CGRectMake(Width, Height,74, 34);
            [btn1 setBackgroundImage:[UIImage imageNamed:@"jump"] forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(startApp) forControlEvents:UIControlEventTouchUpInside];
            [imv addSubview:btn1];
            
        }else if (i == _imageArray.count-1) {
            CGFloat height;
            imv.userInteractionEnabled = YES;
            NSLog(@"%lf",WIN_WIDTH);
            if(WIN_WIDTH < 414){
                if(WIN_WIDTH > 320){
                    height =  WIN_HEIGHT - 118;
                }else{
                    height =  WIN_HEIGHT - 99;
                }
            } else {
                height = WIN_HEIGHT - 132;
            }
            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn2.frame = CGRectMake((WIN_WIDTH - 232)/2, height,232, 46);
            //            btn2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bt_sbgg_n"]];
            //            [btn2 setTitle:@"随便逛逛"forState:UIControlStateNormal];
            //            btn2.titleLabel.font = [UIFont systemFontOfSize:15];
            //            [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //            btn2.layer.cornerRadius = 6;
            //            btn2.layer.borderWidth = 0.5;
            //            btn2.layer.borderColor = [UIColor whiteColor].CGColor;
            [btn2 setBackgroundImage:[UIImage imageNamed:@"inter"] forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(startApp) forControlEvents:UIControlEventTouchUpInside];
            [imv addSubview:btn2];
        }
    }
    [self.view addSubview:scroll];
    
    _pageControl = [[UIPageControl alloc] init];
    CGPoint s = self.view.center;
    s.y = s.y* 9/5;
    _pageControl.center = s;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = _imageArray.count;
    _pageControl.pageIndicatorTintColor = [UIColor brownColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    _pageControl.userInteractionEnabled = NO;
//    [self.view addSubview:_pageControl];
}

#pragma mark - ScrollView代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    _pageControl.currentPage = index;
    if (index == _imageArray.count-1) {
        _pageControl.hidden = YES;
    }
    else{
        _pageControl.hidden = NO;
    }
}
#pragma mark - UIButton 方法
-(void)startApp
{
    _callback();
}
@end

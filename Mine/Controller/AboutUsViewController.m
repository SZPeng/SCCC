//
//  AboutUsViewController.m
//  SCCBBS
//
//  Created by co188 on 16/11/10.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "AboutUsViewController.h"
#import "SCCHeader.h"
@interface AboutUsViewController ()
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIView *_headView;
}
@end

@implementation AboutUsViewController
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    _headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:_headView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"关于我们";
    _label.textAlignment = NSTextAlignmentCenter;
    
    _label.font = [UIFont systemFontOfSize:18];
    _label.textColor = [UIColor whiteColor];
    _label.center = CGPointMake(_headView.center.x, _label.center.y);
    [_headView addSubview:_label];
    
    _leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 0, 40, 44)];
    _leftBtn.imageEdgeInsets=UIEdgeInsetsMake(10, 6, 9, 15);
    [_leftBtn setImage:[UIImage imageNamed:@"back"]  forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.center = CGPointMake(_leftBtn.center.x, _label.center.y);
    [_headView addSubview:_leftBtn];
    [self createUI];
}

-(void)createUI
{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 105, 75, 75)];
    imgView.image = [UIImage imageNamed:@"icon"];
    imgView.center = CGPointMake(_headView.center.x, imgView.center.y);
    [self.view addSubview:imgView];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame) + 15, WIN_WIDTH, 20)];
    nameLab.text = @"土木在线";
    nameLab.textColor = A333;
    nameLab.font = [UIFont systemFontOfSize:18];
    nameLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLab];
    
    UILabel *banLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nameLab.frame) + 6, WIN_WIDTH, 20)];
    banLab.textAlignment = NSTextAlignmentCenter;
    banLab.text = @"1.0.6版";
    banLab.textColor = A666;
    banLab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:banLab];
    
    UILabel *webLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(banLab.frame) + 33, WIN_WIDTH, 20)];
    webLab.textAlignment = NSTextAlignmentCenter;
    webLab.textColor = A333;
    [self.view addSubview:webLab];
    
    NSString *str = @"网址: www.co188.com";
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange rangel = [[textColor string] rangeOfString:[str substringFromIndex:7]];
    [textColor addAttribute:NSForegroundColorAttributeName value:A008cee range:rangel];
    webLab.font = [UIFont systemFontOfSize:18];
//    [webLab setAttributedText:textColor];
    webLab.text = str;
    webLab.textColor = A666;
    UILabel *hotLine = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(webLab.frame) + 15, WIN_WIDTH, 20)];
    hotLine.font = [UIFont systemFontOfSize:18];
    hotLine.textAlignment = NSTextAlignmentCenter;
    hotLine.textColor = A666;
    hotLine.text = @"客服: 0519-68887188";
    [self.view addSubview:hotLine];
    
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, WIN_HEIGHT - 60, WIN_WIDTH, 20)];
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.text = @"常州易宝网络服务有限公司版权所有";
    timeLab.textColor = A999;
    timeLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:timeLab];
    UILabel *commentLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLab.frame) + 4, WIN_WIDTH, 20)];
    commentLab.textAlignment = NSTextAlignmentCenter;
    commentLab.textColor = A999;
    commentLab.text = @"Copyright©2000-2016 co188.com ALL Rights Reserved.";
    commentLab.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:commentLab];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

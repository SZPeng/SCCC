//
//  BackMViewController.m
//  SCCBBS
//
//  Created by co188 on 16/10/28.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "BackMViewController.h"
#import "SCCHeader.h"
#import "ZhuCeViewController.h"
#import "FindBackMViewController.h"
@interface BackMViewController ()<UITextFieldDelegate>
{
    UILabel *_label;
    UIButton *_leftBtn;
}
@end

@implementation BackMViewController

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"找回密码";
    _label.textAlignment = NSTextAlignmentCenter;
    
    _label.font = [UIFont systemFontOfSize:18];//[UIFont fontWithName:@"STHeitiTC-Light" size:20];
    _label.textColor = [UIColor whiteColor];
    _label.center = CGPointMake(headView.center.x, _label.center.y);
    [headView addSubview:_label];
    
    _leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 0, 40, 44)];
    _leftBtn.imageEdgeInsets=UIEdgeInsetsMake(10, 6, 9, 15);
    [_leftBtn setImage:[UIImage imageNamed:@"back"]  forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.center = CGPointMake(_leftBtn.center.x, _label.center.y);
    [headView addSubview:_leftBtn];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 63.5, WIN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    [headView addSubview:line];
    
    UILabel *fangShi = [[UILabel alloc]initWithFrame:CGRectMake(16, 64 + 28, WIN_WIDTH - 32, 20)];
    fangShi.font = [UIFont systemFontOfSize:14];
    fangShi.textColor = [UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.00f];
    fangShi.text = @"请选择找回方式:";
    [self.view addSubview:fangShi];
    
    UIButton *phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(fangShi.frame) + 28, WIN_WIDTH - 88,50)];
    phoneBtn.layer.borderWidth = 0.5;
    phoneBtn.layer.borderColor = TMHEADCOLO.CGColor;
    phoneBtn.layer.cornerRadius = 3;
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [phoneBtn addTarget:self action:@selector(phoneGetMi) forControlEvents:UIControlEventTouchUpInside];
    [phoneBtn setTitle:@"通过手机找回密码" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:TMHEADCOLO forState:UIControlStateNormal];
    [self.view addSubview:phoneBtn];
    
    UIButton *youXBtn = [[UIButton alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(phoneBtn.frame) + 38, WIN_WIDTH - 88,50)];
    youXBtn.layer.borderWidth = 0.5;
    youXBtn.layer.borderColor = TMHEADCOLO.CGColor;
    youXBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    youXBtn.layer.cornerRadius = 3;
    [youXBtn addTarget:self action:@selector(youXGetMi) forControlEvents:UIControlEventTouchUpInside];
    [youXBtn setTitle:@"通过邮箱找回密码" forState:UIControlStateNormal];
    [youXBtn setTitleColor:TMHEADCOLO forState:UIControlStateNormal];
    [self.view addSubview:youXBtn];
    
}
-(void)phoneGetMi
{
    ZhuCeViewController *vc = [ZhuCeViewController new];
    vc.isZhuChe = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)youXGetMi
{
    FindBackMViewController *vc = [FindBackMViewController new];
    vc.isEmail = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

//
//  SendEmailViewController.m
//  SCCBBS
//
//  Created by co188 on 16/10/28.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "SendEmailViewController.h"
#import "SCCHeader.h"
@interface SendEmailViewController ()
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIImageView *_PhoneNum;
    UITextField *_PhoneT;
    UIButton *_EnterBtn;
}

@end

@implementation SendEmailViewController

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = NO;
}

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
    
    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 64 + 29, WIN_WIDTH - 30, 20)];
    firstLabel.text = @"我们已将找回密码通过邮件下发至你的邮箱:";
    firstLabel.textColor = [UIColor blackColor];
    firstLabel.font = [UIFont systemFontOfSize:14];
    firstLabel.numberOfLines = 0;
    [self.view addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(firstLabel.frame) + 25, WIN_WIDTH - 30, 20)];
    secondLabel.text = _emailString;
    secondLabel.textColor = [UIColor blackColor];
    secondLabel.font = [UIFont systemFontOfSize:15];
    secondLabel.numberOfLines = 0;
    secondLabel.textColor = TMHEADCOLO;
    [self.view addSubview:secondLabel];
    
    CGSize noteSize = [self sizeWithText:@"请您登录您的邮箱查收，并按邮件提示进行操作。" font:[UIFont systemFontOfSize:15] maxW:WIN_WIDTH - 30];
    UILabel *thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(secondLabel.frame) + 25, WIN_WIDTH - 30, noteSize.height + 3)];
    thirdLabel.text = @"请您登录您的邮箱查收，并按邮件提示进行操作。";
    thirdLabel.textColor = [UIColor blackColor];
    thirdLabel.font = [UIFont systemFontOfSize:15];
    thirdLabel.numberOfLines = 0;
    thirdLabel.textColor = [UIColor blackColor];
    [self.view addSubview:thirdLabel];
    
    _EnterBtn = [[UIButton alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(thirdLabel.frame) + 49, WIN_WIDTH - 88, 50)];
    //    _EnterBtn.backgroundColor = UUT;
    [_EnterBtn setTitle:@"确定" forState:UIControlStateNormal];
    _EnterBtn.layer.cornerRadius = 3;
    _EnterBtn.backgroundColor = TMHEADCOLO;
    [_EnterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _EnterBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17];
    [_EnterBtn addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_EnterBtn];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)enterAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

//
//  ZhuCeViewController.m
//  SCCBBS
//
//  Created by co188 on 16/10/27.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "ZhuCeViewController.h"
#import "SCCHeader.h"
#import "tools.h"
#import "MakeSureViewController.h"
#import "FindBackMViewController.h"
#import "SCCAFnetTool.h"
#import <MBProgressHUD.h>
@interface ZhuCeViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIImageView *_PhoneNum;
    UITextField *_PhoneT;
    UILabel *_Line;
    UIImageView *_Mima;
    UITextField *_MimaT;
    UIButton *_EnterBtn;
    UIButton *_HQMMBtn;
    NSInteger _timeOut;
    NSTimer *_timer;
    BOOL _isTime;
    NSString *_token;
    NSString *_token2;
}
@end

@implementation ZhuCeViewController

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
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 18, 200, 40)];
    _label.backgroundColor = [UIColor clearColor];
    if(_isZhuChe == 1){
        _label.text = @"找回密码";
    }else{
       _label.text = @"注册";
    }
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
    
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(44, 131, WIN_WIDTH -88, 50)];
    firstView.layer.borderWidth = 0.5;
    firstView.layer.borderColor = TMLINECOLO.CGColor;
    firstView.layer.cornerRadius = 3;
    [self.view addSubview:firstView];
    
    _PhoneNum = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
//    _PhoneNum.backgroundColor = [UIColor redColor];
    _PhoneNum.image = [UIImage imageNamed:@"user"];
    [firstView addSubview:_PhoneNum];
    
    _PhoneT = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, firstView.frame.size.width - 60 , 30)];
    _PhoneT.placeholder = @"请输入手机号码";
    _PhoneT.textAlignment = NSTextAlignmentLeft;
    _PhoneT.textColor = TTG3;
    _PhoneT.tag = 10;
    _PhoneT.keyboardType = UIKeyboardTypeNumberPad;
    _PhoneT.delegate = self;
    _PhoneT.returnKeyType =  UIReturnKeyDone;
    _PhoneT.font = [UIFont systemFontOfSize:15];
    [firstView addSubview:_PhoneT];
    
    _Line = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_PhoneNum.frame) + 5, WIN_WIDTH - 40, 1)];
    _Line.backgroundColor = TTG2;
    //    [self.view addSubview:_Line];
    
    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(firstView.frame) + 18, WIN_WIDTH -88, 50)];
    secondView.layer.borderWidth = 0.5;
    secondView.layer.borderColor = TMLINECOLO.CGColor;
    secondView.layer.cornerRadius = 3;
    [self.view addSubview:secondView];
    
    _Mima = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
//    _Mima.backgroundColor = [UIColor redColor];
    _Mima.image = [UIImage imageNamed:@"identifying-code"];
   
    [secondView addSubview:_Mima];
    
    _MimaT = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, firstView.frame.size.width - 60 , 30)];
    _MimaT.placeholder = @"请输入验证码";
    _MimaT.textAlignment = NSTextAlignmentLeft;
    _MimaT.textColor = TTG3;
//    _MimaT.secureTextEntry = YES;
    _MimaT.keyboardType = UIKeyboardTypeNumberPad;
    _MimaT.delegate = self;
    _MimaT.returnKeyType =  UIReturnKeyDone;
    _MimaT.font = [UIFont systemFontOfSize:15];
    [secondView addSubview:_MimaT];
    
    _HQMMBtn = [[UIButton alloc]initWithFrame:CGRectMake(secondView.frame.size.width - 80, 10, 80, 30)];
    _HQMMBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_HQMMBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_HQMMBtn setTitleColor:TMHEADCOLO forState:UIControlStateNormal];
    [_HQMMBtn addTarget:self action:@selector(HuoQuAction) forControlEvents:UIControlEventTouchUpInside];
    [secondView addSubview:_HQMMBtn];
    
    _EnterBtn = [[UIButton alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(secondView.frame) + 35, WIN_WIDTH - 88, 50)];
    _EnterBtn.backgroundColor = [UIColor colorWithRed:0.00f green:0.55f blue:0.93f alpha:1.00f];
    _EnterBtn.layer.cornerRadius = 3;
    [_EnterBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_EnterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _EnterBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_EnterBtn addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_EnterBtn];
}

//获取验证码
-(void)HuoQuAction {
    
    if (_PhoneT.text.length == 11) {
        _timeOut = 30;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(time) userInfo:nil repeats:NO];
        _HQMMBtn.userInteractionEnabled = NO;
        _HQMMBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_HQMMBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _isTime = YES;
        [NSTimer scheduledTimerWithTimeInterval:5*60.0 target:self selector:@selector(endTime) userInfo:nil repeats:NO];
        NSDictionary *dic = @{@"mobile":_PhoneT.text,@"version":VERSION,@"charset":@"utf-8"};
        //初始化Manager
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDAnimationFade;
        if(_isZhuChe == 1){
            NSString *urlString = [NSString stringWithFormat:@"%@/member/password/sendMobile",API_HOST];
            NSLog(@"%@",urlString);
            SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
            [afTool postMessage:urlString useDictonary:dic progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                NSDictionary *dic = responseObject[@"data"];
                _token = dic[@"token"];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];

        }else{
            NSString *urlString = [NSString stringWithFormat:@"%@/member/register/sendMobile",API_HOST];
            SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
            [afTool postMessage:urlString useDictonary:dic progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if([code isEqualToString:@"0"]){
                    NSDictionary *dic = responseObject[@"data"];
                    _token = dic[@"token"];
                }else{
//                    [tools alert:responseObject[@"msg"]];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:responseObject[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }
        
    } else {
        
        [tools alert:@"请输入正确的手机号"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0)
{
    [self backClick];
}
- (void)timerFired
{
    [_HQMMBtn setTitle:[NSString stringWithFormat:@"(%lds)",--_timeOut] forState:0];
    _HQMMBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13];
    [_HQMMBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    if (_timeOut==0) {
        [_timer invalidate];
         _HQMMBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:12];
        [_HQMMBtn setTitle:@"获取验证码" forState:0];
        _HQMMBtn.userInteractionEnabled = YES;
        [_HQMMBtn setTitleColor:TMHEADCOLO forState:UIControlStateNormal];
    }
}

- (void)time
{
    [_HQMMBtn setTitleColor:TMHEADCOLO forState:UIControlStateNormal];
    _HQMMBtn.userInteractionEnabled = YES;
    
}

-(void)endTime
{
    _isTime = NO;
}

-(void)enterAction
{
    if(!(_PhoneT.text.length  > 0)){
        [tools alert:@"手机号不能为空"];
    }else{
        if(!(_MimaT.text.length > 0)){
            [tools alert:@"验证码不能为空"];
        }else{
            if(_isZhuChe == 1){
                MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode=MBProgressHUDAnimationFade;
                NSString *urlString = [NSString stringWithFormat:@"%@/member/password/vmobile",API_HOST];
                SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
                NSDictionary *dic = @{@"mobile":_PhoneT.text,@"token":_token,@"vcode":_MimaT.text,@"version":VERSION};
                [afTool postMessage:urlString useDictonary:dic progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                    NSLog(@"%@",responseObject);
                    NSDictionary *dic = responseObject[@"data"];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    FindBackMViewController *vc = [FindBackMViewController new];
                    vc.token = dic[@"token"];
                    vc.phoneNum = _PhoneT.text;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"%@",error);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
                
            }else{
                MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode=MBProgressHUDAnimationFade;
                NSDictionary *dic = @{@"mobile":_PhoneT.text, @"token":_token,@"vcode":_MimaT.text,@"version":VERSION};
                //初始化Manager
                NSString *urlString = [NSString stringWithFormat:@"%@/member/register/vmobile",API_HOST];
                SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
                [afTool postMessage:urlString useDictonary:dic progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                    NSLog(@"%@",responseObject);
                    NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                    if([code isEqualToString:@"0"]){
                        NSDictionary *dic = responseObject[@"data"];
                        _token2 = dic[@"token"];
                        
                        MakeSureViewController *vc = [MakeSureViewController new];
                        vc.token = _token2;
                        vc.phoneNum = _PhoneT.text;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        [tools alert:responseObject[@"msg"]];
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                   
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"%@",error);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
            }
        }
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_PhoneT resignFirstResponder];
    [_MimaT resignFirstResponder];
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

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent ;
}

@end

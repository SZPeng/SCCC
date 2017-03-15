//
//  FindBackMViewController.m
//  SCCBBS
//
//  Created by co188 on 16/10/28.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "FindBackMViewController.h"
#import "SCCHeader.h"
#import "SendEmailViewController.h"
#import "tools.h"
#import "SCCAFnetTool.h"
#import <MBProgressHUD.h>
@interface FindBackMViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIImageView *_PhoneNum;
    UITextField *_PhoneT;
    UIButton *_EnterBtn;
}
@end

@implementation FindBackMViewController

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
    
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(44, 131, WIN_WIDTH -88, 50)];
    firstView.layer.borderWidth = 0.5;
    firstView.layer.borderColor = TMLINECOLO.CGColor;
    firstView.layer.cornerRadius = 3;
    [self.view addSubview:firstView];
    
    _PhoneNum = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
//    _PhoneNum.backgroundColor = [UIColor redColor];
    [firstView addSubview:_PhoneNum];
    _PhoneT = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, firstView.frame.size.width - 60 , 30)];
    
    if(_isEmail == 1){
        _PhoneT.placeholder = @"请输入你的注册邮箱";
        _PhoneNum.frame = CGRectMake(15, 18, 20, 14);
        _PhoneNum.image = [UIImage imageNamed:@"email"];
        
    }else{
        _PhoneT.placeholder = @"请设置密码";
        _PhoneNum.image = [UIImage imageNamed:@"PASSWORD"];
//        _PhoneT.keyboardType = UIKeyboardTypeNumberPad;
    }
    _PhoneT.textAlignment = NSTextAlignmentLeft;
    _PhoneT.textColor = TTG3;
    _PhoneT.tag = 10;
    
    _PhoneT.delegate = self;
    _PhoneT.returnKeyType =  UIReturnKeyDone;
    _PhoneT.font = [UIFont fontWithName:@"STHeitiTC-Light" size:15];
    [firstView addSubview:_PhoneT];
    
    _EnterBtn = [[UIButton alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(firstView.frame) + 35, WIN_WIDTH - 88, 50)];
    //    _EnterBtn.backgroundColor = UUT;
    [_EnterBtn setTitle:@"完成" forState:UIControlStateNormal];
    _EnterBtn.layer.cornerRadius = 3;
    _EnterBtn.backgroundColor = TMHEADCOLO;
    [_EnterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _EnterBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17];
    [_EnterBtn addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_EnterBtn];
    
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_PhoneT resignFirstResponder];
}
-(void)enterAction
{
    if(_isEmail == 1){
        if(!(_PhoneT.text.length > 0)){
            [tools alert:@"邮箱不能为空"];
        }else{
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode=MBProgressHUDAnimationFade;
            NSString *urlString = [NSString stringWithFormat:@"%@/member/password/sendMail",API_HOST];
            SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
            NSDictionary *dic = @{@"email":_PhoneT.text,@"version":VERSION,@"charset":@"utf-8"};
            NSLog(@"%@",dic);
            [afTool postMessage:urlString useDictonary:dic progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"%@",responseObject);
                NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if([code isEqualToString:@"0"]){
                    SendEmailViewController *vc = [SendEmailViewController new];
                    vc.emailString = _PhoneT.text;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else{
                    [tools alert:responseObject[@"msg"]];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"%@",error);
            }];

        }
        
    }else{
        //密码成功通过手机号找回
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDAnimationFade;
        NSString *urlString = [NSString stringWithFormat:@"%@/member/password/submit",API_HOST];
        SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
        NSDictionary *dic = @{@"mobile":_phoneNum,@"token":_token,@"password":_PhoneT.text,@"version":VERSION,@"charset":@"utf-8"};
        NSLog(@"%@",dic);
        [afTool postMessage:urlString useDictonary:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@",responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if([code isEqualToString:@"0"]){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"设置密码成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];

            }else{
                [tools alert:responseObject[@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@",error);
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

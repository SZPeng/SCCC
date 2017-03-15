//
//  MakeSureViewController.m
//  SCCBBS
//
//  Created by co188 on 16/10/27.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "MakeSureViewController.h"
#import "SCCHeader.h"
#import "tools.h"
#import "SCCAFnetTool.h"
#import <MBProgressHUD.h>
@interface MakeSureViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIImageView *_PhoneNum;
    UITextField *_PhoneT;
    UILabel *_Line;
    UIImageView *_Mima;
    UITextField *_MimaT;
    UIButton *_EnterBtn;
    UIImageView *_NiChen;
    UITextField *_NiChenT;
}
@end

@implementation MakeSureViewController

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

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"注册";
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
    _PhoneNum.image = [UIImage imageNamed:@"PASSWORD"];
    [firstView addSubview:_PhoneNum];
    
    _PhoneT = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, firstView.frame.size.width - 60 , 30)];
    _PhoneT.placeholder = @"请输入密码";
    _PhoneT.textAlignment = NSTextAlignmentLeft;
    _PhoneT.textColor = TTG3;
    _PhoneT.tag = 10;
    _PhoneT.secureTextEntry = YES;
//    _PhoneT.keyboardType = UIKeyboardTypeNumberPad;
    _PhoneT.delegate = self;
    _PhoneT.returnKeyType =  UIReturnKeyDone;
    _PhoneT.font = [UIFont systemFontOfSize:15];
    [firstView addSubview:_PhoneT];
    
    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(firstView.frame) + 18, WIN_WIDTH -88, 50)];
    secondView.layer.borderWidth = 0.5;
    secondView.layer.borderColor = TMLINECOLO.CGColor;
    secondView.layer.cornerRadius = 3;
    [self.view addSubview:secondView];
    
    _Mima = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
    _Mima.image = [UIImage imageNamed:@"PasswordVerification"];
    [secondView addSubview:_Mima];
    
    _MimaT = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, firstView.frame.size.width - 60 , 30)];
    _MimaT.placeholder = @"请再次输入密码";
    _MimaT.textAlignment = NSTextAlignmentLeft;
    _MimaT.textColor = TTG3;
    _MimaT.secureTextEntry = YES;
    _MimaT.delegate = self;
    _MimaT.returnKeyType =  UIReturnKeyDone;
    _MimaT.font = [UIFont systemFontOfSize:15];
    [secondView addSubview:_MimaT];

    UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(secondView.frame) + 18, WIN_WIDTH -88, 50)];
    thirdView.layer.borderWidth = 0.5;
    thirdView.layer.borderColor = TMLINECOLO.CGColor;
    thirdView.layer.cornerRadius = 3;
//    [self.view addSubview:thirdView];
    _NiChen = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
    _NiChen.image = [UIImage imageNamed:@"nickname"];
    [thirdView addSubview:_NiChen];
    
    _NiChenT = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, thirdView.frame.size.width - 60 , 30)];
    _NiChenT.placeholder = @"请输入昵称";
    _NiChenT.textAlignment = NSTextAlignmentLeft;
    _NiChenT.textColor = TTG3;
    //密码格式的输入
//    _NiChenT.secureTextEntry = YES;
    _NiChenT.delegate = self;
    _NiChenT.returnKeyType =  UIReturnKeyDone;
    _NiChenT.font = [UIFont fontWithName:@"STHeitiTC-Light" size:15];
//    [thirdView addSubview:_NiChenT];
    
    CGSize textSize = [self sizeWithText:@"昵称由4-14字符组成，由小写英文、数字、汉字组成，且不允许纯数字，建议使用汉字昵称" font:[UIFont systemFontOfSize:13] maxW:WIN_WIDTH - 88];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(thirdView.frame) + 13, WIN_WIDTH - 88, textSize.height + 10)];
    label.numberOfLines = 0;
    label.text = @"昵称由4-14字符组成，由小写英文、数字、汉字组成，且不允许纯数字，建议使用汉字昵称";
    label.textColor = [UIColor colorWithRed:0.77f green:0.77f blue:0.77f alpha:1.00f];
    label.font = [UIFont systemFontOfSize:13];
//    [self.view addSubview:label];
    _EnterBtn = [[UIButton alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(secondView.frame) + 35, WIN_WIDTH - 88, 50)];
    //    _EnterBtn.backgroundColor = UUT;
    [_EnterBtn setTitle:@"完成注册" forState:UIControlStateNormal];
    _EnterBtn.layer.cornerRadius = 3;
    _EnterBtn.backgroundColor = TMHEADCOLO;
    [_EnterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _EnterBtn.titleLabel.font = [UIFont systemFontOfSize:17];
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

-(void)enterAction
{
    if(!(_PhoneT.text.length  > 0)){
        [tools alert:@"密码不能为空"];
    }else{
        if(!(_MimaT.text.length > 0)){
            [tools alert:@"请再次输入密码"];
        }else{
            if([_MimaT.text isEqualToString:_PhoneT.text]){
                MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode=MBProgressHUDAnimationFade;
                NSString *str = _NiChenT.text;
                str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = @{@"mobile":_phoneNum,@"token":_token, @"password":_MimaT.text,@"nickname":@"0",@"version":VERSION,@"charset":@"utf-8"};
                //初始化Manager
                NSString *urlString = [NSString stringWithFormat:@"%@/member/register/submit",API_HOST];
                SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
                [afTool postMessage:urlString useDictonary:dic progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSLog(@"%@",responseObject);
                    NSString *string = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                    if([string isEqualToString:@"0"]){
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                    }else{
                        [tools alert:responseObject[@"msg"]];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"%@",error);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
                
            }else{
                [tools alert:@"两次密码不一致"];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0)
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_PhoneT resignFirstResponder];
    [_MimaT resignFirstResponder];
    [_NiChenT resignFirstResponder];
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

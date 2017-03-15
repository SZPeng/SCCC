//
//  SendPrivateMController.m
//  SCCBBS
//
//  Created by co188 on 16/11/15.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "SendPrivateMController.h"
#import "SCCHeader.h"
#import "SCCAFnetTool.h"
#import "TextView.h"
#import <MBProgressHUD.h>
#import "MessageTool.h"
#import <UIButton+WebCache.h>
#import "tools.h"
@interface SendPrivateMController ()<UITextViewDelegate>
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIView *_headView;
    TextView *_textView;
    UIView *_bottomView;
    UIButton *_HQMMBtn;
    UITextField *_textField;
    UITextField *_nameTextF;
    
    NSInteger _timeOut;
    NSTimer *_timer;
    BOOL _isTime;
    NSString *_token;
}
@end

@implementation SendPrivateMController

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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    
    _headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:_headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"发私信";
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
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 53, 0, 45, 44)];
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    rightBtn.center = CGPointMake(rightBtn.center.x, _label.center.y);
    [_headView addSubview:rightBtn];

    [self createUI];
}

-(void)createUI
{
    UILabel *memberLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 64, WIN_WIDTH - 40, 50)];
    if([_isQun isEqualToString:@"1"]){
        memberLab.frame = CGRectMake(20, 64, 60, 50);
        memberLab.text = @"收件人:";
        _nameTextF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(memberLab.frame) + 3, 64, WIN_WIDTH - CGRectGetMaxX(memberLab.frame) - 23, 50)];
        _nameTextF.textColor = [UIColor grayColor];
        _nameTextF.placeholder = @"请输入用户名";
        _nameTextF.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:_nameTextF];
    }else{
         memberLab.text = [NSString stringWithFormat:@"收件人: %@",_userName];
    }
   
    memberLab.textColor = [UIColor grayColor];
    memberLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:memberLab];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(memberLab.frame), WIN_WIDTH - 40, 1)];
    line.backgroundColor = Ad6d6d6;
    [self.view addSubview:line];
    
    _textView = [[TextView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(line.frame), WIN_WIDTH - 40, WIN_HEIGHT-64-50)];
//    _textView.backgroundColor = [UIColor colorWithRed:0.96f green:0.97f blue:0.97f alpha:1.00f];
//    _textView.delegate = self;
    _textView.layer.borderColor = [UIColor whiteColor].CGColor;
    _textView.placeHolder = @"请输入私信内容";
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.textColor = [UIColor colorWithRed:0.67f green:0.67f blue:0.68f alpha:1.00f];
    _textView.returnKeyType =  UIReturnKeyDone;
    [self.view addSubview:_textView];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, WIN_HEIGHT - 50, WIN_WIDTH, 50)];
    [self.view addSubview:_bottomView];
    
    UILabel *labLine = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, WIN_WIDTH - 40, 1)];
    labLine.backgroundColor = Ad6d6d6;
    [_bottomView addSubview:labLine];
    
    UILabel *labLastLine = [[UILabel alloc]initWithFrame:CGRectMake(20, 45, WIN_WIDTH - 40, 1)];
    labLastLine.backgroundColor = Ad6d6d6;
    [_bottomView addSubview:labLastLine];
    
    _HQMMBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 100, 11, 80, 34)];
    _HQMMBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_HQMMBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_HQMMBtn setTitleColor:TMHEADCOLO forState:UIControlStateNormal];
    [_HQMMBtn addTarget:self action:@selector(HuoQuAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_HQMMBtn];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 11, WIN_WIDTH - 100, 34)];
    _textField.placeholder = @"请输入验证码";
    _textField.textColor = A333;
    _textField.font = [UIFont systemFontOfSize:13];
    [_bottomView addSubview:_textField];
    [_textView becomeFirstResponder];

}

-(void)HuoQuAction
{
    _timeOut = 30;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
//    [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(time) userInfo:nil repeats:NO];
//    
//    _HQMMBtn.userInteractionEnabled = NO;
//    _HQMMBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    [_HQMMBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    _isTime = YES;
//    [NSTimer scheduledTimerWithTimeInterval:5*60.0 target:self selector:@selector(endTime) userInfo:nil repeats:NO];
    NSString *urlString = [NSString stringWithFormat:@"%@/member/captcha/init",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    //初始化Manager
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    [afTool postMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dataDic = responseObject[@"data"];
            _token = dataDic[@"token"];
            [_HQMMBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:dataDic[@"url"]] forState:UIControlStateNormal];
            [_HQMMBtn setTitle:@"" forState:UIControlStateNormal];
        }else if([code isEqualToString:@"500"]){
            [tools alert:responseObject[@"msg"]];
        }else if([code isEqualToString:@"401"]){
            [tools alert:responseObject[@"msg"]];
        }

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}
- (void)timerFired
{
    [_HQMMBtn setTitle:[NSString stringWithFormat:@"(%lds)",--_timeOut] forState:0];
    _HQMMBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_HQMMBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    if (_timeOut==0) {
        [_timer invalidate];
        _HQMMBtn.titleLabel.font = [UIFont systemFontOfSize:12];
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

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.size.height;
    
    _textView.frame = CGRectMake(20, CGRectGetMinY(_textView.frame), WIN_WIDTH - 40, WIN_HEIGHT - CGRectGetMinY(_textView.frame) - 50 - keyboardTop);
    _bottomView.frame = CGRectMake(0, WIN_HEIGHT - 50 - keyboardTop, WIN_WIDTH, 50);
}

#pragma mark-发送消息
-(void)sendMessage
{
    if([_isQun isEqualToString:@"1"]){
        if(_nameTextF.text.length > 0){
            if(_textView.text.length > 0){
                if(_textField.text.length > 0){
                    _userName = _nameTextF.text;
                    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode=MBProgressHUDAnimationFade;
                    NSString *urlString = [NSString stringWithFormat:@"%@/protected/msg/sendMsg",API_HOST];
                    NSLog(@"%@",urlString);
                    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
                    NSMutableDictionary *messageDic = [MessageTool getMessage];
                    NSString *str3 = [_userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSLog(@"%@",str3);
                    [messageDic setObject:str3 forKey:@"toUsername"];
                    NSString *textStr = [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [messageDic setObject:textStr forKey:@"message"];
                    
                    [messageDic setObject:_textField.text forKey:@"vcode"];
                    [messageDic setObject:_token forKey:@"token"];
                    [messageDic setObject:@"utf-8" forKey:@"charset"];
                    [afTool postMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                        NSLog(@"%@",responseObject);
                        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                        if([code isEqualToString:@"0"]){
                            NSDictionary *dataDic = responseObject[@"data"];
                            //                    [tools alert:responseObject[@"msg"]];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"successSend" object:nil];
                            [self backClick];
                        }else if([code isEqualToString:@"500"]){
                            [tools alert:responseObject[@"msg"]];
                        }else if([code isEqualToString:@"401"]){
                            [tools alert:responseObject[@"msg"]];
                        }else{
                            [tools alert:responseObject[@"msg"]];
                        }
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@",error);
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }];
                    
                    
                }else{
                    [tools alert:@"请输入验证码"];
                }
            }else{
                [tools alert:@"请输入消息"];
            }

        }else{
            [tools alert:@"请输入收件人"];
        }
    }else{
        if(_textView.text.length > 0){
            if(_textField.text.length > 0){
                MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode=MBProgressHUDAnimationFade;
                NSString *urlString = [NSString stringWithFormat:@"%@/protected/msg/sendMsg",API_HOST];
                NSLog(@"%@",urlString);
                SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
                NSMutableDictionary *messageDic = [MessageTool getMessage];
                NSString *str3 = [_userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"%@",str3);
                [messageDic setObject:str3 forKey:@"toUsername"];
                NSString *textStr = [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [messageDic setObject:textStr forKey:@"message"];
                [messageDic setObject:_textField.text forKey:@"vcode"];
                [messageDic setObject:_token forKey:@"token"];
                [messageDic setObject:@"UTF-8" forKey:@"charset"];
                [afTool postMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                    NSLog(@"%@",responseObject);
                    NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                    if([code isEqualToString:@"0"]){
                        NSDictionary *dataDic = responseObject[@"data"];
                        //                    [tools alert:responseObject[@"msg"]];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"successSend" object:nil];
                        [self backClick];
                    }else if([code isEqualToString:@"500"]){
                        [tools alert:responseObject[@"msg"]];
                    }else if([code isEqualToString:@"401"]){
                        [tools alert:responseObject[@"msg"]];
                    }else{
                        [tools alert:responseObject[@"msg"]];
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
                    NSLog(@"%@",error);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
                
                
            }else{
                [tools alert:@"请输入验证码"];
            }
        }else{
            [tools alert:@"请输入消息"];
        }

    }
    
}

-(void)backClick
{
//    [_textView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
@end

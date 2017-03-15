//
//  JuBaoViewController.m
//  SCCBBS
//
//  Created by co188 on 16/12/8.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "JuBaoViewController.h"
#import "SCCHeader.h"
#import "SCCAFnetTool.h"
#import "TextView.h"
#import <MBProgressHUD.h>
#import "MessageTool.h"
#import <UIButton+WebCache.h>
#import "tools.h"
@interface JuBaoViewController ()<UIAlertViewDelegate>
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIView *_headView;
    TextView *_textView;
    UIView *_bottomView;
    UIButton *_HQMMBtn;
    
    NSInteger _timeOut;
    NSTimer *_timer;
    BOOL _isTime;
    NSString *_token;
}

@end

@implementation JuBaoViewController
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    
    _headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:_headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"举报";
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

    // Do any additional setup after loading the view.
}

-(void)createUI
{
    _textView = [[TextView alloc]initWithFrame:CGRectMake(20, 79, WIN_WIDTH - 40, WIN_HEIGHT-64-50)];
    //    _textView.backgroundColor = [UIColor colorWithRed:0.96f green:0.97f blue:0.97f alpha:1.00f];
    //    _textView.delegate = self;
    _textView.layer.borderColor = [UIColor whiteColor].CGColor;
    _textView.placeHolder = @"请输入您要举报的内容";
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.textColor = [UIColor colorWithRed:0.67f green:0.67f blue:0.68f alpha:1.00f];
    _textView.returnKeyType =  UIReturnKeyNext;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    [_textView becomeFirstResponder];
    [self.view addSubview:_textView];
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
}

-(void)sendMessage
{
    if(_textView.text.length > 0){
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDAnimationFade;
        NSString *urlString = @"https://app.co188.com/bbs/report.php";
        NSLog(@"%@",urlString);
        SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
        NSMutableDictionary *messageDic = [MessageTool getMessage];
        NSString *textStr = [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if([_juBaoLou isEqualToString:@"1"]){
            [messageDic setObject:_fid forKey:@"fid"];
            [messageDic setObject:_tid forKey:@"tid"];
            [messageDic setObject:@"" forKey:@"pid"];
        }else{
            [messageDic setObject:_fid forKey:@"fid"];
            [messageDic setObject:@"" forKey:@"tid"];
            [messageDic setObject:_tid forKey:@"pid"];
        }
        
        [messageDic setObject:textStr forKey:@"message"];
        [afTool postMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull  task, id _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@",responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if([code isEqualToString:@"0"]){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"发送成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }else if([code isEqualToString:@"500"]){
                [tools alert:responseObject[@"msg"]];
            }else if([code isEqualToString:@"401"]){
                [tools alert:responseObject[@"msg"]];
            }else{
                [tools alert:responseObject[@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else{
        [tools alert:@"请输入举报内容"];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0)
{
    [_textView resignFirstResponder];
    [self backClick];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

//
//  RewardViewController.m
//  SCCBBS
//
//  Created by co188 on 16/11/30.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "RewardViewController.h"
#import "SCCHeader.h"
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "SCCAFnetTool.h"
#import "tools.h"
#import "MessageTool.h"

@interface RewardViewController ()<UIAlertViewDelegate>
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIScrollView *_backScroll;
    UIButton *_tuMuBtn;
    UIButton *_gongCBtn;
    UILabel *_balanceLabel;
    UIButton *_btn;
    
    NSString *_avatar;
    NSString *_credit1;
    NSString *_credit2;
    NSString *_displayname;
    NSString *_fTid;
    NSString *_reward;
    
    UIButton *_sureBtn;
    UIButton *_payBtn;
}
@end

@implementation RewardViewController

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

-(void)viewWillAppear:(BOOL)animated
{
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
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"打赏";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:18];
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
    [self prepareData];
    
}

-(void)prepareData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/member/getUserReward",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:_tid forKey:@"tid"];
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",responseObject);
        NSString *codeStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([codeStr isEqualToString:@"0"]){
            NSDictionary *dic = responseObject[@"data"];
            _avatar = dic[@"avatar"];
            _credit1 = [NSString stringWithFormat:@"%@",dic[@"credit1"]];
            _credit2 = [NSString stringWithFormat:@"%@",dic[@"credit2"]];
            _displayname = [NSString stringWithFormat:@"%@",dic[@"displayname"]];
            _fTid = [NSString stringWithFormat:@"%@",dic[@"tid"]];
            _reward = [NSString stringWithFormat:@"%@",dic[@"reward"]];
            [self createUI];
        }else{
            [tools alert:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
-(void)createUI
{
    _backScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64 - 50)];
    [self.view addSubview:_backScroll];
    
    UIImageView *headBackImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 155)];
    headBackImg.image = [UIImage imageNamed:@"tuppian"];
    [_backScroll addSubview:headBackImg];
    
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2 - 42.5, CGRectGetMaxY(headBackImg.frame) - 42.5, 85, 85)];
//    headImg.backgroundColor = [UIColor redColor];
    [headImg sd_setImageWithURL:[NSURL URLWithString:_avatar]];
    headImg.layer.cornerRadius = 42.5;
    headImg.contentMode = UIViewContentModeScaleToFill;
    headImg.clipsToBounds = YES;
    [_backScroll addSubview:headImg];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headImg.frame) + 13, WIN_WIDTH, 20)];
    nameLab.text = _displayname;
    nameLab.font = [UIFont systemFontOfSize:18];
    nameLab.textColor = A333;
    nameLab.textAlignment = NSTextAlignmentCenter;
    [_backScroll addSubview:nameLab];
    
    CGSize rewardSize = [self sizeWithText:@"请选择打赏方式" font:[UIFont systemFontOfSize:15]];
    CGFloat width = (WIN_WIDTH - 72 - rewardSize.width)/2;
    UILabel *leftLine = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(nameLab.frame) + 35, width, 0.5)];
    leftLine.backgroundColor = A999999;
    [_backScroll addSubview:leftLine];
    
    UILabel *rewardLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLine.frame), CGRectGetMaxY(nameLab.frame) + 25, rewardSize.width + 48, 20)];
    rewardLab.textAlignment = NSTextAlignmentCenter;
    rewardLab.text = @"请选择打赏方式";
    rewardLab.textColor = A999;
    rewardLab.textColor = A999;
    [_backScroll addSubview:rewardLab];
    
    UILabel *rightLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rewardLab.frame), CGRectGetMaxY(nameLab.frame) + 35, width, 0.5)];
    rightLine.backgroundColor = A999999;
    [_backScroll addSubview:rightLine];

    CGFloat btnWidth = (WIN_WIDTH - 75)/3;
    _tuMuBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(rewardLab.frame) + 23, btnWidth, 45)];
    [_tuMuBtn setTitle:@"土木币" forState:UIControlStateNormal];
    [_tuMuBtn setTitleColor:A999 forState:UIControlStateNormal];
    [_tuMuBtn setTitleColor:A008cee forState:UIControlStateSelected];
    _tuMuBtn.layer.borderWidth = 0.5;
    _tuMuBtn.tag = 10;
    _tuMuBtn.selected = YES;
    [_tuMuBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _tuMuBtn.layer.borderColor = A008cee.CGColor;
    _tuMuBtn.layer.cornerRadius = 3;
    [_backScroll addSubview:_tuMuBtn];
    
    _gongCBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_tuMuBtn.frame) + 25.5, CGRectGetMaxY(rewardLab.frame) + 23, btnWidth, 45)];
    [_gongCBtn setTitle:@"工程点" forState:UIControlStateNormal];
    [_gongCBtn setTitleColor:A999 forState:UIControlStateNormal];
    [_gongCBtn setTitleColor:A008cee forState:UIControlStateSelected];
    _gongCBtn.layer.borderWidth = 0.5;
    [_gongCBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _gongCBtn.tag = 100;
    _gongCBtn.layer.borderColor = A999.CGColor;
    _gongCBtn.layer.cornerRadius = 3;
    [_backScroll addSubview:_gongCBtn];
    
    UILabel *leftLine1 = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_tuMuBtn.frame) + 33, width, 0.5)];
    leftLine1.backgroundColor = A999999;
    [_backScroll addSubview:leftLine1];
    
    UILabel *payLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLine1.frame), CGRectGetMaxY(_tuMuBtn.frame) + 23, rewardSize.width + 48, 20)];
    payLab.textAlignment = NSTextAlignmentCenter;
    payLab.text = @"请选择打赏金额";
    payLab.textColor = A999;
    payLab.textColor = A999;
    [_backScroll addSubview:payLab];
    
    UILabel *rightLine1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(payLab.frame), CGRectGetMaxY(_tuMuBtn.frame) + 33, width, 0.5)];
    rightLine1.backgroundColor = A999999;
    [_backScroll addSubview:rightLine1];
    NSArray *array = @[@"1个",@"5个",@"10个",@"15个",@"20个"];
    for(int i = 0;i<5;i++){
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12 + i%3 *(25.5 + btnWidth), CGRectGetMaxY(payLab.frame) + 19 + ((i/3) *55), btnWidth, 45)];
        btn.tag = i + 1;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:A999 forState:UIControlStateNormal];
        [btn setTitleColor:A008cee forState:UIControlStateSelected];
        btn.layer.cornerRadius = 3;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = A999.CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [btn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backScroll addSubview:btn];
        if(i == 4){
            _btn = btn;
        }else if(i == 0){
            btn.selected = YES;
            btn.layer.borderColor = A008cee.CGColor;
            _payBtn = btn;
        }
    }
    _backScroll.contentSize = CGSizeMake(WIN_WIDTH, CGRectGetMaxY(_btn.frame));

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, WIN_HEIGHT - 50, WIN_WIDTH, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UILabel *botLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 0.5)];
    botLine.backgroundColor = Ad6d6d6;
    [bottomView addSubview:botLine];
    
    _balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(19, 0, WIN_WIDTH - 174, 50)];
    _balanceLabel.text = [NSString stringWithFormat:@"土木币余额 : %@",_credit2];
    _balanceLabel.textColor = A333;
    _balanceLabel.font = [UIFont systemFontOfSize:18];
    [bottomView addSubview:_balanceLabel];
    
    _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_balanceLabel.frame), 0, 155, 50)];
    if(_reward.integerValue == 0){
        _sureBtn.backgroundColor = [UIColor lightGrayColor];
        _sureBtn.userInteractionEnabled = NO;
    }else{
        _sureBtn.backgroundColor = A008cee;
        _sureBtn.userInteractionEnabled = YES;
    }
    [_sureBtn setTitle:@"确定打赏" forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView addSubview:_sureBtn];
}

-(void)payAction:(UIButton *)btn
{
    for(int i = 0;i<5;i++){
        UIButton *Btn = (UIButton *)[_backScroll viewWithTag:i + 1];
        Btn.selected = NO;
        Btn.layer.borderColor = A999.CGColor;
    }
    btn.selected = YES;
    btn.layer.borderColor = A008cee.CGColor;
    _payBtn = btn;
}

-(void)btnAction:(UIButton *)btn
{
    if(btn.tag == 10){
        if(_tuMuBtn.selected){
            
        }else{
            _tuMuBtn.selected = YES;
            _gongCBtn.selected = NO;
            _tuMuBtn.layer.borderColor = A008cee.CGColor;
            _gongCBtn.layer.borderColor = A999.CGColor;
            _tuMuBtn.userInteractionEnabled = NO;
            _gongCBtn.userInteractionEnabled = YES;
            _balanceLabel.text = [NSString stringWithFormat:@"土木币余额 : %@",_credit2];
        }
    }else{
        if(_gongCBtn.selected){
            
        }else{
            _gongCBtn.selected = YES;
            _tuMuBtn.selected = NO;
            _gongCBtn.layer.borderColor = A008cee.CGColor;
            _tuMuBtn.layer.borderColor = A999.CGColor;
            _gongCBtn.userInteractionEnabled = NO;
            _tuMuBtn.userInteractionEnabled = YES;
            _balanceLabel.text = [NSString stringWithFormat:@"工程点余额 : %@",_credit1];
        }
    }
}
-(void)makeSure
{
    if(_tuMuBtn.selected || _gongCBtn.selected){
        if(_payBtn.selected){
            NSInteger type;
            if(_tuMuBtn.selected){
                type = 2;
            }else if(_gongCBtn.selected){
                type = 1;
            }
            NSInteger credit;
            if(_payBtn.tag == 1){
                credit = 1;
            }else if(_payBtn.tag == 2){
                credit = 5;
            }else if(_payBtn.tag == 3){
                credit = 10;
            }else if(_payBtn.tag == 4){
                credit = 15;
            }else if(_payBtn.tag == 5){
                credit = 20;
            }
            MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode=MBProgressHUDAnimationFade;
            NSString *urlString = [NSString stringWithFormat:@"%@/protected/member/rewardCredit",API_HOST];
            NSLog(@"%@",urlString);
            SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
            NSMutableDictionary *messageDic = [MessageTool getMessage];
            [messageDic setObject:_tid forKey:@"tid"];
            [messageDic setObject:@"" forKey:@"note"];
            [messageDic setObject:@"utf-8" forKey:@"charset"];
            [messageDic setObject:[NSString stringWithFormat:@"%ld",type] forKey:@"credit_type"];
            NSLog(@"%ld",credit);
            [messageDic setObject:[NSString stringWithFormat:@"%ld",credit] forKey:@"credit"];
            [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"%@",responseObject);
                NSString *codeStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if([codeStr isEqualToString:@"0"]){
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"打赏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }else {
                    [tools alert:responseObject[@"msg"]];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }else{
            [tools alert:@"请输入打赏金额"];
        }
    }else{
        [tools alert:@"请输入币种"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0)
{
    [self backClick];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"daShang" object:nil];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

//
//  EveryDayGetController.m
//  SCCBBS
//
//  Created by co188 on 16/11/10.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "EveryDayGetController.h"
#import "SCCHeader.h"
#import "SCCAFnetTool.h"
#import <MBProgressHUD.h>
#import "MessageTool.h"
#import "tools.h"
#import "GoodsGetModel.h"
@interface EveryDayGetController ()<UIAlertViewDelegate>
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIScrollView *_scrollView;
    UILabel *_dayLabOne;
    UILabel *_dayLabTwo;
    
    NSMutableArray *_dataArray;
    
    UIImageView *_firstDay;
    UIImageView *_secondDay;
    UIImageView *_thirdDay;
    
    NSString *_today_sign;  //1 代表今天已经签到成功,0 代表今日没有签到成功
    NSString *_today_total; //今日签到总人数
    NSString *_count1; //本人签到总次数
    NSString *_count2;  //本人连续签到次数
    NSString *_count2x;  //本人距当前签到次数
    NSString *_time_count1;  //本人 季度累计签到
    NSString *_time_credit2 ; //本人本季度获得的奖励 土木币个数
}
@end

@implementation EveryDayGetController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray new];
    }
    return self;
}
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self prepareData];
}


-(void)prepareData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/member/getSignInfo",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dic = responseObject[@"data"];
            _count1 = [NSString stringWithFormat:@"%@",dic[@"count1"]];
            _count2 = [NSString stringWithFormat:@"%@",dic[@"count2"]];
            _count2x = [NSString stringWithFormat:@"%@",dic[@"count2x"]];
            _time_count1 = [NSString stringWithFormat:@"%@",dic[@"""time_count1"""]];
            _time_credit2 = [NSString stringWithFormat:@"%@",dic[@"""time_credit2"""]];
            _today_sign = [NSString stringWithFormat:@"%@",dic[@"""today_sign"""]];
            _today_total = [NSString stringWithFormat:@"%@",dic[@"""today_total"""]];
//            [self getData];
            [self createUI];
        }else if([code isEqualToString:@"500"]){
            [tools alert:responseObject[@"msg"]];
        }else if([code isEqualToString:@"401"]){
            [tools alert:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

-(void)createUI
{
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT - 17)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 226)];
    headImg.userInteractionEnabled = YES;
    headImg.image = [UIImage imageNamed:@"banckground"];
    headImg.clipsToBounds = YES;
    [_scrollView addSubview:headImg];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    [headImg addSubview:headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"每日签到";
    _label.textAlignment = NSTextAlignmentCenter;
    
    _label.font = [UIFont systemFontOfSize:18];
    _label.textColor = [UIColor whiteColor];
    _label.center = CGPointMake(headView.center.x, _label.center.y);
    [headView addSubview:_label];
    //连续签到时间
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame) + 40, WIN_WIDTH, 20)];
    NSMutableAttributedString *numText=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"你已经连续签到 %@ 天",_count2] attributes:nil];
    [numText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:19] range:NSMakeRange(7, _count2.length)];
    label.attributedText = numText;
    label.font = [UIFont systemFontOfSize:19];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [headImg addSubview:label];
    UILabel *hasQianDao = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+17, WIN_WIDTH, 15)];
    hasQianDao.textAlignment = NSTextAlignmentCenter;
    hasQianDao.textColor = [UIColor whiteColor];
    hasQianDao.font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString *hasText=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"今日已有 %@ 人签到",_today_total] attributes:nil];
    [hasText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(5, _today_total.length)];
    hasQianDao.attributedText = hasText;
    
    [headImg addSubview:hasQianDao];
    
    _leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 0, 40, 44)];
    _leftBtn.imageEdgeInsets=UIEdgeInsetsMake(10, 6, 9, 15);
    [_leftBtn setImage:[UIImage imageNamed:@"back"]  forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.center = CGPointMake(_leftBtn.center.x, _label.center.y);
    [headView addSubview:_leftBtn];
    // 累计的天数
    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headImg.frame), WIN_WIDTH, 67)];
    secondView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:secondView];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH/2, 67)];
    [secondView addSubview:leftView];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH/2 - 0.5, 25, 0.5, 17)];
    line.backgroundColor = A999999;
    [leftView addSubview:line];
    _dayLabOne = [[UILabel alloc]initWithFrame:CGRectMake(0, 19.5, WIN_WIDTH/2-0.5, 15)];
    _dayLabOne.font = [UIFont systemFontOfSize:13];
    _dayLabOne.textColor = A333;
    _dayLabOne.text = _time_count1;
    _dayLabOne.textAlignment = NSTextAlignmentCenter;
    [leftView addSubview:_dayLabOne];
    UILabel *jiDuLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_dayLabOne.frame) + 7, WIN_WIDTH/2 - 0.5, 15)];
    jiDuLab.font = [UIFont systemFontOfSize:13];
    jiDuLab.textColor = A333;
    jiDuLab.text = @"季度累计签到";
    jiDuLab.textAlignment = NSTextAlignmentCenter;
    [leftView addSubview:jiDuLab];
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2, 0, WIN_WIDTH/2, 67)];
    [secondView addSubview:rightView];
    _dayLabTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, 19.5, WIN_WIDTH/2, 15)];
    _dayLabTwo.font = [UIFont systemFontOfSize:13];
    _dayLabTwo.textColor = A333;
    _dayLabTwo.text = _time_credit2;
    _dayLabTwo.textAlignment = NSTextAlignmentCenter;
    [rightView addSubview:_dayLabTwo];
    UILabel *BJDuLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_dayLabTwo.frame) + 7, WIN_WIDTH/2, 15)];
    BJDuLab.font = [UIFont systemFontOfSize:13];
    BJDuLab.textColor = A333;
    BJDuLab.text = @"本季度累计获得奖励";
    BJDuLab.textAlignment = NSTextAlignmentCenter;
    [rightView addSubview:BJDuLab];
    //天数图片加载
    UIView *lastView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(secondView.frame), WIN_WIDTH, 10)];
    lastView.backgroundColor = Af4f5f9;
    [_scrollView addSubview:lastView];
    
    CGFloat width = (WIN_WIDTH-70)/3;
    CGFloat height = width / 0.72;
    _firstDay = [[UIImageView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(secondView.frame) + 26, width, height)];
    _firstDay.clipsToBounds = YES;
    _firstDay.image = [UIImage imageNamed:@"firstday-sign"];
    [_scrollView addSubview:_firstDay];
    
    _secondDay = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_firstDay.frame) + 23,CGRectGetMaxY(secondView.frame) + 26, width, height)];
    _secondDay.clipsToBounds = YES;
    _secondDay.image = [UIImage imageNamed:@"secondday-noraml"];
    [_scrollView addSubview:_secondDay];
    
    _thirdDay = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_secondDay.frame) + 23,CGRectGetMaxY(secondView.frame) + 26, width, height)];
    _thirdDay.clipsToBounds = YES;
    _thirdDay.image = [UIImage imageNamed:@"thirdday-unormal"];
    [_scrollView addSubview:_thirdDay];
    
    if([_count2x isEqualToString:@"0"]){
        if([_today_sign isEqualToString:@"0"]){
            _firstDay.image = [UIImage imageNamed:@"firstday-normal"];
            _secondDay.image = [UIImage imageNamed:@"secondday-unmoral"];
            _thirdDay.image = [UIImage imageNamed:@"thirdday-unormal"];
        }else {
            _firstDay.image = [UIImage imageNamed:@"firstday-sign"];
            _secondDay.image = [UIImage imageNamed:@"secondday-unmoral"];
            _thirdDay.image = [UIImage imageNamed:@"thirdday-unormal"];
        }
    }else if([_count2x isEqualToString:@"1"]){
        if([_today_sign isEqualToString:@"0"]){
            _firstDay.image = [UIImage imageNamed:@"firstday-sign"];
            _secondDay.image = [UIImage imageNamed:@"secondday-noraml"];
            _thirdDay.image = [UIImage imageNamed:@"thirdday-unormal"];
        }else {
            _firstDay.image = [UIImage imageNamed:@"firstday-sign"];
            _secondDay.image = [UIImage imageNamed:@"secondday-sign"];
            _thirdDay.image = [UIImage imageNamed:@"thirdday-unormal"];
        }

    } else {
        if([_today_sign isEqualToString:@"2"]){
            _firstDay.image = [UIImage imageNamed:@"firstday-sign"];
            _secondDay.image = [UIImage imageNamed:@"secondday-sign"];
            _thirdDay.image = [UIImage imageNamed:@"thirdday-normal"];
        }else {
            _firstDay.image = [UIImage imageNamed:@"firstday-sign"];
            _secondDay.image = [UIImage imageNamed:@"secondday-sign"];
            _thirdDay.image = [UIImage imageNamed:@"thirdday-normal"];
            if([_today_sign isEqualToString:@"1"]){
                _thirdDay.image = [UIImage imageNamed:@"thirdday-sign"];
            }else{
                _thirdDay.image = [UIImage imageNamed:@"thirdday-normal"];
            }
            
        }
    }
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(_firstDay.frame) + 50, WIN_WIDTH - 60, 51)];
    btn.backgroundColor = A008cee;
    [btn setTitle:@"点击签到" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 4;
    btn.clipsToBounds = YES;
    [btn addTarget:self action:@selector(qianDaoAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_scrollView addSubview:btn];
    if([_today_sign isEqualToString:@"1"]){
        btn.userInteractionEnabled = NO;
        btn.backgroundColor = [UIColor grayColor];
    }else{
        btn.userInteractionEnabled = YES;
    }

    if(CGRectGetMaxY(btn.frame) + 66 > (WIN_HEIGHT - 66)){
        _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(btn.frame) + 66);
    }else{
        _scrollView.contentSize = CGSizeMake(0, WIN_HEIGHT - 66);
    }
    
    UIImageView *halfCircle = [[UIImageView alloc]initWithFrame:CGRectMake(0, WIN_HEIGHT - 17, WIN_WIDTH, 17)];
    halfCircle.image = [UIImage imageNamed:@"banyuan"];
    halfCircle.clipsToBounds = YES;
//    [self.view addSubview:halfCircle];
    
}
#pragma mark- 签到
-(void)qianDaoAction
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/member/sign",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [afTool postMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"成功签到" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];

        }else if([code isEqualToString:@"500"]){
            [tools alert:responseObject[@"msg"]];
        }else if([code isEqualToString:@"401"]){
            [tools alert:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0)
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"successQianDao" object:nil];
    [_scrollView removeFromSuperview];
    [self prepareData];
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

//
//  ZhiFuResultController.m
//  SCCBBS
//
//  Created by co188 on 17/2/7.
//  Copyright © 2017年 co188. All rights reserved.
//

#import "ZhiFuResultController.h"
#import "SCCHeader.h"
#import "SCCBtn.h"

@interface ZhiFuResultController ()
{
    UILabel *_label;
    UIButton *_leftBtn;
}
@end

@implementation ZhiFuResultController

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
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"支付成功";
    _label.textAlignment = NSTextAlignmentCenter;
    
    _label.font = [UIFont systemFontOfSize:18];
    _label.textColor = [UIColor whiteColor];
    _label.center = CGPointMake(headView.center.x, _label.center.y);
    [headView addSubview:_label];
    
    _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 40, 44)];
    _leftBtn.imageEdgeInsets=UIEdgeInsetsMake(10, 6, 9, 15);
    [_leftBtn setImage:[UIImage imageNamed:@"back"]  forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.center = CGPointMake(_leftBtn.center.x, _label.center.y);
    [headView addSubview:_leftBtn];
    
    [self createUI];
}

-(void)createUI
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 91, WIN_WIDTH, 20)];
    label.text = @"恭喜你，充值成功!";
    label.textColor = FFA800;
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    NSString *detail = [NSString stringWithFormat:@"您已成功充值%@工程点。如有疑问，请通过的“我的－意见反馈”，或者拨打客服电话：0519-68887188联系我们。",_congDian];
    CGSize detailSize = [self sizeWithText:detail font:[UIFont systemFontOfSize:13] maxW:WIN_WIDTH - 42];
    UILabel *detailLab = [[UILabel alloc]initWithFrame:CGRectMake(21, CGRectGetMaxY(label.frame) + 27, WIN_WIDTH - 42, detailSize.height + 10)];
    detailLab.font = [UIFont systemFontOfSize:13];
    detailLab.textColor = A666666;
    detailLab.numberOfLines = 0;
    detailLab.text = detail;
    [self.view addSubview:detailLab];
    
    SCCBtn *btn = [[SCCBtn alloc]initWithFrame:CGRectMake((WIN_WIDTH/2-124)/2, CGRectGetMaxY(detailLab.frame) + 31, 124, 35)];
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = A008cee.CGColor;
    btn.layer.cornerRadius = 3;
    btn.clipsToBounds = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:@"返回首页" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:A008cee forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    SCCBtn *rBtn = [[SCCBtn alloc]initWithFrame:CGRectMake(WIN_WIDTH/2 + (WIN_WIDTH/2-124)/2, CGRectGetMaxY(detailLab.frame) + 31, 124, 35)];
    rBtn.layer.cornerRadius = 3;
    rBtn.backgroundColor = A008cee;
    rBtn.clipsToBounds = YES;
    [rBtn setTitle:@"继续充值" forState:UIControlStateNormal];
    rBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [rBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:rBtn];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"backHomeView" object:nil];
    
}

@end

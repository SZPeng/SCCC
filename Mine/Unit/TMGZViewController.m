//
//  TMGZViewController.m
//  SCCBBS
//
//  Created by co188 on 17/1/11.
//  Copyright © 2017年 co188. All rights reserved.
//

#import "TMGZViewController.h"
#import "SCCHeader.h"
@interface TMGZViewController ()
{
    UILabel *_label;
    UIButton *_leftBtn;
}
@end

@implementation TMGZViewController

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
    _label.text = @"土木币规则";
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
    // Do any additional setup after loading the view.
}

-(void)createUI
{
    NSString *textStr = @"土木币是中国最具影响力的土木工程门户网站－CO土木在线推出的一种虚拟货币，主要可以用来购买土木在线提供的图纸、资料等资源以及进行专区讨论。土木币是资深用户在土木在线的权力象征。";
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 76, WIN_WIDTH - 24, 15)];
    label.text = @"一、土木币的概念";
    label.textColor = A333;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    
    CGSize textSize = [self sizeWithText:textStr font:[UIFont systemFontOfSize:13] maxW:WIN_WIDTH - 24];
    UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(label.frame) + 12, WIN_WIDTH - 24, textSize.height)];
    textLab.textColor = A666;
    textLab.numberOfLines = 0;
    textLab.text = textStr;
    textLab.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:textLab];
    
    UILabel *secLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(textLab.frame) +16, WIN_WIDTH - 24, 15)];
    secLabel.text = @"二、土木币的用途";
    secLabel.textColor = A333;
    secLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:secLabel];

    NSString *Str = @"土木币是";
    CGSize tSize = [self sizeWithText:Str font:[UIFont systemFontOfSize:13] maxW:WIN_WIDTH - 24];
    UILabel *oneLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(secLabel.frame) + 12, WIN_WIDTH - 24, tSize.height)];
    oneLab.textColor = A666;
    oneLab.font = [UIFont systemFontOfSize:13];
    oneLab.text = @"1. 下载土木在线部分图纸、软件、论文;";
    [self.view addSubview:oneLab];
    
    UILabel *twoLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(oneLab.frame) + 2, WIN_WIDTH - 24, tSize.height)];
    twoLab.textColor = A666;
    twoLab.font = [UIFont systemFontOfSize:13];
    twoLab.text = @"2. 购买论坛道具，增加帖子效果;";
    [self.view addSubview:twoLab];
    
    UILabel *thirdLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(twoLab.frame) + 2, WIN_WIDTH - 24, tSize.height)];
    thirdLab.textColor = A666;
    thirdLab.font = [UIFont systemFontOfSize:13];
    thirdLab.text = @"3. 发布悬赏贴，让其他用户帮忙解决问题;";
    [self.view addSubview:thirdLab];
    
    UILabel *threeLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(thirdLab.frame) +16, WIN_WIDTH - 24, 15)];
    threeLab.text = @"三、土木币的获得渠道";
    threeLab.textColor = A333;
    threeLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:threeLab];
    
    UILabel *detalLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(threeLab.frame) + 12, WIN_WIDTH - 24, tSize.height)];
    detalLab.text = @"请前往PC端查看";
    detalLab.textColor = A666;
    detalLab.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:detalLab];
    
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

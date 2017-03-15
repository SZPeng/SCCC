//
//  RechargeViewController.m
//  SCCBBS
//
//  Created by co188 on 17/1/10.
//  Copyright © 2017年 co188. All rights reserved.
//

#import "RechargeViewController.h"
#import "SCCHeader.h"
#import "SCCAFnetTool.h"
#import <MBProgressHUD.h>
#import "MessageTool.h"
#import "tools.h"
#import "ZhiFuViewController.h"
#import "PriceModel.h"

@interface RechargeViewController ()
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIButton *_leftButton;
    UIButton *_rightButton;
    UIView *_bodyView;
    
    UIView *_leftLineView;
    UIView *_rightLineView;
    UILabel *_numLab;
    NSString *_credit1;  //工程点
    NSString *_credit2;  //土木币
    NSString *_displayname;  //nichen
    UILabel *_yuLab;  //余留工程点
    
    NSInteger _number;
    NSMutableArray *_show_pointArray;
    NSMutableArray *_priceArray;  //价格数组
    NSString *_gcd_balance;  //工程点
    
    UILabel *_parLab;
    
    NSString *_congDian;
    NSString *_money;
    NSString *_overID;  // 传过去的ID
    
    UILabel *_nowTMBi;
    UILabel *_nowGCDian;
    
}
@end

@implementation RechargeViewController

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _number = 1;
        _show_pointArray = [NSMutableArray new];
        _priceArray = [NSMutableArray new];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"充值中心";
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
    [self prepareData];
//    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)prepareData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/charge/point",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    NSLog(@"%@",messageDic);
    [messageDic setObject:VERSION forKey:@"version"];
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            _gcd_balance = [NSString stringWithFormat:@"%@",responseObject[@"""gcd_balance"""]];
            NSArray *dataArray = responseObject[@"data"];
            for(NSDictionary *dic in dataArray){
                NSString *showpoint = [NSString stringWithFormat:@"%@",dic[@"""show_point"""]];
                PriceModel *model = [PriceModel new];
                model.original_price = [NSString stringWithFormat:@"%@",dic[@"""original_price"""]];
                model.point = [NSString stringWithFormat:@"%@",dic[@"point"]];
                model.price = [NSString stringWithFormat:@"%@",dic[@"price"]];
                model.pid = [NSString stringWithFormat:@"%@",dic[@"pid"]];
                [_priceArray addObject:model];
                
                [_show_pointArray addObject:showpoint];
            }
        }
        [self createUI];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
-(void)createUI
{
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, 40)];
    btnView.backgroundColor = [UIColor whiteColor];
    _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH/2, 40)];
    [_leftButton setTitle:@"工程点充值" forState:UIControlStateNormal];
    [_leftButton setTitleColor:A333 forState:UIControlStateNormal];
    _leftButton.selected = YES;
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_leftButton setTitleColor:A008cee forState:UIControlStateSelected];
    [_leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:_leftButton];
    _leftLineView = [[UIView alloc]initWithFrame:CGRectMake((WIN_WIDTH/2 - 105)/2, 38, 105, 1.5)];
    _leftLineView.backgroundColor = A008cee;
    [btnView addSubview:_leftLineView];
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/2, 0, WIN_WIDTH/2, 40)];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightButton setTitle:@"土木币兑换" forState:UIControlStateNormal];
    [_rightButton setTitleColor:A333 forState:UIControlStateNormal];
    [_rightButton setTitleColor:A008cee forState:UIControlStateSelected];
    [_rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:_rightButton];
    _rightLineView = [[UIView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2 + (WIN_WIDTH/2 - 105)/2, 38, 105, 1.5)];
    _rightLineView.hidden = YES;
    _rightLineView.backgroundColor = A008cee;
    [btnView addSubview:_rightLineView];

    if([_style isEqualToString:@"1"]){
        _leftButton.selected = NO;
        _leftLineView.hidden = YES;
        _rightButton.selected = YES;
        _rightLineView.hidden = NO;
        [self getMessage];
    }else{
      [self createBody];
    }
    [self.view addSubview:btnView];
    
    
}

-(void)createBody
{
    
    _bodyView = [[UIView alloc]initWithFrame:CGRectMake(0, 104, WIN_WIDTH, WIN_HEIGHT - 104)];
    _bodyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bodyView];
    
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 41)];
    firstView.backgroundColor = Af4f5f9;
    [_bodyView addSubview:firstView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 41)];
    label.text = @"充值满200工程点，送精美礼品";
    label.textColor = A999;
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [firstView addSubview:label];
    
    _yuLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(firstView.frame) + 12, WIN_WIDTH - 24, 15)];
    _yuLab.text = [NSString stringWithFormat:@"余额: %@个工程点",_gcd_balance];
    _yuLab.textColor = A666;
    _yuLab.font = [UIFont systemFontOfSize:13];
    [_bodyView addSubview:_yuLab];
    
    CGFloat width = (WIN_WIDTH - 54)/3;
    NSArray *array = _show_pointArray;
    for(int i = 0;i<6;i++){
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12 + (i%3)*(width + 15), CGRectGetMaxY(_yuLab.frame) + 20 +(i/3)*53, width, 38)];
        btn.tag = i + 10;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_bodyView addSubview:btn];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:A666 forState:UIControlStateNormal];
        [btn setTitleColor:A008cee forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0){
            btn.selected = YES;
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = A008cee.CGColor;
        }else{
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = A666666.CGColor;
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(width - 28, 0, 28, 19)];
            imgView.image = [UIImage imageNamed:@"zhe"];
            [btn addSubview:imgView];
        }
    }
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_yuLab.frame) + 131, WIN_WIDTH - 24, 0.5)];
    line.backgroundColor = Ae1e2e6;
    [_bodyView addSubview:line];
    
    _parLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(line.frame), WIN_WIDTH - 24, 49)];
    PriceModel *model = [_priceArray firstObject];
    _money = model.price;
    _congDian = model.point;
    _overID = model.pid;
    NSString *JTGZStr = [NSString stringWithFormat:@"需支付: %@元(原价%@元)",model.price,model.original_price];
    NSInteger priceLen = model.price.length;
    NSInteger PriceL = model.original_price.length;
    _parLab.textColor = A333;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:JTGZStr];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:FFA800 range:NSMakeRange(5,  priceLen+1)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:A999999 range:NSMakeRange(6+priceLen,  5+PriceL)];
    _parLab.attributedText = attributedStr;
    _parLab.font = [UIFont systemFontOfSize:13];
    [_bodyView addSubview:_parLab];
    
    UILabel *LastLine = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_parLab.frame), WIN_WIDTH - 24, 0.5)];
    LastLine.backgroundColor = Ae1e2e6;
    [_bodyView addSubview:LastLine];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(LastLine.frame) + 50, WIN_WIDTH - 60, 51)];
    btn.backgroundColor = A008cee;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"去支付" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn addTarget:self action:@selector(ziFuAction) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 4;
    btn.clipsToBounds = YES;
    [_bodyView addSubview:btn];
}
#pragma mark-工程点点击事件
-(void)btnAction:(UIButton *)Btn
{
    for(int i = 0;i<6;i++){
        UIButton *btn = (UIButton *)[_bodyView viewWithTag:i+10];
        NSLog(@"%@",btn.titleLabel.text);
        btn.selected = NO;
        [btn setTitleColor:A666666 forState:UIControlStateNormal];
        btn.layer.borderColor = A666666.CGColor;
    }
    Btn.selected = YES;
    Btn.layer.borderColor = A008cee.CGColor;
    
    PriceModel *model = _priceArray[Btn.tag - 10];
    NSString *JTGZStr = [NSString stringWithFormat:@"需支付: %@元(原价%@元)",model.price,model.original_price];
    NSInteger priceLen = model.price.length;
    NSInteger PriceL = model.original_price.length;
    _parLab.textColor = A333;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:JTGZStr];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:FFA800 range:NSMakeRange(5,  priceLen+1)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:A999999 range:NSMakeRange(6+priceLen,  5+PriceL)];
    _parLab.attributedText = attributedStr;
    
    _congDian = model.point;
    
    _money = model.price;
    _overID = model.pid;
}

-(void)getMessage
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/member/getUserinfo",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    NSLog(@"%@",messageDic);
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dic = responseObject[@"data"];
            _credit1 = [NSString stringWithFormat:@"%@",dic[@"credit1"]];
            _credit2 = [NSString stringWithFormat:@"%@",dic[@"credit2"]];
            _gcd_balance = _credit1;
            _displayname = dic[@"displayname"];
            [self createYuHuan];
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
-(void)createYuHuan
{
    _bodyView = [[UIView alloc]initWithFrame:CGRectMake(0, 104, WIN_WIDTH, WIN_HEIGHT - 104)];
    _bodyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bodyView];
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 41)];
    firstView.backgroundColor = Af4f5f9;
    [_bodyView addSubview:firstView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 41)];
    label.text = @"土木币可用于下载土木在线部分图纸、软件、论文";
    label.textColor = A999;
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [firstView addSubview:label];
    
    UILabel *ZHLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(firstView.frame), WIN_WIDTH - 24, 49)];
    ZHLabel.text = [NSString stringWithFormat:@"账号:  %@",_displayname];
    ZHLabel.textColor = A333;
    ZHLabel.font = [UIFont systemFontOfSize:13];
    [_bodyView addSubview:ZHLabel];
    
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(ZHLabel.frame), WIN_WIDTH - 24, 0.5)];
    lineLab.backgroundColor = Ae1e2e6;
    [_bodyView addSubview:lineLab];
    
    UILabel *numLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lineLab.frame) + 18, 40, 20)];
    numLab.text = @"数量:";
    numLab.textColor = A333;
    numLab.font = [UIFont systemFontOfSize:13];
    [_bodyView addSubview:numLab];
    
    UIButton *leftJian = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLab.frame) + 10 , CGRectGetMaxY(lineLab.frame) + 9, 39, 33)];
//    leftJian.backgroundColor = F5F5F5;
    [leftJian addTarget:self action:@selector(jianAction) forControlEvents:UIControlEventTouchUpInside];
    [leftJian setBackgroundImage:[UIImage imageNamed:@"jian"] forState:UIControlStateNormal];
    [_bodyView addSubview:leftJian];
    
    _numLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftJian.frame), CGRectGetMaxY(lineLab.frame) + 9, 46, 33)];
    _numLab.text = @"1";
    _numLab.textAlignment = NSTextAlignmentCenter;
    _numLab.textColor = A333;
    _numLab.font = [UIFont systemFontOfSize:14];
    [_bodyView addSubview:_numLab];
    
    UIButton *rightJia = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_numLab.frame),CGRectGetMaxY(lineLab.frame)+9, 39, 33)];
//    rightJia.backgroundColor = F5F5F5;
    [rightJia addTarget:self action:@selector(jiaAction) forControlEvents:UIControlEventTouchUpInside];
    [rightJia setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    [_bodyView addSubview:rightJia];
    
    UILabel *detalLab = [[UILabel alloc]initWithFrame:CGRectMake(61, CGRectGetMaxY(_numLab.frame) + 14, WIN_WIDTH - 122, 20)];
    NSString *JTGZStr = @"亲输入需要兑换的工程点数，1工程点 = 10土木币";
    detalLab.textColor = A666;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:JTGZStr];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:A008cee range:NSMakeRange(8,  3)];
    detalLab.attributedText = attributedStr;
    detalLab.font = [UIFont systemFontOfSize:10];
    
    [_bodyView addSubview:detalLab];
    
    UILabel *lineL = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(detalLab.frame) + 14, WIN_WIDTH - 24, 0.5)];
    lineL.backgroundColor = Ae1e2e6;
    [_bodyView addSubview:lineL];
    
    _nowGCDian = [[UILabel alloc]initWithFrame:CGRectMake(12,CGRectGetMaxY(lineL.frame) , WIN_WIDTH - 24, 50)];
    _nowGCDian.text = [NSString stringWithFormat:@"当前工程点: %@",_credit1];
    _nowGCDian.font = [UIFont systemFontOfSize:13];
    _nowGCDian.textColor = A333;
    [_bodyView addSubview:_nowGCDian];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_nowGCDian.frame), WIN_WIDTH - 24, 0.5)];
    lineLabel.backgroundColor = Ae1e2e6;
    [_bodyView addSubview:lineLabel];
    
    _nowTMBi = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lineLabel.frame), WIN_WIDTH - 24, 50)];
    _nowTMBi.text = [NSString stringWithFormat:@"当前土木币: %@",_credit2];
    _nowTMBi.font = [UIFont systemFontOfSize:13];
    _nowTMBi.textColor = A333;
    [_bodyView addSubview:_nowTMBi];
    
    UILabel *lastLine = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_nowTMBi.frame), WIN_WIDTH - 24, 0.5)];
    lastLine.backgroundColor = Ae1e2e6;
    [_bodyView addSubview:lastLine];
    
    
    UIButton *ZFBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(lastLine.frame) + 50, WIN_WIDTH - 60, 51)];
    ZFBtn.backgroundColor = A008cee;
    [ZFBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ZFBtn setTitle:@"去兑换" forState:UIControlStateNormal];
    [ZFBtn addTarget:self action:@selector(getDian) forControlEvents:UIControlEventTouchUpInside];
    
    ZFBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    ZFBtn.layer.cornerRadius = 4;
    ZFBtn.clipsToBounds = YES;
    [_bodyView addSubview:ZFBtn];
    
}

#pragma mark-兑换点数
-(void)getDian
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/member/credit/exchange",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:[NSString stringWithFormat:@"%ld",_number] forKey:@"credit1"];
    NSLog(@"%@",messageDic);
    [afTool postMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dataDic = responseObject[@"data"];
            NSString *balance_credit1 = [NSString stringWithFormat:@"%@",dataDic[@"""balance_credit1"""]];
            NSString *balance_credit2 = [NSString stringWithFormat:@"%@",dataDic[@"""balance_credit2"""]];
            _credit1 = balance_credit1;
            _credit2 = balance_credit2;
            _nowGCDian.text = [NSString stringWithFormat:@"当前工程点: %@",_credit1];
            _nowTMBi.text = [NSString stringWithFormat:@"当前土木币: %@",_credit2];

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

-(void)jianAction
{
    if(_number <= 1){
        _number = 1;
    }else{
        _number--;
    }
    
    _numLab.text = [NSString stringWithFormat:@"%ld",_number];
}

-(void)jiaAction
{
    _number++;
    _numLab.text = [NSString stringWithFormat:@"%ld",_number];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)leftAction
{
    if(_leftButton.selected){
        
    }else{
        [_bodyView removeFromSuperview];
        _leftButton.selected = YES;
        _rightButton.selected = NO;
        _leftLineView.hidden = NO;
        _rightLineView.hidden = YES;
        [self createBody];
    }
}

-(void)rightAction
{
    if(_rightButton.selected){
        
    }else{
        [_bodyView removeFromSuperview];
        _rightButton.selected = YES;
        _leftButton.selected = NO;
        _leftLineView.hidden = YES;
        _rightLineView.hidden = NO;
        [self getMessage];
    }
}

-(void)ziFuAction
{
    ZhiFuViewController *vc = [[ZhiFuViewController alloc]init];
    vc.price = _money;
    vc.dianShu = _congDian;
    vc.pid = _overID;
    [self.navigationController pushViewController:vc animated:YES];
}
@end

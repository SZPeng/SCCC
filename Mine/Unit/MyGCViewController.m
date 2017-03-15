//
//  MyGCViewController.m
//  SCCBBS
//
//  Created by co188 on 17/1/11.
//  Copyright © 2017年 co188. All rights reserved.
//

#import "MyGCViewController.h"
#import "SCCHeader.h"
#import "SCCAFnetTool.h"
#import <MBProgressHUD.h>
#import "MessageTool.h"
#import "tools.h"
#import "SCCBtn.h"
#import "GChenModel.h"
#import "GChenTableViewCell.h"
#import <MJRefresh.h>
@interface MyGCViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIView *_btnView;
    
    NSMutableArray *_dataArray;
    
    UITableView *_myTableView;
    
    UIView *_GZView;
    NSInteger _currentPage;
}
@end

@implementation MyGCViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray new];
        _currentPage = 1;
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,192 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"我的工程点";
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
    
    UILabel *nowGCB = [[UILabel alloc]initWithFrame:CGRectMake(20, 89, WIN_WIDTH - 40, 15)];
    nowGCB.text = @"当前工程点";
    nowGCB.textColor = [UIColor whiteColor];
    nowGCB.font = [UIFont systemFontOfSize:13];
    [headView addSubview:nowGCB];
    
    UILabel *dianLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nowGCB.frame) + 15, WIN_WIDTH, 40)];
    dianLab.textColor = [UIColor whiteColor];
    dianLab.font = [UIFont systemFontOfSize:45];
    dianLab.text = _dianShu;
    dianLab.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:dianLab];
    
    _btnView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), WIN_WIDTH, 45)];
    _btnView.backgroundColor = [UIColor colorWithRed:0.11f green:0.60f blue:0.94f alpha:1.00f];
//    [self.view addSubview:_btnView];
    SCCBtn *leftBtn = [[SCCBtn alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH/2 - 0.5, 45)];
    [leftBtn setTitle:@"工程点充值" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_btnView addSubview:leftBtn];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftBtn.frame), 10, 0.5, 25)];
    line.backgroundColor = [UIColor colorWithRed:0.29f green:0.68f blue:0.95f alpha:1.00f];
    [_btnView addSubview:line];
    
    SCCBtn *rightBtn = [[SCCBtn alloc]initWithFrame:CGRectMake(WIN_WIDTH/2, 0, WIN_WIDTH/2, 45)];
    [rightBtn setTitle:@"工程点规则" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(guiZeAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_btnView addSubview:rightBtn];
    
    [self prepareData];
    // Do any additional setup after loading the view.
}
-(void)prepareData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/member/credit/logs",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:@"1" forKey:@"credit_type"];
    NSLog(@"%@",messageDic);
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dataDic = responseObject[@"data"];
            NSArray *creArray = dataDic[@"creditlogs"];
            for(NSDictionary *dic in creArray){
                GChenModel *model = [GChenModel new];
                model.detail = dic[@"detail"];
                model.time = dic[@"time"];
                model.num = [NSString stringWithFormat:@"%@",dic[@"credit"]];
                [_dataArray addObject:model];
            }
            [self createTable];
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

-(void)createTable
{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 192, WIN_WIDTH, WIN_HEIGHT - 192)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 48)];
    headView.backgroundColor = Af4f5f9;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, WIN_WIDTH - 24, 48)];
    label.text = @"明细列表";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = A999;
    [headView addSubview:label];
    _myTableView.tableHeaderView = headView;
    _myTableView.tableFooterView = [UIView new];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 1;
        [_dataArray removeAllObjects];
        [self getData];
    }];
//    [_myTableView.mj_header beginRefreshing];
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"无更多数据" forState:MJRefreshStateIdle];
    _myTableView.mj_footer = footer;

}

-(void)getData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/member/credit/logs",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:@"1" forKey:@"credit_type"];
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dataDic = responseObject[@"data"];
            NSArray *creArray = dataDic[@"creditlogs"];
            for(NSDictionary *dic in creArray){
                GChenModel *model = [GChenModel new];
                model.detail = dic[@"detail"];
                model.time = dic[@"time"];
                model.num = [NSString stringWithFormat:@"%@",dic[@"credit"]];
                [_dataArray addObject:model];
            }
            [_myTableView reloadData];
        }else if([code isEqualToString:@"500"]){
            [tools alert:responseObject[@"msg"]];
        }else if([code isEqualToString:@"401"]){
            [tools alert:responseObject[@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_myTableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

-(void)loadMoreData
{
    _currentPage++;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/member/credit/logs",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:@"1" forKey:@"credit_type"];
    [messageDic setObject:[NSString stringWithFormat:@"%ld",_currentPage] forKey:@"pageNow"];
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dataDic = responseObject[@"data"];
            NSArray *creArray = dataDic[@"creditlogs"];
            for(NSDictionary *dic in creArray){
                GChenModel *model = [GChenModel new];
                model.detail = dic[@"detail"];
                model.time = dic[@"time"];
                model.num = [NSString stringWithFormat:@"%@",dic[@"credit"]];
                [_dataArray addObject:model];
            }
            [_myTableView reloadData];
        }else if([code isEqualToString:@"500"]){
            [tools alert:responseObject[@"msg"]];
        }else if([code isEqualToString:@"401"]){
            [tools alert:responseObject[@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_myTableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = @"cell";
    GChenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell ==  nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GChenTableViewCell" owner:self options:nil] firstObject];
    }
//    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.row];
    return cell;
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)guiZeAction
{
    _GZView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT)];
    _GZView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    [self.view addSubview:_GZView];
    _GZView.layer.cornerRadius = 4;
    _GZView.clipsToBounds = YES;
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake((WIN_WIDTH - 282)/2, (WIN_HEIGHT - 240)/2, 282, 240)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 4;
    backView.clipsToBounds = YES;
    [_GZView addSubview:backView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 282 - 24, 39)];
    label.text = @"工程点规则";
    label.textColor = A333;
    label.font = [UIFont systemFontOfSize:14];
    [backView addSubview:label];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), 282, 0.5)];
    line.backgroundColor = Ad6d6d6;
    [backView addSubview:line];
    
    UILabel *firstLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(line.frame) + 10, 282-24, 62)];
    firstLab.textColor = A333;
    firstLab.font = [UIFont systemFontOfSize:12];
    firstLab.numberOfLines = 0;
    firstLab.text = @"工程点可以用来兑换土木币，1工程点可兑换10土木币，可以用兑换的土木币购买特权道具、资料和其他需要扣土木币的互动";
    [backView addSubview:firstLab];
    
    UILabel *secLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(firstLab.frame) + 10, 282-24, 62)];
    secLab.textColor = A333;
    secLab.font = [UIFont systemFontOfSize:12];
    secLab.numberOfLines = 0;
    secLab.text = @"工程点仅可用于土木在线直接运营的产品和服务，不可兑换现金，不可兑换土木在线外的产品和服务";
    [backView addSubview:secLab];
    
    SCCBtn *btn = [[SCCBtn alloc]initWithFrame:CGRectMake(0, 198, 282, 42)];
    btn.backgroundColor = Af4f5f9;
    [btn setTitle:@"知道了" forState:UIControlStateNormal];
    [btn setTitleColor:A333 forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)btnAction
{
    [_GZView removeFromSuperview];
}

@end

//
//  MineViewController.m
//  SCCBBS
//
//  Created by co188 on 16/10/27.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "MineViewController.h"
#import "EnterViewController.h"
#import "SCCHeader.h"
#import "ZhuCeViewController.h"
#import "MineModel.h"
#import "MineTableViewCell.h"
#import "MineHeadView.h"
#import "FitViewController.h"
#import "EveryDayGetController.h"
#import "MyMessageViewController.h"
#import "SCCAFnetTool.h"
#import <MBProgressHUD.h>
#import "MessageTool.h"
#import "tools.h"
#import "MyCallBackViewController.h"
#import "MyTicketController.h"
#import "FeedbackViewController.h"
#import "PersonMessage.h"
#import "RechargeViewController.h"
#import "MyGCViewController.h"
#import "MyTMController.h"
@interface MineViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_label;
    UITableView *_myTableView;
    NSMutableArray *_dataArray;
    NSString *_credit1;
    NSString *_credit2;
    NSString *_sign_count2;
    NSString *_displayname;
    NSString *_avatar;
    NSString *_viplevel;
    
    NSString *_signature;
}
@end

@implementation MineViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray new];
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = @"我的";
    lab.textAlignment = NSTextAlignmentCenter;
    
    lab.font = [UIFont systemFontOfSize:18];
    lab.textColor = [UIColor whiteColor];
    lab.center = CGPointMake(headView.center.x, lab.center.y);
    [headView addSubview:lab];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(denglu) name:@"denglu" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enter) name:@"enter" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"successQianDao" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteEnter) name:@"deleteEnter" object:nil];
//    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
//    if(str.length > 0){
////        [self.navigationController pushViewController:[EnterViewController new] animated:YES];
//        [self createUI];
//    }else{
//        [self denglu];
//    }
    [self createUI];
}

-(void)createUI{
    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(str.length > 0){
        [_myTableView removeFromSuperview];
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDAnimationFade;
        NSString *urlString = [NSString stringWithFormat:@"%@/protected/member/getUserinfo",API_HOST];
        SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
        NSMutableDictionary *messageDic = [MessageTool getMessage];
        [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if([code isEqualToString:@"0"]){
                NSDictionary *dic = responseObject[@"data"];
                _credit1 = [NSString stringWithFormat:@"%@",dic[@"credit1"]];
                _credit2 = [NSString stringWithFormat:@"%@",dic[@"credit2"]];
                _sign_count2 = [NSString stringWithFormat:@"%@",dic[@"sign_count2"]];
                _avatar = dic[@"avatar"];
                _displayname = dic[@"displayname"];
                _viplevel = [NSString stringWithFormat:@"%@",dic[@"""vip_level"""]];
                NSDictionary*detailDic = dic[@"detail"];
                _signature = [NSString stringWithFormat:@"%@",detailDic[@"signature"]];
                [self prepareData];
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
    }else{
        [self prepareData];
    }
}
-(void)prepareData
{
    [_dataArray removeAllObjects];
    NSLog(@"%lf",WIN_HEIGHT);
    NSMutableArray *array = [NSMutableArray new];
    NSArray *titleArray = @[@"我的帖子",@"我的回复",@"我的消息"];
    for(int i =0;i<titleArray.count;i++){
        MineModel *model = [MineModel new];
        model.title = titleArray[i];
        model.img = [NSString stringWithFormat:@"%d",i+1];
        [array addObject:model];
    }
    [_dataArray addObject:array];
    NSMutableArray *congZhi = [NSMutableArray new];
    MineModel *modelC = [MineModel new];
    modelC.title = @"充值中心";
    modelC.img = @"6";
    [congZhi addObject:modelC];
    [_dataArray addObject:congZhi];
    
    NSMutableArray *secArray = [NSMutableArray new];
    MineModel *model = [MineModel new];
    model.title = @"设置";
    model.img = @"4";
    MineModel *model2 = [MineModel new];
    model2.title = @"意见反馈";
    model2.img = @"5";
    [secArray addObject:model];
    [secArray addObject:model2];
    [_dataArray addObject:secArray];
    [self createTable];
}

-(void)createTable
{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 49 - 64)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = Af4f5f9;
    [self.view addSubview:_myTableView];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(str.length > 0){
        MineHeadView *headView = [[MineHeadView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 154)];
        __weak __typeof__(self) weakSelf = self;
        [headView setCallBack:^(NSInteger  num) {
            if(num == 2){
               [weakSelf.navigationController pushViewController:[EveryDayGetController new] animated:YES];
            }else if(num == 0){
                MyTMController *vc = [MyTMController new];
                vc.dianShu = _credit2;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                MyGCViewController *vc = [MyGCViewController new];
                vc.dianShu = _credit1;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        headView.signature = _signature;
        headView.vipLevel = _viplevel;
        headView.name = _displayname;
        headView.imgUrl = _avatar;
        headView.numTuMu = _credit2;
        headView.tuMuText = @"土木币";
        headView.numProgect = _credit1;
        headView.progectText = @"工程点";
        headView.numQianDao = _sign_count2;
        headView.qianDao = @"签到";
        
        _myTableView.tableHeaderView = headView;
        [headView setHeadCallBack:^{
            PersonMessage *vc = [PersonMessage new];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }else{
        UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 219 - 64)];
        backImg.image = [UIImage imageNamed:@"background"];
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
        headView.backgroundColor = TMHEADCOLO;
        [backImg addSubview:headView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, WIN_WIDTH, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"我的";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor whiteColor];
//        [headView addSubview:label];
        
        backImg.userInteractionEnabled = YES;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((WIN_WIDTH-100)/2, 50, 100, 39)];
        [btn setTitle:@"登录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 0.5;
        [btn addTarget:self action:@selector(SCCDengLu) forControlEvents:UIControlEventTouchUpInside];
        [backImg addSubview:btn];
        btn.layer.cornerRadius = 3;
        btn.clipsToBounds = YES;
        _myTableView.tableHeaderView = backImg;
    }
}

-(void)SCCDengLu
{
    EnterViewController *vc = [EnterViewController new];
    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:Nav animated:YES completion:nil];
}

#pragma mark-tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = _dataArray[section];
    return array.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = @"cell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell ==  nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MineTableViewCell" owner:self options:nil] firstObject];
        if(indexPath.section == 1){
            cell.name = @"6";
        }
    }
    cell.model = _dataArray[indexPath.section][indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(str.length > 0){
        return 15;
    }else{
        if(section == 0){
            return 0;
        }else{
           return 15;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 20)];
    view.backgroundColor = Af4f5f9;
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 0.5)];
    line.backgroundColor = Ae1e2e6;
//    [view addSubview:line];
    return view;
}

-(void)denglu
{
    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(str.length > 0){
        if(_dataArray.count > 0){
            [_myTableView removeFromSuperview];
            [_dataArray removeAllObjects];
            [self createUI];
        }else{
            [_myTableView removeFromSuperview];
            [_dataArray removeAllObjects];
            [self createUI];
        }
    }else{
        EnterViewController *vc = [EnterViewController new];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:Nav animated:YES completion:nil];
    }
}

-(void)deleteEnter
{
    [_dataArray removeAllObjects];
    [_myTableView removeFromSuperview];
    [self prepareData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(str.length > 0){
        if(indexPath.section == 1){
            RechargeViewController *vc = [RechargeViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(indexPath.section == 2){
            if(indexPath.row == 0){
                [self.navigationController pushViewController:[FitViewController new] animated:YES];
            }else{
                [self.navigationController pushViewController:[FeedbackViewController new] animated:YES];
            }
        }else if(indexPath.section == 0){
            if(indexPath.row == 0){
                MyTicketController *vc = [MyTicketController new];
                [self.navigationController pushViewController:vc animated:YES];
            }else if(indexPath.row == 1){
                MyCallBackViewController *vc  = [MyCallBackViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }else if(indexPath.row == 2){
                [self.navigationController pushViewController:[MyMessageViewController new] animated:YES];
            }
        }
    }else{
        EnterViewController *vc = [EnterViewController new];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:Nav animated:YES completion:nil];
    }
}

-(void)enter
{
    [self createUI];
}

-(void)refreshData
{
    [_dataArray removeAllObjects];
    [_myTableView removeFromSuperview];
    [self createUI];
}

@end

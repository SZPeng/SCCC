//
//  MyMessageViewController.m
//  SCCBBS
//
//  Created by co188 on 16/11/11.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "MyMessageViewController.h"
#import "SCCHeader.h"
#import "SCCAFnetTool.h"
#import "tools.h"
#import "MyMessageModel.h"
#import "MyMessageCell.h"
#import "MessageTool.h"
#import <MBProgressHUD.h>
#import "SistemMessageController.h"
#import "PersionMessageController.h"
#import "SendPrivateMController.h"
#import "MyFriendViewController.h"

@interface MyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIView *_headView;
    NSMutableArray *_dataArray;
    UITableView *_myTableView;
}
@end

@implementation MyMessageViewController

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
        _dataArray = [NSMutableArray new];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"successSend" object:nil];
    _headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:_headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"我的消息";
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
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 45, 0, 44, 44)];
    [rightBtn setImage:[UIImage imageNamed:@"friend-1"]  forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(xiaoxi) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.center = CGPointMake(rightBtn.center.x, _label.center.y);
    [_headView addSubview:rightBtn];
    
    [self prepareData];

}

-(void)prepareData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/msg/getNoticelist",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
//    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:@"utf-8" forKey:@"charset"];
    [messageDic setObject:VERSION forKey:@"version"];
    NSLog(@"%@",messageDic);
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
           NSDictionary *dic = responseObject[@"data"];
            NSArray *dataArray = dic[@"msgs"];
            for(NSDictionary *dict in dataArray){
                MyMessageModel *model = [MyMessageModel new];
                model.msgid = [NSString stringWithFormat:@"%@",dict[@"msgid"]];
                model.subject = [NSString stringWithFormat:@"%@",dict[@"subject"]];
                model.message = [NSString stringWithFormat:@"%@",dict[@"message"]];
                model.type = [NSString stringWithFormat:@"%@",dict[@"type"]];
                model.time = [NSString stringWithFormat:@"%@",dict[@"time"]];
                model.status = [NSString stringWithFormat:@"%@",dict[@"status"]];
                model.headImg = dict[@"avatar"];
                [_dataArray addObject:model];
            }
            [self createTableView];
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

-(void)refreshData
{
    [_dataArray removeAllObjects];
    [_myTableView removeFromSuperview];
    [self prepareData];
}
-(void)createTableView
{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    //取消cell之间的线
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
}

#pragma mark-tableView 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = @"cell";
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell ==  nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyMessageCell" owner:self options:nil] firstObject];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    MyMessageModel *model = _dataArray[indexPath.row];
    if([model.type isEqualToString:@"2"]){
        SistemMessageController *vc = [SistemMessageController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MyMessageModel *model = _dataArray[indexPath.row];
        PersionMessageController *vc = [PersionMessageController new];
        vc.msgid = model.msgid;
        vc.nameTitle = model.subject;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark-我的好友
-(void)xiaoxi
{
    MyFriendViewController *vc = [MyFriendViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

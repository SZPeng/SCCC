//
//  SistemMessageController.m
//  SCCBBS
//
//  Created by co188 on 16/11/11.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "SistemMessageController.h"
#import "SCCHeader.h"
#import "SCCAFnetTool.h"
#import "MessageTool.h"
#import <MBProgressHUD.h>
#import "SistemMessageCell.h"
#import "SistemMessage.h"
#import <MJRefresh.h>

@interface SistemMessageController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIView *_headView;
    NSMutableArray *_dataArray;
    UITableView *_myTableView;
    NSInteger _currentPage;
    NSString *_pageCount;
}
@end

@implementation SistemMessageController

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
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"successSend" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    
    _headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:_headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"系统消息";
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
    [self prepareData];

}
-(void)prepareData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/msg/getSystemMsgs",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:[NSString stringWithFormat:@"%ld",_currentPage] forKey:@"pageNow"];
    [messageDic setObject:@"10" forKey:@"pageSize"];
    NSLog(@"%@",messageDic);
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *array = dataDic[@"msgs"];
        _pageCount = [NSString stringWithFormat:@"%@",dataDic[@"pageCount"]];
        for(NSDictionary *dic in array){
            SistemMessage *model = [SistemMessage new];
            model.date = dic[@"date"];
            model.msgid = [NSString stringWithFormat:@"%@",dic[@"msgid"]];
            model.show_time = [NSString stringWithFormat:@"%@",dic[@"""show_time"""]];
            model.time = dic[@"time"];
            model.message = dic[@"message"];
            
            [_dataArray addObject:model];
        }
        [self createTableView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)createTableView
{
    NSLog(@"%lf",WIN_WIDTH);
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT-64)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_dataArray removeAllObjects];
        _currentPage = 1;
        [self getData];
    }];
//    [_myTableView.mj_header beginRefreshing];
//    _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        _currentPage++;
//        [self upShuaXin];
//        
//    }];
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"无更多数据" forState:MJRefreshStateIdle];
    _myTableView.mj_footer = footer;
}

-(void)loadMoreData
{
    _currentPage++;
    [self upShuaXin];
}
-(void)getData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/msg/getSystemMsgs",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:[NSString stringWithFormat:@"%ld",_currentPage] forKey:@"pageNow"];
    [messageDic setObject:@"10" forKey:@"pageSize"];
    NSLog(@"%@",messageDic);
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *array = dataDic[@"msgs"];
        for(NSDictionary *dic in array){
            SistemMessage *model = [SistemMessage new];
            model.date = dic[@"date"];
            model.msgid = [NSString stringWithFormat:@"%@",dic[@"msgid"]];
            model.show_time = [NSString stringWithFormat:@"%@",dic[@"""show_time"""]];
            model.time = dic[@"time"];
            model.message = dic[@"message"];
            [_dataArray addObject:model];
        }
        [_myTableView reloadData];
        [_myTableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

-(void)upShuaXin
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/msg/getSystemMsgs",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:[NSString stringWithFormat:@"%ld",_currentPage] forKey:@"pageNow"];
    [messageDic setObject:@"10" forKey:@"pageSize"];
    NSLog(@"%@",messageDic);
    if(_currentPage > _pageCount.integerValue){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_myTableView.mj_footer endRefreshing];
        
        
    }else{
        
        [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSDictionary *dataDic = responseObject[@"data"];
            NSArray *array = dataDic[@"msgs"];
            for(NSDictionary *dic in array){
                SistemMessage *model = [SistemMessage new];
                model.date = dic[@"date"];
                model.msgid = [NSString stringWithFormat:@"%@",dic[@"msgid"]];
                model.show_time = [NSString stringWithFormat:@"%@",dic[@"""show_time"""]];
                model.time = dic[@"time"];
                model.message = dic[@"message"];
                [_dataArray addObject:model];
            }
            [_myTableView reloadData];
            [_myTableView.mj_footer endRefreshing];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];

    }
    
}
#pragma mark- tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SistemMessage *model = _dataArray[indexPath.row];
    CGSize messageSize = [self sizeWithText:model.message font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 44];
    return  messageSize.height + 116 - 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = @"cell";
    SistemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell ==  nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SistemMessageCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshData
{
    [_myTableView removeFromSuperview];
    [_dataArray removeAllObjects];
    [self prepareData];
}
@end

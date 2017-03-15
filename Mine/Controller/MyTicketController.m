//
//  MyTicketController.m
//  SCCBBS
//
//  Created by co188 on 16/11/16.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "MyTicketController.h"
#import "SCCHeader.h"
#import "SCCAFnetTool.h"
#import "MessageTool.h"
#import <MBProgressHUD.h>
#import "tools.h"
#import "MyCallBackModel.h"
#import "MyCallBackCell.h"
#import <MJRefresh.h>
#import "SCCBackView.h"
#import "DetailViewController.h"

@interface MyTicketController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIView *_headView;
    NSMutableArray *_dataArray;
    UITableView *_myTableView;
    NSInteger _currentPage;
    SCCBackView *_backView;
}


@end

@implementation MyTicketController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    
    _headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:_headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"我的帖子";
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
    
    // Do any additional setup after loading the view.
}

-(void)prepareData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = MYTIZHI;
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:@"1" forKey:@"page"];
    NSLog(@"%@",messageDic);
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            id obj = responseObject[@"data"];
            if([obj isKindOfClass:[NSArray class]]){
                NSArray *dataArray = responseObject[@"data"];
                for(NSDictionary *dic in dataArray){
                    MyCallBackModel *model = [MyCallBackModel new];
                    model.lastpost = [NSString stringWithFormat:@"%@",dic[@"lastpost"]];
                    model.lastposter = [NSString stringWithFormat:@"%@",dic[@"lastposter"]];
                    model.subject = dic[@"subject"];
                    model.tid = dic[@"tid"];
                    [_dataArray addObject:model];
                }
                [self createTableView];
            }else{
                _backView = [[SCCBackView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64)];
                _backView.message = @"亲，还没发布任何帖子哦！";
                [self.view addSubview:_backView];
            }
        }else{
            [tools alert:responseObject[@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

-(void)createTableView
{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
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
    NSString *urlString = MYTIZHI;
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:@"1" forKey:@"page"];
    NSLog(@"%@",messageDic);
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSArray *dataArray = responseObject[@"data"];
            for(NSDictionary *dic in dataArray){
                MyCallBackModel *model = [MyCallBackModel new];
                model.lastpost = [NSString stringWithFormat:@"%@",dic[@"lastpost"]];
                model.lastposter = [NSString stringWithFormat:@"%@",dic[@"lastposter"]];
                model.subject = dic[@"subject"];
                model.tid = dic[@"tid"];
                [_dataArray addObject:model];
            }
            [_myTableView reloadData];
        }else{
            [tools alert:responseObject[@"msg"]];
        }
        [_myTableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

-(void)upShuaXin
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = MYTIZHI;
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:[NSString stringWithFormat:@"%ld",_currentPage] forKey:@"page"];
    NSLog(@"%@",messageDic);
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            id  objc = responseObject[@"data"];
            if([objc isKindOfClass:[NSArray class]]){
                NSArray *dataArray = responseObject[@"data"];
                for(NSDictionary *dic in dataArray){
                    MyCallBackModel *model = [MyCallBackModel new];
                    model.lastpost = [NSString stringWithFormat:@"%@",dic[@"lastpost"]];
                    model.lastposter = [NSString stringWithFormat:@"%@",dic[@"lastposter"]];
                    model.subject = dic[@"subject"];
                    model.tid = dic[@"tid"];
                    [_dataArray addObject:model];
                }
                [_myTableView reloadData];
            }
        }else{
            [tools alert:responseObject[@"msg"]];
        }
        [_myTableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
#pragma mark- tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCallBackModel *model = _dataArray[indexPath.row];
    CGSize messageSize = [self sizeWithText:model.subject font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 24];
    CGSize common = [self sizeWithText:@"www" font:[UIFont systemFontOfSize:18] maxW:1000];
    if(messageSize.height / common.height > 2){
        return 80 + common.height * 2 + 3;
    }else{
        return 80 + messageSize.height + 3;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = @"cell";
    MyCallBackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell ==  nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCallBackCell" owner:self options:nil] firstObject];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyCallBackModel *model = _dataArray[indexPath.row];
    DetailViewController *vc = [DetailViewController new];
    vc.tid = model.tid;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

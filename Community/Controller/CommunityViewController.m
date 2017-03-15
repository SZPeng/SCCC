//
//  CommunityViewController.m
//  SCCBBS
//
//  Created by co188 on 16/10/31.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "CommunityViewController.h"
#import "SCCHeader.h"
#import "SCCAFnetTool.h"
#import "leftModel.h"
#import "SecTableViewCell.h"
#import "MessageTool.h"
#import "BodyModel.h"
#import "BodyTableViewCell.h"
#import "EnterViewController.h"
#import <MBProgressHUD.h>
#import "CommunityDetailController.h"

@interface CommunityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_label;
    UIButton *_rightBtn;
    UITableView *_littleTab;
    UITableView *_bigTab;
    NSMutableArray *_leftArray;
    NSMutableArray *_rightArray;
    NSIndexPath *_index;
    NSIndexPath *_leftIndex;
    NSInteger _isFirst;
    NSIndexPath *_backIndex;
    NSIndexPath *_bigIndex;
}
@end

@implementation CommunityViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _leftArray = [NSMutableArray new];
        _rightArray = [NSMutableArray new];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(favAction) name:@"favAction" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFav) name:@"changeFav" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enter) name:@"enter" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(choiceSend:)name:@"choiceSend"object:nil];
    _isFirst = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 40)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"土木在线";
    _label.textAlignment = NSTextAlignmentCenter;
    
    _label.font = [UIFont systemFontOfSize:18];//[UIFont fontWithName:@"STHeitiTC-Light" size:20];
    _label.textColor = [UIColor whiteColor];
    _label.center = CGPointMake(headView.center.x, _label.center.y);
    [headView addSubview:_label];
    
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 33, 28, 22, 22)];
    [_rightBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    [headView addSubview:_rightBtn];
    [self prepareData];
}

-(void)enter
{
    _isFirst = 0;
    [_littleTab removeFromSuperview];
    [_bigTab removeFromSuperview];
    [_leftArray removeAllObjects];
    [_rightArray removeAllObjects];
    [self prepareData];
}

-(void)prepareData
{
    NSString *urlString = COMMUNITY;
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    [afTool getMessage:urlString useDictonary:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *dataArray = responseObject[@"data"];
        for(NSDictionary *dic in dataArray){
            leftModel *model = [leftModel new];
            model.fid = [NSString stringWithFormat:@"%@",dic[@"fid"]];
            model.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
            model.todayposts = [NSString stringWithFormat:@"%@",dic[@"todayposts"]];
            [_leftArray addObject:model];
        }
        [_littleTab reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    [self createTable];
}

-(void)createTable
{
    _littleTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH *0.26, WIN_HEIGHT - 113)];
    _littleTab.tag = 10;
    _littleTab.delegate = self;
    _littleTab.dataSource = self;
    _littleTab.showsHorizontalScrollIndicator = NO;
    _littleTab.showsVerticalScrollIndicator = NO;
    _littleTab.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    _littleTab.tableFooterView = [UIView new];
    [self.view addSubview:_littleTab];
    [self createBig];
}

-(void)createBig
{
    _bigTab = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_littleTab.frame), 64, WIN_WIDTH *0.74, WIN_HEIGHT - 113)];
    _bigTab.tag = 100;
    _bigTab.delegate = self;
    //取消cell之间的线
    _bigTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bigTab.dataSource = self;
    _bigTab.showsVerticalScrollIndicator = NO;
    _bigTab.showsHorizontalScrollIndicator = NO;
    _bigTab.tableFooterView = [UIView new];
    [self.view addSubview:_bigTab];
}
//去掉cell线的15像素
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 10){
       return _leftArray.count;
    }else{
        return _rightArray.count;
    }
}
#pragma mark 代理数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 10){
        static NSString *identifer=@"detacell";
        SecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        cell.backgroundColor = CELLBAC;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SecTableViewCell" owner:self options:nil] firstObject];
            cell.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
            UIView *view = [[UIView alloc]initWithFrame:cell.frame];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 3, 50.5)];
            lab.backgroundColor = TMHEADCOLO;
            [view addSubview:lab];
            cell.selectedBackgroundView = view;
            cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        }
        if (indexPath.row == 0) {
            if(_isFirst == 0){
                cell.index = 0;
                _index = indexPath;
                _leftIndex = indexPath;
                [_littleTab selectRowAtIndexPath:indexPath animated:YES scrollPosition: UITableViewScrollPositionNone];
                [self tableView:_littleTab didSelectRowAtIndexPath:indexPath];
                _isFirst++;
                
            }else{
                cell.index = 1;
            }
        }else{
            cell.index = 2;

        }
        cell.model =  _leftArray[indexPath.row];
        return cell;
    }else{
        static NSString *identifer=@"cell";
        BodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BodyTableViewCell" owner:self options:nil] firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.vc = self;
        cell.model =  _rightArray[indexPath.row];
        [cell setCallBack:^{
            EnterViewController *vc = [EnterViewController new];
            [self presentViewController:vc animated:YES completion:nil];
        }];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 10){
        [_rightArray removeAllObjects];
        SecTableViewCell *cell1 = [_littleTab cellForRowAtIndexPath:_index];
        cell1.SecLabel.textColor = A888;
        cell1.lineLab.hidden = NO;
        SecTableViewCell *cell = [_littleTab cellForRowAtIndexPath:indexPath];
        cell.SecLabel.textColor = TMHEADCOLO;
        cell.lineLab.hidden = YES;
        _index = indexPath;
        NSString *urlString =[NSString stringWithFormat:@"%@%@",PHPHOST,@"forum"];
        NSString *ticket = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDAnimationFade;
        if(ticket.length >0){
            SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
            leftModel *model = _leftArray[indexPath.row];
            NSMutableDictionary *messageDic = [MessageTool getMessage];
            NSLog(@"%@",model.fid);
            [messageDic setObject:model.fid forKey:@"fid"];
            NSLog(@"%@",messageDic);
            [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                NSArray *dataArray = responseObject[@"data"];
                NSLog(@"%@",responseObject[@"msg"]);
                for(NSDictionary *dic in dataArray){
                    BodyModel *model = [BodyModel new];
                    model.fid = [NSString stringWithFormat:@"%@",dic[@"fid"]];
                    model.collected = [NSString stringWithFormat:@"%@",dic[@"collected"]];
                    model.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                    model.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
                    model.todayposts = [NSString stringWithFormat:@"%@",dic[@"todayposts"]];
                    [_rightArray addObject:model];
                }
                [_bigTab reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }else{
            SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
            leftModel *model = _leftArray[indexPath.row];
            NSDictionary *dic = @{@"fid":model.fid};
            [afTool getMessage:urlString useDictonary:dic progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                NSArray *dataArray = responseObject[@"data"];
                for(NSDictionary *dic in dataArray){
                    BodyModel *model = [BodyModel new];
                    model.fid = [NSString stringWithFormat:@"%@",dic[@"fid"]];
                    model.collected = [NSString stringWithFormat:@"%@",dic[@"collected"]];
                    model.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                    model.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
                    model.todayposts = [NSString stringWithFormat:@"%@",dic[@"todayposts"]];
                    [_rightArray addObject:model];
                }
                [_bigTab reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }
    }else{
//        BodyTableViewCell *cell1 = [_bigTab cellForRowAtIndexPath:_bigIndex];
//        cell1.titleLab.textColor = A333;
//        
//        BodyTableViewCell *cell2 = [_bigTab cellForRowAtIndexPath:indexPath];
//        cell2.titleLab.textColor = [UIColor grayColor];
//        _bigIndex = indexPath;
        CommunityDetailController *vc = [CommunityDetailController new];
        BodyModel *model  = _rightArray[indexPath.row];
        vc.fid = model.fid;
        vc.nameTitle = model.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)prePareRightData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString =[NSString stringWithFormat:@"%@%@",PHPHOST,@"forum"];
    NSString *ticket = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(ticket.length > 0){
        SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
        leftModel *model = [_leftArray firstObject];
        NSMutableDictionary *messageDic = [MessageTool getMessage];
        NSLog(@"%@",model.fid);
        [messageDic setObject:model.fid forKey:@"fid"];
        NSLog(@"%@",messageDic);
        [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSArray *dataArray = responseObject[@"data"];
            NSLog(@"%@",responseObject[@"msg"]);
            for(NSDictionary *dic in dataArray){
                BodyModel *model = [BodyModel new];
                model.fid = [NSString stringWithFormat:@"%@",dic[@"fid"]];
                model.collected = [NSString stringWithFormat:@"%@",dic[@"collected"]];
                model.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                model.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
                model.todayposts = [NSString stringWithFormat:@"%@",dic[@"todayposts"]];
                [_rightArray addObject:model];
            }
            [_bigTab reloadData];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else{
        SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
        [afTool getMessage:urlString useDictonary:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSArray *dataArray = responseObject[@"data"];
            for(NSDictionary *dic in dataArray){
                BodyModel *model = [BodyModel new];
                model.fid = [NSString stringWithFormat:@"%@",dic[@"fid"]];
                model.collected = [NSString stringWithFormat:@"%@",dic[@"collected"]];
                model.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                model.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
                model.todayposts = [NSString stringWithFormat:@"%@",dic[@"todayposts"]];
                [_rightArray addObject:model];
            }
            [_bigTab reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}
#pragma mark- tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 10){
        return 50;
    } else {
        return 75;
    }
}

- (void)choiceSend:(NSNotification *)noti{
    [_rightArray removeAllObjects];
    _isFirst = 2;
    [_littleTab deselectRowAtIndexPath:_index animated:YES];
    NSString *str = noti.userInfo[@"text"];
    NSLog(@"%@",str);
    for (int i = 0;i<_leftArray.count;i++){
        leftModel *model = _leftArray[i];
        NSLog(@"%@",model.fid);
        if([str isEqualToString:model.fid]){
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            [_littleTab selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            _backIndex = indexPath;
            [self tableView:_littleTab didSelectRowAtIndexPath:indexPath];
        }
    }
}

-(void)favAction
{
    [_littleTab selectRowAtIndexPath:_index animated:NO scrollPosition:UITableViewScrollPositionNone];
    _backIndex = _index;
    [self tableView:_littleTab didSelectRowAtIndexPath:_index];
}

-(void)changeFav
{
    [_littleTab selectRowAtIndexPath:_index animated:NO scrollPosition:UITableViewScrollPositionNone];
    _backIndex = _index;
    [self tableView:_littleTab didSelectRowAtIndexPath:_index];
}
@end

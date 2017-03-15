//
//  FitViewController.m
//  SCCBBS
//
//  Created by co188 on 16/11/10.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "FitViewController.h"
#import "SCCHeader.h"
#import "NSFileManager+FileSize.h"
#import "tools.h"
#import "AboutUsViewController.h"
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>
@interface FitViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_label;
    UIButton *_leftBtn;
    UITableView *_myTableView;
    NSString *_fileSize;
}
@end

@implementation FitViewController

-(HistoryTable *)tableObj{
    if (_tableObj) {
        return _tableObj;
    }
    _tableObj = [[HistoryTable alloc]init];
    return _tableObj;
}

-(ConsultationTable *)table{
    if (_table) {
        return _table;
    }
    _table = [[ConsultationTable alloc] init];
    return _table;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//     _fileSize = [NSString stringWithFormat:@"%.2fM",[NSFileManager getFileSizeForDir:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/com.hackemist.SDWebImageCache.default"]]];
    NSInteger size  = [[SDImageCache sharedImageCache] getSize]/1000.0/1000.0;
    _fileSize = [NSString stringWithFormat:@"%ld M",size];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"设置";
    _label.textAlignment = NSTextAlignmentCenter;
    
    _label.font = [UIFont systemFontOfSize:18];
    _label.textColor = [UIColor whiteColor];
    _label.center = CGPointMake(headView.center.x, _label.center.y);
    [headView addSubview:_label];
    
    _leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 0, 40, 44)];
    _leftBtn.imageEdgeInsets=UIEdgeInsetsMake(10, 6, 9, 15);
    [_leftBtn setImage:[UIImage imageNamed:@"back"]  forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.center = CGPointMake(_leftBtn.center.x, _label.center.y);
    [headView addSubview:_leftBtn];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = Af4f5f9;
    [self.view addSubview:_myTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 150, 53)];
    label.tag = 200;
    label.font =  [UIFont systemFontOfSize:18];
    [cell addSubview:label];
    UILabel *detailLab = [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH - 150, 0, 135, 53)];
    detailLab.tag = 300;
    detailLab.textAlignment = NSTextAlignmentRight;
    detailLab.font = [UIFont systemFontOfSize:15];
    detailLab.textColor = A666;
    [cell addSubview:detailLab];
    detailLab.hidden = YES;
    UILabel *lab = (UILabel *)[cell viewWithTag:200];
    lab.textColor = A333;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.section == 0){
        lab.text = @"清除缓存";
        cell.accessoryType = UITableViewCellAccessoryNone;
        detailLab.text = _fileSize;
        detailLab.hidden = NO;
//        cell.detailTextLabel.text = _fileSize;
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }else if(indexPath.section == 1){
        lab.text = @"关于我们";
    }
    return cell;
}

#pragma mark-tableView代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1){
        return 94;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 94)];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 41)];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 0.5)];
    line.backgroundColor = Ae1e2e6;
    [backView addSubview:line];

    backView.backgroundColor = Af4f5f9;
    [footView addSubview:backView];
    
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 40.5, WIN_WIDTH, 0.5)];
    lineLab.backgroundColor = Ae1e2e6;
    [backView addSubview:lineLab];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame), WIN_WIDTH, 53)];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn addTarget:self action:@selector(deleteEnter) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:A008cee forState:UIControlStateNormal];
    [footView addSubview:btn];
    
    UILabel *lineLab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 52.5, WIN_WIDTH, 0.5)];
    lineLab1.backgroundColor = Ae1e2e6;
    [btn addSubview:lineLab1];
    return footView;
}

-(void)deleteEnter{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"stime"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"susername"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"sticket"];
    [self backClick];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteEnter" object:nil];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 20)];
    if(section > 0){
        UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 0.5)];
        lineLab.backgroundColor = Ae1e2e6;
        [headView addSubview:lineLab];
    }
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 19.5, WIN_WIDTH, 0.5)];
    lineLab.backgroundColor = Ae1e2e6;
    [headView addSubview:lineLab];
    headView.backgroundColor = Af4f5f9;
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/com.hackemist.SDWebImageCache.default"] error:nil];
        _fileSize=@"0M";
        [self.tableObj deleteWithWhere:nil];
        [self.table deleteWithWhere:nil];
        [_myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [tools alert:@"清除缓存成功"];
    }else if(indexPath.section == 1){
        AboutUsViewController *vc = [AboutUsViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

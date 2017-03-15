//
//  SearchViewController.m
//  SCCBBS
//
//  Created by co188 on 16/11/23.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "SearchViewController.h"
#import "SCCHeader.h"
#import "SCCBackView.h"
#import "SCCAFnetTool.h"
#import <MBProgressHUD.h>
#import "MessageTool.h"
#import "tools.h"
#import "SearchModle.h"
#import "SearchCell.h"
#import <MJRefresh.h>
#import "DetailViewController.h"
@interface SearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_searchArray;
    UIView *_headView;
    UIButton *_rightBtn;
    UIView *_searchView;
    UITextField *_label;
    UITableView *_searchTabview;
    UITableView *_resultTable;
    SCCBackView *_backView;
    NSString *_isSearch;
    NSInteger _currentPage;
}
@end

@implementation SearchViewController

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
        _searchArray = [NSMutableArray new];
        _dataArray = [NSMutableArray new];
        _isSearch = @"1";
        _currentPage = 1;
        NSArray *result = [self.table selectAll];
        if(result.count > 10){
            for(int i = 0;i<result.count;i++){
                if(i > result.count - 10){
                    [_searchArray addObject:result[i]];
                }
            }
        }else{
            _searchArray = [NSMutableArray arrayWithArray:result];
        }
    }
    return self;
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

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 64)];
    _headView.backgroundColor = TMHEADCOLO;
    
    _searchView = [[UIView alloc]initWithFrame:CGRectMake(12, 24,  WIN_WIDTH/5 * 4, 32)];
    _searchView.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:_searchView];
    _searchView.layer.cornerRadius = 5;
    _searchView.clipsToBounds = YES;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 8, 14, 16)];
    imageView.image = [UIImage imageNamed:@"search-1"];
    [_searchView addSubview:imageView];
    
    _label = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 7, _searchView.frame.size.width - CGRectGetMaxX(imageView.frame) - 10 , 20)];
    _label.placeholder = @"请输入搜索关键词";
    _label.delegate = self;
    _label.returnKeyType = UIReturnKeySearch;
    _label.font = [UIFont systemFontOfSize:16];
    _label.textColor = A999;
    [_searchView addSubview:_label];
    
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 50, 24, 40, 30)];
    [_rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_rightBtn addTarget: self action:@selector(quXiao) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_rightBtn];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 63.5, WIN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    [_headView addSubview:line];
    [self.view addSubview:_headView];
    [self createUI];
    
}

-(void)createUI
{
    [_searchTabview removeFromSuperview];
    [_backView removeFromSuperview];
    if(_searchArray.count > 0){
        _searchTabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64)];
        _searchTabview.tag = 10;
        _searchTabview.delegate = self;
        _searchTabview.dataSource = self;
        [self.view addSubview:_searchTabview];
        if([_isSearch isEqualToString:@"1"]){
            _searchTabview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }else{
            _searchTabview.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        _searchTabview.tableFooterView = [UIView new];
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [footer setTitle:@"无更多数据" forState:MJRefreshStateIdle];
        _searchTabview.mj_footer = footer;
        
    }else{
        _backView = [[SCCBackView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64)];
        _backView.message = @"亲，还未有搜索哦";
        [self.view addSubview:_backView];
    }
}

-(void)createTable
{
    _isSearch = @"0";
    [_searchTabview reloadData];
}
#pragma mark-tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([_isSearch isEqualToString:@"1"])
    {
        return _searchArray.count;
    }else{
        return _dataArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_isSearch isEqualToString:@"1"]){
        return 45;
    }else{
        SearchModle *model = _dataArray[indexPath.row];
        CGSize mHeight = [self sizeWithText:model.subject font:[UIFont systemFontOfSize:17] maxW:WIN_WIDTH - 24];
        CGSize TwoSize = [self sizeWithText:@"uuu" font:[UIFont systemFontOfSize:17]];
        if(mHeight.height / TwoSize.height > 2){
            return  TwoSize.height * 2 + 56;
        }else{
            return  mHeight.height + 56;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if([_isSearch isEqualToString:@"1"]){
        return 62;
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([_isSearch isEqualToString:@"1"]){
        return 0;
    }else{
        return 54;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 54)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 17, WIN_WIDTH - 24, 20)];
    label.text = [NSString stringWithFormat:@"与\"%@\"相关的帖子",_label.text];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = A666;
    [headView addSubview:label];
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 53.5, WIN_WIDTH, 0.5)];
    lineLab.backgroundColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.91f alpha:1.00f];
    [headView addSubview:lineLab];
    return headView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 62)];
    UIImageView *imgVew = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH *0.26, 30, 22, 22)];
    imgVew.image = [UIImage imageNamed:@"lajitong"];
    [view addSubview:imgVew];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, WIN_WIDTH - 15, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.80f alpha:1.00f];
    [view addSubview:line];
    UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgVew.frame) + 8, 30, 150, 22)];
    labe.text = @"清除所有搜索记录";
    labe.textColor = A999;
    labe.font = [UIFont systemFontOfSize:18];
    labe.textAlignment = NSTextAlignmentLeft;
    [view addSubview:labe];
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delegate)];
    [view addGestureRecognizer:tap];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_isSearch isEqualToString:@"1"]){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = A999;
        NSDictionary *dic = _searchArray[(_searchArray.count - 1)-indexPath.row];
        NSString *name = dic[@"name"];
        cell.textLabel.text = name;
        return cell;
    }else{
        NSString *cellid = @"cellid";
        SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(cell ==  nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil] firstObject];
        }
        cell.model = _dataArray[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_label resignFirstResponder];
    if([_isSearch isEqualToString:@"1"]){
        NSDictionary *dic = _searchArray[(_searchArray.count - 1)-indexPath.row];
        _label.text = dic[@"name"];
        _searchTabview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self getBodyData:_label.text];
        
    }else{
        SearchModle *model = _dataArray[indexPath.row];
        DetailViewController *vc = [DetailViewController new];
        vc.tid = model.tid;
        NSLog(@"%@",model.tid);
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark-UITextDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    [_searchTabview removeFromSuperview];
    [_dataArray removeAllObjects];
    _isSearch = @"1";
    [self createUI];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_searchTabview removeFromSuperview];
    NSArray *result = [self.table selectAll];
    [_searchArray removeAllObjects];
    if(result.count > 10){
        for(int i = 0;i<result.count;i++){
            if(i > result.count - 10){
                [_searchArray addObject:result[i]];
            }
        }
    }else{
        _searchArray = [NSMutableArray arrayWithArray:result];
    }
    NSLog(@"%@",result);
    NSLog(@"%@",_searchArray);
    [self createUI];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.text.length > 0){
        NSDictionary *data = @{
                               @"name":textField.text
                               };
        [self.table addFields:data];
        [_label resignFirstResponder];
        _searchTabview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self getBodyData:textField.text];

    }else{
        [tools alert:@"请输入关键词"];
    }
    return YES;
}

-(void)getBodyData:(NSString *)string
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = @"https://app.co188.com/search/apigateway/thread";
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    NSString *str = [_label.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [messageDic setObject:str forKey:@"word"];
    [messageDic setObject:@"0" forKey:@"fid"];
    [messageDic setObject:@"1" forKey:@"pageNow"];
    [messageDic setObject:@"20" forKey:@"pageSize"];
    [messageDic setObject:@"utf-8" forKey:@"charset"];
    [messageDic setObject:VERSION forKey:@"version"];
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dic = responseObject[@"data"];
            NSArray *threadsArr = dic[@"threads"];
            if(threadsArr.count > 0){
                [_backView removeFromSuperview];
                for(NSDictionary *dict in threadsArr){
                    SearchModle *model = [SearchModle new];
                    model.author = [NSString stringWithFormat:@"%@",dict[@"author"]];
                    model.fid = [NSString stringWithFormat:@"%@",dict[@"fid"]];
                    model.forumname = [NSString stringWithFormat:@"%@",dict[@"forumname"]];
                    model.subject = [NSString stringWithFormat:@"%@",dict[@"subject"]];
                    model.tid = [NSString stringWithFormat:@"%@",dict[@"tid"]];
                    model.time = [NSString stringWithFormat:@"%@",dict[@"time"]];
                    [_dataArray addObject:model];
                }
                [self createTable];
            }else{
                _backView = [[SCCBackView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64)];
                _backView.backgroundColor = [UIColor whiteColor];
                _backView.message = @"亲，没有搜到相关帖子";
                [self.view addSubview:_backView];
            }
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
#pragma mark-加载更多数据
-(void)loadMoreData
{
    _currentPage++;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = @"https://app.co188.com/search/apigateway/thread";
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    NSString *str = [_label.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [messageDic setObject:str forKey:@"word"];
    [messageDic setObject:@"0" forKey:@"fid"];
    [messageDic setObject:[NSString stringWithFormat:@"%ld",_currentPage] forKey:@"pageNow"];
    [messageDic setObject:@"20" forKey:@"pageSize"];
    [messageDic setObject:@"utf-8" forKey:@"charset"];
    [messageDic setObject:VERSION forKey:@"version"];
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [_searchTabview.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dic = responseObject[@"data"];
            NSArray *threadsArr = dic[@"threads"];
            if(threadsArr.count > 0){
                [_backView removeFromSuperview];
                for(NSDictionary *dict in threadsArr){
                    SearchModle *model = [SearchModle new];
                    model.author = [NSString stringWithFormat:@"%@",dict[@"author"]];
                    model.fid = [NSString stringWithFormat:@"%@",dict[@"fid"]];
                    model.forumname = [NSString stringWithFormat:@"%@",dict[@"forumname"]];
                    model.subject = [NSString stringWithFormat:@"%@",dict[@"subject"]];
                    model.tid = [NSString stringWithFormat:@"%@",dict[@"tid"]];
                    model.time = [NSString stringWithFormat:@"%@",dict[@"time"]];
                    [_dataArray addObject:model];
                }
                [_searchTabview reloadData];
            }
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

-(void)quXiao
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)delegate
{
    [_searchTabview removeFromSuperview];
    [self.table deleteWithWhere:nil];
    _searchArray = [NSMutableArray new];
    _dataArray = [NSMutableArray new];
    NSArray *result = [self.table selectAll];
    if(result.count > 10){
        for(int i = 0;i<result.count;i++){
            if(i > result.count - 10){
                [_searchArray addObject:result[i]];
            }
        }
    }else{
        _searchArray = [NSMutableArray arrayWithArray:result];
    }
    [self createUI];
}
@end

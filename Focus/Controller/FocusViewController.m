//
//  FocusViewController.m
//  SCCBBS
//
//  Created by co188 on 16/10/27.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "FocusViewController.h"
#import "SCCHeader.h"
#import "SCCAFnetTool.h"
#import <MBProgressHUD.h>
#import "MessageTool.h"
#import "tools.h"
#import "MyCallBackModel.h"
#import "MyFavouriteCell.h"
#import "BodyModel.h"
#import "BodyTableViewCell.h"
#import <MJRefresh.h>
#import "EnterViewController.h"
#import "SCCBackView.h"
#import "DetailViewController.h"
#import "CommunityDetailController.h"
#import "ListModel.h"
#import "FPictrureCell.h"

@interface FocusViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_label;
    UIButton *_rightBtn;
    UIView *_coverView;
    NSMutableArray *_dataArray;
    UITableView *_myTableView;
    NSInteger _page;
    NSInteger _currentPage;
    NSString *_messageTitle;
    SCCBackView *_backView;
    UIView *_bodyView;
}
@end

@implementation FocusViewController

-(void)viewWillDisappear:(BOOL)animated
{
    
}
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

-(HistoryTable *)table{
    if (_table) {
        return _table;
    }
    _table = [[HistoryTable alloc]init];
    return _table;
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAction) name:@"guanZhu" object:nil];
    //enter
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterAction) name:@"enter" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteEnter) name:@"deleteEnter" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 40)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"关注";
    _label.textAlignment = NSTextAlignmentCenter;
    
    _label.font = [UIFont systemFontOfSize:18];
    _label.textColor = [UIColor whiteColor];
    _label.center = CGPointMake(headView.center.x, _label.center.y);
    [headView addSubview:_label];
    
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 33, 28, 22, 22)];
    [_rightBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    [_rightBtn addTarget: self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
//    [headView addSubview:_rightBtn];
//    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
//    if(str.length > 0){
//        //        [self.navigationController pushViewController:[EnterViewController new] animated:YES];
//        [_bodyView removeFromSuperview];
//        [self createUI];
//    }else{
//        [self refreshAction];
//    }
    [self refreshAction];
}
-(void)refreshAction
{
    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(str.length > 0){
        [_bodyView removeFromSuperview];
        
        [self createUI];
//        [_myTableView removeFromSuperview];
//        [_dataArray removeAllObjects];
//        [self createUI];
    }else{
        
        [_bodyView removeFromSuperview];
        _bodyView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64 - 49)];
        [self.view addSubview:_bodyView];
        CGSize textSize = [self sizeWithText:@"这里会显示您的浏览历史及关注的板块／帖子" font:[UIFont systemFontOfSize:16] maxW:WIN_WIDTH - 169];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(169/2, 140, WIN_WIDTH - 169, textSize.height + 5)];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = Ac6c6c6;
        label.numberOfLines = 2;
        label.text = @"这里会显示您的浏览历史及关注的板块／帖子";
        label.textAlignment = NSTextAlignmentCenter;
        [_bodyView addSubview:label];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(103, CGRectGetMaxY(label.frame) + 23, (WIN_WIDTH - 206), 45)];
        btn.backgroundColor = TMHEADCOLO;
        [btn setTitle:@"登陆" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget: self action:@selector(dengLu) forControlEvents:UIControlEventTouchUpInside];
        [_bodyView addSubview:btn];
        
        EnterViewController *vc = [EnterViewController new];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:Nav animated:YES completion:nil];

    }
}

-(void)dengLu
{
    EnterViewController *vc = [EnterViewController new];
    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:Nav animated:YES completion:nil];

}


-(void)enterAction
{
    [_bodyView removeFromSuperview];
    
    [self createUI];
}
-(void)createUI
{
    [_bodyView removeFromSuperview];
    [_coverView removeFromSuperview];
    NSArray *array = @[@"我的足迹",@"我的收藏",@"关注板块"];
    _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, 40)];
    _coverView.backgroundColor = [UIColor whiteColor];
    CGFloat width = WIN_WIDTH / 3;
    for(int i = 0;i< 3;i++){
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(width * i, 0, width, 38.5)];
        btn.tag = i + 10;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:A333 forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickActon:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:A008cee forState:UIControlStateSelected];
        [_coverView addSubview:btn];
        UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(width * i, 38.5, width, 1)];
        lineLab.hidden = YES;
        if(i == 0){
            lineLab.hidden = NO;
            btn.selected = YES;
        }
        lineLab.backgroundColor = A008cee;
        lineLab.tag = i + 100;
        [_coverView addSubview:lineLab];
    }
    [self.view addSubview:_coverView];
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 39.5, WIN_WIDTH, 0.5)];
    lineLab.backgroundColor = Ad6d6d6;
    [_coverView addSubview:lineLab];
    
    UIButton *btn = (UIButton *)[_coverView viewWithTag:10];
    [self clickActon:btn];
}

-(void)clickActon:(UIButton *)button
{
    [_bodyView removeFromSuperview];
    _currentPage = 1;
    [_myTableView removeFromSuperview];
    [_dataArray removeAllObjects];
    for(int i = 0;i < 3;i++){
        UIButton *btn = (UIButton *)[_coverView viewWithTag:i + 10];
        btn.selected = NO;
        UILabel *lab = (UILabel *)[_coverView viewWithTag:i+100];
        lab.hidden = YES;
    }
    button.selected = YES;
    UILabel *lab = (UILabel *)[_coverView viewWithTag:button.tag + 90];
    lab.hidden = NO;
    switch (button.tag) {
        case 10:
            [self prepareData:1];
            _messageTitle = @"还没有浏览过任何帖子";
            break;
        case 11:
            [self prepareData:2];
            _messageTitle = @"还没有收藏的帖子";
            break;
        case 12:
            [self prepareData:3];
            _messageTitle = @"还没有关注板块";
            break;
        default:
            break;
    }
}

-(void)prepareData:(NSInteger)page
{
    [_backView removeFromSuperview];
    _page = page;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString;
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    NSString *name;
    switch (page) {
        case 1:
           name = @"1";
            break;
        case 2:
            urlString = FAVOURITE;
            [messageDic setObject:@"1" forKey:@"page"];
            
            break;
        case 3:
            urlString = BANKUAI;
            
            break;
            
        default:
            break;
    }
    if([name isEqualToString:@"1"]){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *result = [self.table selectAll];
        if(result.count > 0){
            for(int i =0;i<result.count;i++){
                ListModel *model = [ListModel new];
                NSDictionary *dic = result[result.count - 1 - i];
                model.authorid = dic[@"authorid"];
                model.author = dic[@"imgUrl"];
                model.subject = dic[@"titleStr"];
                model.dateline = dic[@"dateline"];
                model.tid = dic[@"tid"];
                model.views = dic[@"numViews"];
                [_dataArray addObject:model];
            }
            [self createTableView];
        }else{
            _backView = [[SCCBackView alloc]initWithFrame:CGRectMake(0, 104, WIN_WIDTH, WIN_HEIGHT - 153)];
            _backView.message = _messageTitle;
            [self.view addSubview:_backView];
        }
        
    }else{
        [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if([code isEqualToString:@"0"]){
                NSArray *array = responseObject[@"data"];
                id objc = responseObject[@"data"];
                if(page == 1){
                    _backView = [[SCCBackView alloc]initWithFrame:CGRectMake(0, 104, WIN_WIDTH, WIN_HEIGHT - 153)];
                    _backView.message = _messageTitle;
                    [self.view addSubview:_backView];
                }else if(page == 2){
                    if([objc isKindOfClass:[NSArray class]]){
                        for(NSDictionary *dic in array){
                            MyCallBackModel *model = [MyCallBackModel new];
                            model.lastpost = [NSString stringWithFormat:@"%@",dic[@"lastpost"]];
                            model.lastposter = [NSString stringWithFormat:@"%@",dic[@"lastposter"]];
                            model.subject = dic[@"subject"];
                            model.tid =  [NSString stringWithFormat:@"%@",dic[@"tid"]];
                            [_dataArray addObject:model];
                        }
                        [self createTableView];
                    }else{
                        _backView = [[SCCBackView alloc]initWithFrame:CGRectMake(0, 104, WIN_WIDTH, WIN_HEIGHT - 153)];
                        _backView.message = _messageTitle;
                        [self.view addSubview:_backView];
                    }
                    
                }else if(page == 3){
                    if([objc isKindOfClass:[NSArray class]]){
                        for(NSDictionary *dic in array){
                            BodyModel *model = [BodyModel new];
                            model.fid = [NSString stringWithFormat:@"%@",dic[@"fid"]];
                            model.collected = [NSString stringWithFormat:@"%@",dic[@"collected"]];
                            model.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                            model.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
                            model.todayposts = [NSString stringWithFormat:@"%@",dic[@"todayposts"]];
                            [_dataArray addObject:model];
                        }
                        [self createTableView];
                    }else {
                        _backView = [[SCCBackView alloc]initWithFrame:CGRectMake(0, 104, WIN_WIDTH, WIN_HEIGHT - 153)];
                        _backView.message = _messageTitle;
                        [self.view addSubview:_backView];
                    }
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
    
}

-(void)createTableView
{
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 40, WIN_WIDTH, WIN_HEIGHT - 64 - 49 - 40)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableFooterView = [UIView new];
    if(_page != 1){
        _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_dataArray removeAllObjects];
            _currentPage = 1;
            [self getData:_page];
        }];
    }
    if(_page == 2){
//        _myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            // 进入刷新状态后会自动调用这个block
//            _currentPage++;
//            [self upShuaXin];
//        }];
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [footer setTitle:@"无更多数据" forState:MJRefreshStateIdle];
        _myTableView.mj_footer = footer;
    }
    [self.view addSubview:_myTableView];
}
-(void)loadMoreData
{
    _currentPage++;
    [self upShuaXin];
}
-(void)getData:(NSInteger)page
{
    _page = page;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString;
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    switch (page) {
        case 1:
            
            break;
        case 2:
            urlString = FAVOURITE;
            [messageDic setObject:@"1" forKey:@"page"];
            
            break;
        case 3:
            urlString = BANKUAI;
            
            break;
            
        default:
            break;
    }
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            id array = responseObject[@"data"];
            if(page == 1){
                
            }else if(page == 2){
                if([array isKindOfClass:[NSArray class]]){
                    for(NSDictionary *dic in array){
                        MyCallBackModel *model = [MyCallBackModel new];
                        model.lastpost = [NSString stringWithFormat:@"%@",dic[@"lastpost"]];
                        model.lastposter = [NSString stringWithFormat:@"%@",dic[@"lastposter"]];
                        model.subject = dic[@"subject"];
                        model.tid =  [NSString stringWithFormat:@"%@",dic[@"tid"]];
                        [_dataArray addObject:model];
                    }
                    [_myTableView reloadData];
                }else{
                    _backView = [[SCCBackView alloc]initWithFrame:CGRectMake(0, 104, WIN_WIDTH, WIN_HEIGHT - 153)];
                    _backView.backgroundColor = [UIColor whiteColor];
                    _backView.message = _messageTitle;
                    [self.view addSubview:_backView];
                }
            }else if(page == 3){
                if([array isKindOfClass:[NSArray class]]){
                    for(NSDictionary *dic in array){
                        BodyModel *model = [BodyModel new];
                        model.fid = [NSString stringWithFormat:@"%@",dic[@"fid"]];
                        model.collected = [NSString stringWithFormat:@"%@",dic[@"collected"]];
                        model.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                        model.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
                        model.todayposts = [NSString stringWithFormat:@"%@",dic[@"todayposts"]];
                        [_dataArray addObject:model];
                    }
                    [_myTableView reloadData];
                }else{
                    _backView = [[SCCBackView alloc]initWithFrame:CGRectMake(0, 104, WIN_WIDTH, WIN_HEIGHT - 153)];
                    _backView.backgroundColor = [UIColor whiteColor];
                    _backView.message = _messageTitle;
                    [self.view addSubview:_backView];

                }
                
            }
            [_myTableView.mj_header endRefreshing];
            
        }else{
            [tools alert:responseObject[@"msg"]];
        }
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
    NSString *urlString;
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    urlString = FAVOURITE;
    [messageDic setObject:[NSString stringWithFormat:@"%ld",_currentPage] forKey:@"page"];
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            id obj = responseObject[@"data"];
            if([obj isKindOfClass:[NSArray class]]){
                NSArray *array = responseObject[@"data"];
                for(NSDictionary *dic in array){
                    MyCallBackModel *model = [MyCallBackModel new];
                    model.lastpost = [NSString stringWithFormat:@"%@",dic[@"lastpost"]];
                    model.lastposter = [NSString stringWithFormat:@"%@",dic[@"lastposter"]];
                    model.subject = dic[@"subject"];
                    model.tid =  [NSString stringWithFormat:@"%@",dic[@"tid"]];
                    [_dataArray addObject:model];
                }
                [_myTableView reloadData];
                [_myTableView.mj_footer endRefreshing];
            }else{
                [_myTableView.mj_footer endRefreshing];
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
#pragma mark-tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_page == 1){
        ListModel *model = _dataArray[indexPath.row];
        CGSize mesSize = [self sizeWithText:model.subject font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 24];
        CGSize mSize = [self sizeWithText:@"sss" font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 24];
        if(mesSize.height / mSize.height > 2){
            return  mSize.height * 2 + 60;
        }else{
            return  mesSize.height + 60;
        }
//        return 93;

    }else if(_page == 2){
        MyCallBackModel *model = _dataArray[indexPath.row];
        CGSize messageSize = [self sizeWithText:model.subject font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 24];
        CGSize common = [self sizeWithText:@"www" font:[UIFont systemFontOfSize:18] maxW:1000];
        if(messageSize.height / common.height > 2){
            return 80 + common.height * 2 + 3;
        }else{
            return 80 + messageSize.height + 3;
        } 
    }else{
        return  75;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = @"cell";
    if(_page == 1){
        NSString *cellid = @"cellID";
        FPictrureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(cell ==  nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FPictrureCell" owner:self options:nil] firstObject];
        }
        cell.model = _dataArray[indexPath.row];
        return cell;

    }else if(_page == 2){
        MyFavouriteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(cell ==  nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyFavouriteCell" owner:self options:nil] firstObject];
        }
        [cell setCallBack:^{
            [_dataArray removeAllObjects];
            [self getData:_page];
        }];
        cell.model = _dataArray[indexPath.row];
        return cell;
    }else {
        BodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(cell ==  nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BodyTableViewCell" owner:self options:nil] firstObject];
           
        }
         cell.name = @"1";
        cell.ViewC = self;
        cell.model = _dataArray[indexPath.row];
        return  cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_page == 1){
        ListModel *model = _dataArray[indexPath.row];
        DetailViewController *vc = [DetailViewController new];
        vc.tid = model.tid;
        vc.titleStr = model.subject;
        vc.imgUrl = model.author;
        vc.authorid = model.authorid;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(_page == 2){
        MyCallBackModel *model = _dataArray[indexPath.row];
        DetailViewController *vc = [DetailViewController new];
        vc.tid = model.tid;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        BodyModel *model = _dataArray[indexPath.row];
        CommunityDetailController *vc = [CommunityDetailController new];
        vc.fid = model.fid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)deleteEnter
{
    [_dataArray removeAllObjects];
    [_myTableView removeFromSuperview];
    [_coverView removeFromSuperview];
    [_backView removeFromSuperview];
    _bodyView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64 - 49)];
    [self.view addSubview:_bodyView];
    CGSize textSize = [self sizeWithText:@"这里会显示您的浏览历史及关注的板块／帖子" font:[UIFont systemFontOfSize:16] maxW:WIN_WIDTH - 169];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(169/2, 140, WIN_WIDTH - 169, textSize.height + 5)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = Ac6c6c6;
    label.numberOfLines = 2;
    label.text = @"这里会显示您的浏览历史及关注的板块／帖子";
    label.textAlignment = NSTextAlignmentCenter;
    [_bodyView addSubview:label];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(103, CGRectGetMaxY(label.frame) + 23, (WIN_WIDTH - 206), 45)];
    btn.backgroundColor = TMHEADCOLO;
    [btn setTitle:@"登陆" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget: self action:@selector(dengLu) forControlEvents:UIControlEventTouchUpInside];
    [_bodyView addSubview:btn];
}

@end

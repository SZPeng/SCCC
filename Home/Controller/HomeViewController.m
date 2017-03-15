//
//  HomeViewController.m
//  SCCBBS
//
//  Created by co188 on 16/10/27.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "HomeViewController.h"
#import "SCCHeader.h"
#import "SDCycleScrollView.h"
#import "SCCAFnetTool.h"
#import "HomeModel.h"
#import "HomeTableViewCell.h"
#import "DetailViewController.h"
#import "SCCPageController.h"
#import <MJRefresh.h>
#import "MessageTool.h"
#import "EveryDayGetController.h"
#import "EnterViewController.h"
#import "SearchViewController.h"
#import "DetailViewController.h"
#import "tools.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{
    UILabel *_label;
    UIButton *_rightBtn;
    UITableView *_tableView;
    NSMutableArray *_photoArray;
    UILabel *_coverLab;
    NSMutableArray *_dataArray;
    SCCPageController *_page;
    NSInteger _currentPage;
    NSMutableArray *_tidArray;
    NSMutableArray *_titleArray;
    
    UIView *_backView;
}
@end

@implementation HomeViewController

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

-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    NSString *name = [[NSUserDefaults standardUserDefaults]valueForKey:@"name"];
    [self getDetailView:name];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticeAction:) name:@"ThisIsANoticafication" object:nil];
    _currentPage = 1;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 40)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"土木在线";
    _label.textAlignment = NSTextAlignmentCenter;
    
    _label.font = [UIFont systemFontOfSize:18];
    _label.textColor = [UIColor whiteColor];
    _label.center = CGPointMake(headView.center.x, _label.center.y);
    [headView addSubview:_label];
    
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 33, 28, 22, 22)];
    [_rightBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [_rightBtn addTarget: self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_rightBtn];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 76, 28, 22, 22)];
    [btn setImage:[UIImage imageNamed:@"sign-in"] forState:UIControlStateNormal];
    [btn addTarget: self action:@selector(qiandao) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:btn];
    [self prepareData];
}

#pragma mark-   签到
-(void)qiandao
{
    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(str.length > 0){
        EveryDayGetController *vc = [EveryDayGetController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        EnterViewController *vc = [EnterViewController new];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:Nav animated:YES completion:nil];
    }
    
}

#pragma mark-搜索
-(void)search
{
    SearchViewController *vc = [SearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray new];
        _photoArray = [NSMutableArray new];
        _titleArray = [[NSMutableArray alloc]init];
        _tidArray = [NSMutableArray new];
    }
    return self;
}
-(void)prepareData
{
//    NSString *urlString = @"https://app.co188.com/bbs/index.php";
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:@"1" forKey:@"page"];
    [afTool getMessage:FIRFTPAGE useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject[@"data"];
        NSArray *array = dic[@"lists"];
        for(NSDictionary *dict in array){
            HomeModel *model = [HomeModel new];
            model.imgsrc = dict[@"imgsrc"];
            model.title = dict[@"title"];
            model.url = dict[@"url"];
            model.tid = [NSString stringWithFormat:@"%@",dict[@"tid"]];
            model.stitle = dict[@"stitle"];
            model.views = dict[@"views"];
            [_dataArray addObject:model];
        }
        NSArray *bannerArray = dic[@"banners"];
        NSLog(@"%@",bannerArray);
        for(NSDictionary *dicT in bannerArray){
            NSString *str = [NSString stringWithFormat:@"%@",dicT[@"imgsrc"]];
            [_photoArray addObject:str];
            NSString *tid = [NSString stringWithFormat:@"%@",dicT[@"tid"]];
            [_tidArray addObject:tid];
            NSString *title = [NSString stringWithFormat:@"%@",dicT[@"title"]];
            [_titleArray addObject:title];
        }
        [self createTableView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64 - 49)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    UIView *pageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 210)];
    pageView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:pageView];
    
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:pageView.frame imageURLStringsGroup:nil]; // 模拟网络延时情景
    cycleScrollView2.tag = 100;
    [cycleScrollView2 setCallBack:^(NSInteger page) {
        _page.currentPage = page;
        _coverLab.text = _titleArray[page];
    }];
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView2.delegate = self;
    cycleScrollView2.num = @"1";
    //        cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.dotColor = TTG; // 自定义分页控件小圆标颜色
    //        cycleScrollView2.placeholderImage = [UIImage imageNamed:@"placeholder"];
    cycleScrollView2.imageURLStringsGroup = _photoArray;
    [pageView addSubview:cycleScrollView2];
    _tableView.tableHeaderView = pageView;
    [self.view addSubview:_tableView];
    
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 179, WIN_WIDTH, 31)];
    coverView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
    [pageView addSubview:coverView];
    _coverLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, coverView.frame.size.width - 90, 20)];
    _coverLab.text = _titleArray[0];
    _coverLab.font = [UIFont systemFontOfSize:14];
    _coverLab.textColor = [UIColor whiteColor];
    [coverView addSubview:_coverLab];
    _page = [[SCCPageController alloc]initWithFrame:CGRectMake(WIN_WIDTH - 80, 5.5, 60, 20)];
    _page.userInteractionEnabled = NO;
    _page.numberOfPages = _photoArray.count;
    
    _page.currentPage = 0;
    [coverView addSubview:_page];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_dataArray removeAllObjects];
        _currentPage = 1;
        [_photoArray removeAllObjects];
        _backView = [[UIView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:_backView];
        [self getData];
    }];
    [_tableView.mj_header beginRefreshing];
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [_photoArray removeAllObjects];
//        _currentPage++;
//        [self upShuaXin];
//    }];
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"无更多数据" forState:MJRefreshStateIdle];
    _tableView.mj_footer = footer;
}

-(void)loadMoreData
{
    [_photoArray removeAllObjects];
    _currentPage++;
    [self upShuaXin];
}

-(void)upShuaXin
{
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:[NSString stringWithFormat:@"%ld",_currentPage] forKey:@"page"];
    [afTool getMessage:FIRFTPAGE useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject[@"data"];
        id  isDic = responseObject[@"data"];
        if([isDic isKindOfClass:[NSDictionary class]]){
            id objc = dic[@"lists"];
            if([objc isKindOfClass:[NSArray class]]){
                NSArray *array = dic[@"lists"];
                for(NSDictionary *dict in array){
                    HomeModel *model = [HomeModel new];
                    model.imgsrc = dict[@"imgsrc"];
                    model.title = dict[@"title"];
                    model.url = dict[@"url"];
                    model.stitle = dict[@"stitle"];
                    model.views = dict[@"views"];
                    model.tid = [NSString stringWithFormat:@"%@",dict[@"tid"]];
                    [_dataArray addObject:model];
                }
                NSArray *bannerArray = dic[@"banners"];
                NSLog(@"%@",bannerArray);
                for(NSDictionary *dicT in bannerArray){
                    NSString *str = [NSString stringWithFormat:@"%@",dicT[@"imgsrc"]];
                    [_photoArray addObject:str];
                }
                [_tableView reloadData];
            }
        }
        [_tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

-(void)getData
{
    
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:@"1" forKey:@"page"];
    [afTool getMessage:FIRFTPAGE useDictonary:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject[@"data"];
        NSArray *array = dic[@"lists"];
        for(NSDictionary *dict in array){
            HomeModel *model = [HomeModel new];
            model.imgsrc = dict[@"imgsrc"];
            model.title = dict[@"title"];
            model.url = dict[@"url"];
            model.stitle = dict[@"stitle"];
            model.views = dict[@"views"];
            model.tid = [NSString stringWithFormat:@"%@",dict[@"tid"]];
            [_dataArray addObject:model];
        }
         [_tableView.mj_header endRefreshing];
        [_backView removeFromSuperview];
        NSArray *bannerArray = dic[@"banners"];
        NSLog(@"%@",bannerArray);
        for(NSDictionary *dicT in bannerArray){
            NSString *str = [NSString stringWithFormat:@"%@",dicT[@"imgsrc"]];
            [_photoArray addObject:str];
        }
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark- tableView代理

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeModel *model = _dataArray[indexPath.row];
    CGSize detailSiz = [self sizeWithText:model.title font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 152];
    CGSize detailSize = [self sizeWithText:@"我的" font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 152];
    CGFloat height = detailSiz.height + 50;
    if(detailSiz.height/detailSize.height > 2){
        height = detailSize.height*2 + 50;
    }else{
        
    }
    if(height > 80){
        
    }else{
        height = 90;
    }
    return height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = @"cell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell ==  nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil] firstObject];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeModel *model = _dataArray[indexPath.row];
    DetailViewController *vc = [DetailViewController new];
    vc.urlString = model.url;
    vc.tid = model.tid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- tableViewdatasource 
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 50)];
    headView.backgroundColor = [UIColor whiteColor];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 15, 17, 20)];
    imgView.image = [UIImage imageNamed:@"hot"];
    imgView.contentMode = UIViewContentModeScaleToFill;
    [headView addSubview:imgView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 8, 15, 200, 20)];
    label.text = @"热文看点";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor blackColor];
    [headView addSubview:label];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 49.5, WIN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.84f green:0.84f blue:0.84f alpha:1.00f];
    [headView addSubview:line];
    return headView;
}

#pragma mark-滚动视图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    DetailViewController *vc = [DetailViewController new];
    vc.tid = _tidArray[index];
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"%ld",index);
}
#pragma mark-推送行为
-(void)noticeAction:(NSNotification *)userInfo
{
    
     NSDictionary * infoDic = [userInfo object];
    [tools alert:infoDic[@"name"]];
    NSLog(@"%@",infoDic);
    NSString *tid = infoDic[@"name"];
    DetailViewController *vc = [DetailViewController new];
    vc.tid = tid;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getDetailView:(NSString *)name
{
    if(name.length > 0){
        DetailViewController *vc = [DetailViewController new];
        vc.tid = name;
        [self.navigationController pushViewController:vc animated:YES];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"name"];
    }
    
}
@end

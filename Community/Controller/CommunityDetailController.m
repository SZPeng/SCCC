//
//  CommunityDetailController.m
//  SCCBBS
//
//  Created by co188 on 16/11/24.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "CommunityDetailController.h"
#import "SCCHeader.h"
#import "tools.h"
#import "SCCAFnetTool.h"
#import "MessageTool.h"
#import <MBProgressHUD.h>
#import "ListModel.h"
#import "StickModel.h"
#import "FPictrureCell.h"
#import "SPictureCell.h"
#import "TPictureCell.h"
#import "imgModel.h"
#import <UIImageView+WebCache.h>
#import "HeadDetailController.h"
#import <MJRefresh.h>
#import "RepliesViewController.h"
#import "FaTieViewController.h"
#import "DetailViewController.h"
#import "WXApi.h"
#import "EnterViewController.h"
#import "MyMessageViewController.h"
#import "EnterViewController.h"

@interface CommunityDetailController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIView *_headView;
    UILabel *_label;
    UIButton *_leftBtn;
    UIButton *_rightBtn;
    NSString *_collected;
    NSString *_nfid;
    NSString *_icon;
    NSString *_name;
    NSString *_todayposts;
    NSMutableArray *_listArray;
    NSMutableArray *_dataArray;
    NSMutableArray *_stickArray;
    UITableView *_myTableView;
    UIView *_backView;
    
    UIButton *_newBack;
    UIButton *_newPost;
    UIButton *_niceBook;
    
    UILabel *_newLabel;
    UILabel *_newPostLabel;
    UILabel *_niceLabel;
    
    NSInteger _page;
    UIButton *_favBtn;
    NSInteger _currentPage;
    
    UIButton *_btn;
    
    NSIndexPath *_bigIndex;
}
@end

@implementation CommunityDetailController

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

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _listArray = [NSMutableArray new];
        _dataArray = [NSMutableArray new];
        _stickArray = [NSMutableArray new];
        _page = 1;
        _currentPage = 1;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(FavAction) name:@"favAction" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(FavAction) name:@"isFavourite" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(FavAction) name:@"huiFu" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    _headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:_headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = _nameTitle;
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
    
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 45, 0, 44, 44)];
    [_rightBtn setImage:[UIImage imageNamed:@"news"]  forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(xiaoxi) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.center = CGPointMake(_rightBtn.center.x, _label.center.y);
    [_headView addSubview:_rightBtn];
    
    [self prepareData];
}

-(void)backClick
{
    if([_type isEqualToString:@"Detail"]){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"choiceSend"object:nil userInfo:@{@"text":_firstId}];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)prepareData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = BANKDT;
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:_fid forKey:@"fid"];
    [messageDic setObject:@"1" forKey:@"page"];
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",responseObject);
        NSDictionary *dataDic = responseObject[@"data"];
        NSDictionary *forumDic = dataDic[@"forum"];
        _collected = [NSString stringWithFormat:@"%@",forumDic[@"collected"]];
        _nfid = [NSString stringWithFormat:@"%@",forumDic[@"fid"]];
        _icon = [NSString stringWithFormat:@"%@",forumDic[@"icon"]];
        _name = [NSString stringWithFormat:@"%@",forumDic[@"name"]];
        _todayposts = [NSString stringWithFormat:@"%@",forumDic[@"todayposts"]];
        NSArray *listA = dataDic[@"list"];
        for(NSDictionary *dict in listA){
            ListModel *model = [ListModel new];
            model.author = [NSString stringWithFormat:@"%@",dict[@"author"]];
            model.authorid = [NSString stringWithFormat:@"%@",dict[@"authorid"]];
            model.dateline = [NSString stringWithFormat:@"%@",dict[@"dateline"]];
            model.collected = [NSString stringWithFormat:@"%@",dict[@"collected"]];
            model.imgnum = [NSString stringWithFormat:@"%@",dict[@"imgnum"]];
            model.subject = [NSString stringWithFormat:@"%@",dict[@"subject"]];
            model.tid = [NSString stringWithFormat:@"%@",dict[@"tid"]];
            model.views = [NSString stringWithFormat:@"%@",dict[@"views"]];
            NSArray *imgs = dict[@"imgs"];
            NSLog(@"pppppp  %@",imgs);
            NSMutableArray *imgArray = [NSMutableArray new];
            if(imgs.count > 0){
                for(NSString *str in imgs){
                    imgModel *model = [imgModel new];
                    model.imgName = str;
                    [imgArray addObject:model];
                }
                model.imgArray = imgArray;
            }
            [_listArray addObject:model];
        }
        NSArray *stickArray = dataDic[@"stick"];
        for(NSDictionary *Dic in stickArray){
            StickModel *model = [StickModel new];
            model.tid = [NSString stringWithFormat:@"%@",Dic[@"tid"]];
            model.authorid = [NSString stringWithFormat:@"%@",Dic[@"authorid"]];
            model.subject = [NSString stringWithFormat:@"%@",Dic[@"subject"]];
            [_stickArray addObject:model];
        }
        [self createTableView];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)createTableView
{
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:_leftBtn.frame];
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    _myTableView.tableFooterView = [UIView new];
    _btn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 67, WIN_HEIGHT - 160, 52, 52)];
    [_btn setBackgroundImage:[UIImage imageNamed:@"post-1"] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(callBackMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"无更多数据" forState:MJRefreshStateIdle];
    _myTableView.mj_footer = footer;
    
    CGFloat height = _stickArray.count * 40;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 128 + height)];
    headView.userInteractionEnabled = YES;
    
    if(height > 0){
        headView.frame = CGRectMake(0, 0, WIN_WIDTH, 128 + height);
    }else{
        headView.frame = CGRectMake(0, 0, WIN_WIDTH, 123 + height);
    }
    headView.backgroundColor = [UIColor whiteColor];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(12, 15, 72.5, 72.5)];
    if(_icon.length > 5){
        [imgV sd_setImageWithURL:[NSURL URLWithString:_icon]];
    }else{
        imgV.image = [UIImage imageNamed:@"145"];
    }
    [headView addSubview:imgV];
    
    _favBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 73, 36.5, 61, 30)];
    _favBtn.backgroundColor = A008cee;
    _favBtn.layer.cornerRadius = 4;
    _favBtn.clipsToBounds = YES;
    if([_collected isEqualToString:@"no"]){
        [_favBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_favBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [_favBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_favBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _favBtn.backgroundColor = A999;
    }
    [_favBtn addTarget:self action:@selector(favAction) forControlEvents:UIControlEventTouchUpInside];
    _favBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [headView addSubview:_favBtn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame) + 19, 31, WIN_WIDTH - CGRectGetMaxX(imgV.frame) - 19 - 73, 17)];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = A333;
    label.text = _name;
    _label.text = _name;
    [headView addSubview:label];
    
    
    UILabel *numLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame) + 19, CGRectGetMaxY(label.frame) + 13, label.frame.size.width, 15)];
    numLab.textColor = A999;
    numLab.text = [NSString stringWithFormat:@"今日贴数 : %@",_todayposts];
    numLab.font = [UIFont systemFontOfSize:13];
    [headView addSubview:numLab];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame) + 23.5, WIN_WIDTH, 0.5)];
    line.backgroundColor = Ae1e2e6;
    [headView addSubview:line];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, CGRectGetMinY(line.frame))];
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClick)];
    [view addGestureRecognizer:tap];
    [headView addSubview:view];
    
    [view addSubview:_favBtn];
    
    for(int i = 0 ; i < _stickArray.count; i++){
        UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(0, 103 + i * 40, WIN_WIDTH, 40)];
        cellView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellAction:)];
        [cellView addGestureRecognizer:tap];
        cellView.backgroundColor = [UIColor whiteColor];
        [headView addSubview:cellView];
        if(i == 0){
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 0.5)];
            line.backgroundColor = Ae1e2e6;
            [cellView addSubview:line];
        }
        UILabel *zDLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 50, 20)];
        zDLab.text = @"置顶";
        zDLab.textColor = TMHEADCOLO;
        [cellView addSubview:zDLab];
        
        UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(zDLab.frame) + 14, 10, WIN_WIDTH - CGRectGetMaxX(zDLab.frame) - 26, 20)];
        textLab.textColor = A333;
        textLab.font = [UIFont systemFontOfSize:15];
        StickModel *model = _stickArray[i];
        textLab.text = model.subject;
        [cellView addSubview:textLab];
        UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 39.5, WIN_WIDTH - 30, 0.5)];
        lineLab.backgroundColor = Ae1e2e6;
        if(_stickArray.count == 3){
            if(i == 2){
            }else{
                [cellView addSubview:lineLab];
            }
        }else if(_stickArray.count == 2){
            if(i == 1){
            }else{
                [cellView addSubview:lineLab];
            }
        }
    }
    UIView *backView= [[UIView alloc]initWithFrame:CGRectMake(0, headView.frame.size.height - 20, WIN_WIDTH, 20)];
    backView.backgroundColor = Af4f5f9;
    [headView addSubview:backView];
    UILabel *lineV = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 0.5)];
    lineV.backgroundColor = Ae1e2e6;
    [backView addSubview:lineV];
    _myTableView.tableHeaderView = headView;
}

-(void)cellAction:(UITapGestureRecognizer *)tap
{
    UIView *view = tap.view;
    StickModel *model = _stickArray[view.tag];
    DetailViewController *vc = [DetailViewController new];
    vc.tid = model.tid;
    vc.titleStr = model.subject;
    vc.authorid = model.authorid;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListModel *model = _listArray[indexPath.row];
    if(model.imgnum.integerValue > 2){
        CGSize mesSize = [self sizeWithText:model.subject font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 24];
        CGSize mSize = [self sizeWithText:@"sss" font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 121];
        if(mesSize.height / mSize.height > 2){
            return mSize.height * 2 + 3.5 +162;
        }else{
            return mesSize.height + 3.5 + 162;
        }
    }else if(model.imgnum.integerValue >= 1){
//        CGSize mesSize = [self sizeWithText:model.subject font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 121];
//        CGSize mSize = [self sizeWithText:@"sss" font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 121];
//        if(mesSize.height / mSize.height > 2){
//            _messageHeight.constant = mSize.height * 2 + 3.5;
//        }else{
//            _messageHeight.constant = mesSize.height + 3.5;
//        }
        return 93;
    }else{
        CGSize mesSize = [self sizeWithText:model.subject font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 24];
        CGSize mSize = [self sizeWithText:@"sss" font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 24];
        if(mesSize.height / mSize.height > 2){
            return  mSize.height * 2 + 60;
        }else{
            return  mesSize.height + 60;
        }
    }
}
#pragma mark-tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListModel *model = _listArray[indexPath.row];
    if(model.imgnum.integerValue > 2){
        NSString *cellid = @"cell";
        TPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(cell ==  nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TPictureCell" owner:self options:nil] firstObject];
        }
        cell.model = _listArray[indexPath.row];
        return cell;
    }else if(model.imgnum.integerValue > 0){
        NSString *cellid = @"cellid";
        SPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(cell ==  nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SPictureCell" owner:self options:nil] firstObject];
        }
        cell.model = _listArray[indexPath.row];
        return cell;
    }else {
        NSString *cellid = @"cellID";
        FPictrureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(cell ==  nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FPictrureCell" owner:self options:nil] firstObject];
        }
        cell.model = _listArray[indexPath.row];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 41)];
    headView.backgroundColor = [UIColor whiteColor];
    _newBack = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH/3, 39.5)];
    [_newBack setTitle:@"最新回复" forState:UIControlStateNormal];
    _newBack.tag = 10;
    if(_page == 1){
        [_newBack setTitleColor:A008cee forState:UIControlStateNormal];
    }else{
        [_newBack setTitleColor:A333 forState:UIControlStateNormal];
    }
    _newBack.titleLabel.font = [UIFont systemFontOfSize:18];
    [_newBack addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_newBack];
    _newLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 39.5, WIN_WIDTH/3, 1)];
    _newLabel.backgroundColor = A008cee;
    [headView addSubview:_newLabel];
    
    _newPost = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/3, 0, WIN_WIDTH/3, 39.5)];
    [_newPost setTitle:@"最新发表" forState:UIControlStateNormal];
    if(_page == 2){
        [_newPost setTitleColor:A008cee forState:UIControlStateNormal];

    }else{
        [_newPost setTitleColor:A333 forState:UIControlStateNormal];
    }
    
    _newPost.titleLabel.font = [UIFont systemFontOfSize:18];
    [_newPost addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _newPost.tag = 20;
    [headView addSubview:_newPost];
    _newPostLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH/3, 39.5, WIN_WIDTH/3, 1)];
    _newPostLabel.backgroundColor = A008cee;
    
    [headView addSubview:_newPostLabel];
    
    _niceBook = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/3 * 2, 0, WIN_WIDTH/3, 39.5)];
    [_niceBook setTitle:@"精华帖子" forState:UIControlStateNormal];
    if(_page == 3){
        [_niceBook setTitleColor:A008cee forState:UIControlStateNormal];
    }else{
        [_niceBook setTitleColor:A333 forState:UIControlStateNormal];
    }
    
    _niceBook.titleLabel.font = [UIFont systemFontOfSize:18];
    [_niceBook addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _niceBook.tag = 30;
    [headView addSubview:_niceBook];
    _niceLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH/3 * 2, 39.5, WIN_WIDTH/3, 1)];
    _niceLabel.backgroundColor = A008cee;
    [headView addSubview:_niceLabel];
    if(_page == 1){
        _newLabel.hidden = NO;
        _newPostLabel.hidden = YES;
        _niceLabel.hidden = YES;
    }else if(_page == 2){
        _newLabel.hidden = YES;
        _newPostLabel.hidden = NO;
        _niceLabel.hidden = YES;
    }else {
        _newLabel.hidden = YES;
        _newPostLabel.hidden = YES;
        _niceLabel.hidden = NO;
    }
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 40.5, WIN_WIDTH, 0.5)];
    lab.backgroundColor = Ad6d6d6;
    [headView addSubview:lab];
    return headView;
}

-(void)btnAction:(UIButton *)btn
{
    [_listArray removeAllObjects];
    if(btn.tag == 10){
        _page = 1;
        _niceLabel.hidden = YES;
        [_niceBook setTitleColor:A333 forState:UIControlStateNormal];
        _newPostLabel.hidden = YES;
        [_newPost setTitleColor:A333 forState:UIControlStateNormal];
        _newLabel.hidden = NO;
        [_newBack setTitleColor:A008cee forState:UIControlStateNormal];
    }else if(btn.tag == 20){
         _page = 2;
        [_niceBook setTitleColor:A333 forState:UIControlStateNormal];
        [_newPost setTitleColor:A008cee forState:UIControlStateNormal];
        [_newBack setTitleColor:A333 forState:UIControlStateNormal];
        _niceLabel.hidden = YES;
        _newPostLabel.hidden = NO;
        _newLabel.hidden = YES;

    }else{
        _page = 3;
        [_niceBook setTitleColor:A008cee forState:UIControlStateNormal];
        [_newPost setTitleColor:A333 forState:UIControlStateNormal];
        [_newBack setTitleColor:A333 forState:UIControlStateNormal];
        _niceLabel.hidden = NO;
        _newPostLabel.hidden = YES;
        _newLabel.hidden = YES;
    }
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = BANKDT;
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:_fid forKey:@"fid"];
    [messageDic setObject:@"1" forKey:@"page"];
    if(btn.tag == 10){
        
    }else if(btn.tag == 20){
        [messageDic setObject:@"dateline" forKey:@"orderby"];
    }else {
        [messageDic setObject:@"1" forKey:@"digest"];
    }
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",responseObject);
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *listA = dataDic[@"list"];
        for(NSDictionary *dict in listA){
            ListModel *model = [ListModel new];
            model.author = [NSString stringWithFormat:@"%@",dict[@"author"]];
            model.authorid = [NSString stringWithFormat:@"%@",dict[@"authorid"]];
            model.dateline = [NSString stringWithFormat:@"%@",dict[@"dateline"]];
            model.collected = [NSString stringWithFormat:@"%@",dict[@"collected"]];
            model.imgnum = [NSString stringWithFormat:@"%@",dict[@"imgnum"]];
            model.subject = [NSString stringWithFormat:@"%@",dict[@"subject"]];
            model.tid = [NSString stringWithFormat:@"%@",dict[@"tid"]];
            model.views = [NSString stringWithFormat:@"%@",dict[@"views"]];
            NSArray *imgs = dict[@"imgs"];
            NSMutableArray *imgArray = [NSMutableArray new];
            if(imgs.count > 0){
                for(NSString *str in imgs){
                    imgModel *model = [imgModel new];
                    model.imgName = str;
                    [imgArray addObject:model];
                }
                model.imgArray = imgArray;
            }
            [_listArray addObject:model];
        }
        [_myTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    ListModel *model = _listArray[indexPath.row];
    if(model.imgnum.integerValue > 2){
        TPictureCell *cell1 = [_myTableView cellForRowAtIndexPath:_bigIndex];
        cell1.messageLab.textColor = A333;
        
        TPictureCell *cell2 = [_myTableView cellForRowAtIndexPath:indexPath];
        cell2.messageLab.textColor = [UIColor grayColor];
        _bigIndex = indexPath;

    }else if(model.imgnum.integerValue > 2){
        SPictureCell *cell1 = [_myTableView cellForRowAtIndexPath:_bigIndex];
        cell1.messageLab.textColor = A333;
        
        SPictureCell *cell2 = [_myTableView cellForRowAtIndexPath:indexPath];
        cell2.messageLab.textColor = [UIColor grayColor];
        _bigIndex = indexPath;

    }else{
        FPictrureCell *cell1 = [_myTableView cellForRowAtIndexPath:_bigIndex];
        cell1.messageLab.textColor = A333;
        
        FPictrureCell *cell2 = [_myTableView cellForRowAtIndexPath:indexPath];
        cell2.messageLab.textColor = [UIColor grayColor];
        _bigIndex = indexPath;

    }
    DetailViewController *vc = [DetailViewController new];
    vc.tid = model.tid;
    vc.titleStr = model.subject;
    vc.imgUrl = model.author;
    vc.authorid = model.authorid;
    vc.collected = model.collected;
    vc.comeFrom = @"1";
    NSLog(@"%@%@%@%@%@",model.tid,model.subject,model.author,model.authorid,model.collected);
    NSDictionary *dicData = @{
                           @"tid":model.tid,
                           @"titleStr":model.subject,
                           @"dateline":model.dateline,
                           @"imgUrl":model.author,
                           @"authorid":model.authorid,
                           @"numViews":model.views
                           };
    [self.tableObj addFields:dicData];
    NSLog(@"%@",[self.tableObj selectAll]);
    NSArray *result = [self.tableObj selectAll];
    NSMutableArray *modelArray = [NSMutableArray new];
    if(result.count > 20){
        for(int i = 0;i<result.count;i++){
            if(i > result.count - 20){
                [modelArray addObject:result[i]];
            }
        }
       [self.tableObj deleteWithWhere:nil];
        if(modelArray.count > 0){
            for(NSDictionary *dic in modelArray){
                [self.tableObj addFields:dic];
            }
        }
        NSLog(@"%@  %ld",[self.tableObj selectAll],[self.tableObj selectAll].count);
    }
    NSLog(@"%ld",[self.tableObj selectAll].count);
    [vc setCallBack:^{
        UIButton *btn = [[UIButton alloc]initWithFrame:_rightBtn.frame];
        [btn addTarget:self action:@selector(xiaoxi) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }];
     [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- 加载更多
-(void)loadMoreData
{
    _currentPage ++;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = BANKDT;
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:_fid forKey:@"fid"];
    [messageDic setObject:[NSString stringWithFormat:@"%ld",_currentPage] forKey:@"page"];
    if(_page == 1){
        
    }else if(_page == 2){
        [messageDic setObject:@"dateline" forKey:@"orderby"];
    }else {
        [messageDic setObject:@"1" forKey:@"digest"];
    }
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",responseObject);
        [_myTableView.mj_footer endRefreshing];
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *listA = dataDic[@"list"];
        for(NSDictionary *dict in listA){
            ListModel *model = [ListModel new];
            model.author = [NSString stringWithFormat:@"%@",dict[@"author"]];
            model.authorid = [NSString stringWithFormat:@"%@",dict[@"authorid"]];
            model.dateline = [NSString stringWithFormat:@"%@",dict[@"dateline"]];
            model.imgnum = [NSString stringWithFormat:@"%@",dict[@"imgnum"]];
            model.subject = [NSString stringWithFormat:@"%@",dict[@"subject"]];
            model.tid = [NSString stringWithFormat:@"%@",dict[@"tid"]];
            model.views = [NSString stringWithFormat:@"%@",dict[@"views"]];
            NSArray *imgs = dict[@"imgs"];
            NSMutableArray *imgArray = [NSMutableArray new];
            if(imgs.count > 0){
                for(NSString *str in imgs){
                    imgModel *model = [imgModel new];
                    model.imgName = str;
                    [imgArray addObject:model];
                }
                model.imgArray = imgArray;
            }
            [_listArray addObject:model];
        }
        [_myTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark-头点击事件
-(void)headClick
{
    HeadDetailController *vc = [HeadDetailController new];
    vc.nameTitle = _nameTitle;
    vc.fid = _fid;
    vc.imgUrl = _icon;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)callBackMessage
{
    NSString *ticket = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(ticket.length >0){
        FaTieViewController *vc = [FaTieViewController new];
        NSLog(@"%@   %@",_firstId,_fid);
        vc.fid =  _fid;
        [vc setCallBack:^{
            [_myTableView removeFromSuperview];
            [_listArray removeAllObjects];
            [_stickArray removeAllObjects];
            [self prepareData];
            if(_page == 1){
                [self btnAction:_newBack];
            }else if(_page == 2){
                [self btnAction:_newPost];
            }else {
                [self btnAction:_niceBook];
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        EnterViewController *vc = [EnterViewController new];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)xiaoxi
{
    NSString *ticket = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(ticket.length >0){
        MyMessageViewController *vc = [MyMessageViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        EnterViewController *vc = [EnterViewController new];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)favAction
{
    NSString *urlString =[NSString stringWithFormat:@"%@%@",PHPHOST,@"favorite"];
    NSString *ticket = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(ticket.length >0){
        MBProgressHUD *hud;
       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDAnimationFade;
        SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
        NSMutableDictionary *messageDic = [MessageTool getMessage];
        [messageDic setObject:_fid forKey:@"fid"];
        NSLog(@"%@",messageDic);
        [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if([code isEqualToString:@"0"]){
                NSDictionary *dic = responseObject[@"data"];
                NSString *collected = dic[@"collected"];
                if([collected isEqualToString:@"yes"]){
                    [_favBtn setTitle:@"取消" forState:UIControlStateNormal];
                    _favBtn.backgroundColor = A999;
                }else{
                    [_favBtn setTitle:@"收藏" forState:UIControlStateNormal];
                    _favBtn.backgroundColor = A008cee;
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeFav" object:nil];
            }else{
                NSLog(@"%@",responseObject[@"msg"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError* _Nonnull error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else{
        EnterViewController *vc = [EnterViewController new];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)FavAction
{
    [_myTableView removeFromSuperview];
    [_listArray removeAllObjects];
    [_stickArray removeAllObjects];
    [self prepareData];
    if(_page == 1){
        [self btnAction:_newBack];
    }else if(_page == 2){
        [self btnAction:_newPost];
    }else {
        [self btnAction:_niceBook];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _btn.alpha = 0.5;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _btn.alpha = 1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _btn.alpha = 1;
}

@end

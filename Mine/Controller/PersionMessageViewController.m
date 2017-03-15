//
//  PersionMessageViewController.m
//  SCCBBS
//
//  Created by co188 on 17/1/12.
//  Copyright © 2017年 co188. All rights reserved.
//

#import "PersionMessageViewController.h"
#import "SCCHeader.h"
#import "SCCAFnetTool.h"
#import <MBProgressHUD.h>
#import "tools.h"
#import "MessageTool.h"
#import "ListModel.h"
#import "imgModel.h"
#import <MJRefresh.h>
#import "TPictureCell.h"
#import "SPictureCell.h"
#import "FPictrureCell.h"
#import "DetailViewController.h"
#import <UIImageView+WebCache.h>
#import "SCCBtn.h"
#import "SendPrivateMController.h"
#import "EnterViewController.h"

@interface PersionMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_label;
    UIButton *_leftBtn;
    
    NSString *_avatar;
    NSString *_isvip;
    NSString *_sightml;  //签名
    NSString *_uid;
    NSString *_user_name;
    NSString *_username;
    NSMutableArray *_dataArray;
    
    UITableView *_myTableView;
    UIView *_footerView;
    NSInteger _currentPage;
    NSIndexPath *_bigIndex;
    
    SCCBtn *_leftB;
    SCCBtn *_rightB;
    
    UILabel *_line;
    UILabel *_rightLine;
    
    UIView *_messageView;
    NSString *_genderName;
    NSString *_birthDay;
    
    SCCBtn *_focusBtn;
    NSString *_followed;
    
    UIButton *_btn;
    
}
@end

@implementation PersionMessageViewController

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
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"个人信息";
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
    
    [self prepareData];
    // Do any additional setup after loading the view.
}

-(void)prepareData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = @"https://app.co188.com/bbs/user.php?";
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:_idString forKey:@"uid"];
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dataDic = responseObject[@"data"];
            NSDictionary *memberDic = dataDic[@"member"];
            _avatar = memberDic[@"avatar"];
            _isvip = [NSString stringWithFormat:@"%@",responseObject[@"isvip"]];
            _sightml = memberDic[@"sightml"];
            _uid = [NSString stringWithFormat:@"%@",memberDic[@"uid"]];
            _user_name = [NSString stringWithFormat:@"%@",memberDic[@"""user_name"""]];
            _username = memberDic[@"username"];
            _followed = memberDic[@"followed"];
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
                [_dataArray addObject:model];
            }
            [self createTable];
            
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
}

-(void)createTable
{
    NSString *name = [[NSUserDefaults standardUserDefaults]valueForKey:@"susername"];
    NSLog(@"%@",_dataArray);
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64 - 50)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    _myTableView.tableFooterView = [UIView new];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 92)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 55, 55)];
    headImg.layer.cornerRadius = 27.5;
    headImg.clipsToBounds = YES;
    [headImg sd_setImageWithURL:[NSURL URLWithString:_avatar]];
    [headView addSubview:headImg];
    
    CGSize namesize = [self sizeWithText:_avatar font:[UIFont systemFontOfSize:16]];
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImg.frame) + 15, 22, namesize.width, 14)];
    nameLab.text = _username;
    nameLab.font = [UIFont systemFontOfSize:16];
    nameLab.textColor = A333;
    [headView addSubview:nameLab];
    
    UIImageView *vipImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImg.frame) + 15, 22, 15, 14)];
    NSInteger vip = [_isvip integerValue];
    if(vip == 0){
        vipImg.hidden = YES;
    }else if(vip == 1) {
        vipImg.image = [UIImage imageNamed:@"v1"];
    }else if(vip == 2){
        vipImg.image = [UIImage imageNamed:@"v2"];
    }else if(vip == 3){
        vipImg.image = [UIImage imageNamed:@"v3"];
    }else if(vip == 4){
        vipImg.image = [UIImage imageNamed:@"v4"];
    }else if(vip == 5){
        vipImg.image = [UIImage imageNamed:@"v5"];
    }else if(vip == 6){
        vipImg.image = [UIImage imageNamed:@"v6"];
    }else {
        vipImg.image = [UIImage imageNamed:@"v7"];
    }
    CGSize qianMinSize = [self sizeWithText:_sightml font:[UIFont systemFontOfSize:13]];
    UILabel *qianMingLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImg.frame) + 15, CGRectGetMaxY(nameLab.frame) + 7, qianMinSize.width, qianMinSize.height)];
    qianMingLab.text = _sightml;
    qianMingLab.textColor = A888;
    qianMingLab.font = [UIFont systemFontOfSize:13];
    [headView addSubview:qianMingLab];
    
    UIView *lastView = [[UIView alloc]initWithFrame:CGRectMake(0, 82, WIN_WIDTH, 10)];
    lastView.backgroundColor = Af4f5f9;
    [headView addSubview:lastView];
    _myTableView.tableHeaderView = headView;
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"无更多数据" forState:MJRefreshStateIdle];
    _myTableView.mj_footer = footer;
    
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, WIN_HEIGHT - 50, WIN_WIDTH, 50)];
    _footerView.backgroundColor = Af4f5f9;
    
    _focusBtn = [[SCCBtn alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH/2 - 0.5, 50)];
    if([_followed isEqualToString:@"yes"]){
        [_focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        [_focusBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    _focusBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_focusBtn addTarget:self action:@selector(focusAction) forControlEvents:UIControlEventTouchUpInside];
    
//    [leftBtn setTitleColor:A333 forState:UIControlStateNormal];
    [_focusBtn setTitleColor:A008cee forState:UIControlStateNormal];
    [_footerView addSubview:_focusBtn];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_focusBtn.frame), 15, 0.5, 20)];
    line.backgroundColor = Ad6d6d6;
    [_footerView addSubview:line];
    
//    leftBtn.selected = YES;
    
    SCCBtn *rightBtn = [[SCCBtn alloc]initWithFrame:CGRectMake(WIN_WIDTH/2, 0, WIN_WIDTH/2, 50)];
    [rightBtn setTitle:@"发私信" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:A333 forState:UIControlStateNormal];
    [rightBtn setTitleColor:A008cee forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:rightBtn];
    [self.view addSubview:_footerView];
    
    UILabel *lineL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 0.5)];
    lineL.backgroundColor = Ad6d6d6;
    [_footerView addSubview:lineL];
    
    if([name isEqualToString:_user_name]){
        _focusBtn.userInteractionEnabled = NO;
        rightBtn.userInteractionEnabled = NO;
        [_focusBtn setTitle:@"关注" forState:UIControlStateNormal];
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListModel *model = _dataArray[indexPath.row];
    if(model.imgnum.integerValue > 2){
        NSString *cellid = @"cell";
        TPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(cell ==  nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TPictureCell" owner:self options:nil] firstObject];
        }
        cell.model = _dataArray[indexPath.row];
        return cell;
    }else if(model.imgnum.integerValue > 0){
        NSString *cellid = @"cellid";
        SPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(cell ==  nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SPictureCell" owner:self options:nil] firstObject];
        }
        cell.model = _dataArray[indexPath.row];
        return cell;
    }else {
        NSString *cellid = @"cellID";
        FPictrureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(cell ==  nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FPictrureCell" owner:self options:nil] firstObject];
        }
        cell.model = _dataArray[indexPath.row];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    
    _leftB = [[SCCBtn alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH/2, 38.5)];
    [_leftB setTitle:@"动态" forState:UIControlStateNormal];
    _leftB.titleLabel.font = [UIFont systemFontOfSize:15];
    [_leftB addTarget:self action:@selector(dongTaiAction) forControlEvents:UIControlEventTouchUpInside];
    [_leftB setTitleColor:A333 forState:UIControlStateNormal];
    [_leftB setTitleColor:A008cee forState:UIControlStateSelected];
    [headView addSubview:_leftB];
    _line = [[UILabel alloc]initWithFrame:CGRectMake((WIN_WIDTH / 2 - 105.5)/2, 38.5, 105.5, 1)];
    _line.backgroundColor = A008cee;
    [headView addSubview:_line];
    
    _leftB.selected = YES;
    
    _rightB = [[SCCBtn alloc]initWithFrame:CGRectMake(WIN_WIDTH/2, 0, WIN_WIDTH/2, 38.5)];
    [_rightB setTitle:@"资料" forState:UIControlStateNormal];
    _rightB.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightB addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_rightB setTitleColor:A333 forState:UIControlStateNormal];
    [_rightB setTitleColor:A008cee forState:UIControlStateSelected];
    [headView addSubview:_rightB];
    _rightLine = [[UILabel alloc]initWithFrame:CGRectMake( WIN_WIDTH/2 + (WIN_WIDTH / 2 - 105.5)/2, 38.5, 105.5, 1)];
    _rightLine.backgroundColor = A008cee;
    [headView addSubview:_rightLine];
    _rightLine.hidden = YES;
    
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 39.5, WIN_WIDTH, 0.5)];
    lineLab.backgroundColor = Ad6d6d6;
    [headView addSubview:lineLab];
    
    return  headView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    ListModel *model = _dataArray[indexPath.row];
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
//        UIButton *btn = [[UIButton alloc]initWithFrame:_rightBtn.frame];
//        [btn addTarget:self action:@selector(xiaoxi) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btn];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListModel *model = _dataArray[indexPath.row];
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


-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadMoreData
{
    _currentPage++;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = @"https://app.co188.com/bbs/user.php?";
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:_idString forKey:@"uid"];
    [messageDic setObject:[NSString stringWithFormat:@"%ld",_currentPage] forKey:@"page"];
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
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
                [_dataArray addObject:model];
            }
            [_myTableView reloadData];
            [_myTableView.mj_footer endRefreshing];
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
}

-(void)dongTaiAction
{
    _myTableView.scrollEnabled = YES;
    [_messageView removeFromSuperview];
    _leftB.selected = YES;
    _rightB.selected = NO;
    _line.hidden = NO;
    _rightLine.hidden = YES;
    
    [_dataArray removeAllObjects];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = @"https://app.co188.com/bbs/user.php?";
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:_idString forKey:@"uid"];
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dataDic = responseObject[@"data"];
            NSDictionary *memberDic = dataDic[@"member"];
            _avatar = memberDic[@"avatar"];
            _isvip = [NSString stringWithFormat:@"%@",responseObject[@"isvip"]];
            _sightml = memberDic[@"sightml"];
            _uid = [NSString stringWithFormat:@"%@",memberDic[@"uid"]];
            _user_name = [NSString stringWithFormat:@"%@",memberDic[@"""user_name"""]];
            _username = memberDic[@"username"];
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
                [_dataArray addObject:model];
            }
            [_myTableView reloadData];
            
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

}

-(void)rightAction
{
    [_btn removeFromSuperview];
    _leftB.selected = NO;
    _rightB.selected = YES;
    _line.hidden = YES;
    _rightLine.hidden = NO;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/member/getUserInfoByUser",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    NSString *str = _username;
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [messageDic setObject:str forKey:@"quser"];
    [messageDic setObject:@"utf-8" forKey:@"charset"];
    NSLog(@"%@",messageDic);
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dataDic = responseObject[@"data"];
            _birthDay = dataDic[@"birthday"];
            _genderName = dataDic[@"genderName"];
            [self createZiLiao];
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
}

-(void)createZiLiao
{
    [_btn removeFromSuperview];
    _myTableView.scrollEnabled = NO;
    _messageView = [[UIView alloc]initWithFrame:CGRectMake(0, 196, WIN_WIDTH, WIN_HEIGHT - 196 - 50)];
    _messageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_messageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 150, 48)];
    label.text = @"资料";
    label.textColor = A333;
    label.font = [UIFont systemFontOfSize:14];
    [_messageView addSubview:label];
    
    UILabel *sexLab = [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH - 100, 0, 88, 48)];
    if(_genderName.length > 0){
        sexLab.text = _genderName;
    }else{
        sexLab.text = @"保密";
    }
    sexLab.textColor = A999;
    sexLab.textAlignment = NSTextAlignmentRight;
    sexLab.font = [UIFont systemFontOfSize:13];
    [_messageView addSubview:sexLab];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(sexLab.frame), WIN_WIDTH - 24, 0.5)];
    line.backgroundColor = Ae1e2e6;
    [_messageView addSubview:line];
    
    UILabel *bthLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(line.frame), 150, 48)];
    bthLabel.text = @"生日";
    bthLabel.textColor = A333;
    bthLabel.font = [UIFont systemFontOfSize:14];
    [_messageView addSubview:bthLabel];
    
    UILabel *bthLab = [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH - 140, CGRectGetMaxY(line.frame), 128, 48)];
    if(_birthDay.length > 0){
        bthLab.text = _birthDay;
    }else{
        bthLab.text = @"保密";
    }
    bthLab.textAlignment = NSTextAlignmentRight;
    bthLab.textColor = A999;
    bthLab.font = [UIFont systemFontOfSize:13];
    [_messageView addSubview:bthLab];
    
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(bthLab.frame), WIN_WIDTH - 24, 0.5)];
    lineLab.backgroundColor = Ae1e2e6;
    [_messageView addSubview:lineLab];
}

-(void)sendMessage{
    
    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(str.length > 0){
        SendPrivateMController *vc = [SendPrivateMController new];
        vc.userName = _username;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        EnterViewController *vc = [EnterViewController new];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:Nav animated:YES completion:nil];
    }
    
}

#pragma mark-关注
-(void)focusAction
{
    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(str.length > 0){
        _focusBtn.selected = !_focusBtn.selected;
        if(_focusBtn.selected){
            _btn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/4 - 45,WIN_HEIGHT - 93, 90, 43)];
            [_btn setBackgroundImage:[UIImage imageNamed:@"kuang-1"] forState:UIControlStateNormal];
            _btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_btn setTitleColor:A666 forState:UIControlStateNormal];
            [self.view addSubview:_btn];
            if([_followed isEqualToString:@"yes"]){
                [_btn setTitle:@"取消关注" forState:UIControlStateNormal];
            }else{
                [_btn setTitle:@"关注" forState:UIControlStateNormal];
            }
            [_btn addTarget:self action:@selector(focusOn) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [_btn removeFromSuperview];
        }

    }else{
        EnterViewController *vc = [EnterViewController new];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:Nav animated:YES completion:nil];
    }
    
}

-(void)focusOn
{
    
    if([_followed isEqualToString:@"yes"]){
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDAnimationFade;
        NSString *urlString = @"https://app.co188.com/bbs/user.php?action=delfollow";
        NSLog(@"%@",urlString);
        SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
        NSMutableDictionary *messageDic = [MessageTool getMessage];
        [messageDic setObject:_idString forKey:@"uid"];
        [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if([code isEqualToString:@"0"]){
                NSDictionary *dataDic = responseObject[@"data"];
                _followed = [NSString stringWithFormat:@"%@",dataDic[@"followed"]];
                [_focusBtn setTitle:@"关注" forState:UIControlStateNormal];
                [_btn removeFromSuperview];
                _focusBtn.selected = NO;
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
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDAnimationFade;
        NSString *urlString = @"https://app.co188.com/bbs/user.php?action=addfollow";
        NSLog(@"%@",urlString);
        SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
        NSMutableDictionary *messageDic = [MessageTool getMessage];
        [messageDic setObject:_idString forKey:@"uid"];
        [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSLog(@"%@",responseObject[@"msg"]);
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if([code isEqualToString:@"0"]){
                NSDictionary *dataDic = responseObject[@"data"];
                _followed = [NSString stringWithFormat:@"%@",dataDic[@"followed"]];
                [_focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
                _focusBtn.selected = NO;
                [_btn removeFromSuperview];
                NSLog(@"%@",responseObject[@"msg"]);
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

    }
}
@end

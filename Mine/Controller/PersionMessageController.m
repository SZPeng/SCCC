//
//  PersionMessageController.m
//  SCCBBS
//
//  Created by co188 on 16/11/14.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "PersionMessageController.h"
#import "SCCHeader.h"
#import <MBProgressHUD.h>
#import "SCCAFnetTool.h"
#import "MessageTool.h"
#import "SelfMessageModel.h"
#import <UIImageView+WebCache.h>
#import "SendPrivateMController.h"
@interface PersionMessageController ()
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIView *_headView;
    NSMutableArray *_dataArray;
    UIScrollView *_myTableView;
    UIView *_cellView;
    NSString *_replyuser;
}
@end

@implementation PersionMessageController

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
    self.view.backgroundColor = Af4f5f9;
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    _headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:_headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
//    _label.text = _nameTitle;
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
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 53, 0, 45, 44)];
    [rightBtn setTitle:@"回复" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(callBack) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    rightBtn.center = CGPointMake(rightBtn.center.x, _label.center.y);
    [_headView addSubview:rightBtn];
    [self prepareData];
}

-(void)prepareData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@/protected/msg/getMsgById",API_HOST];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:_msgid forKey:@"msgid"];
    NSLog(@"%@",messageDic);
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dataDic = responseObject[@"data"];
        NSArray *array = dataDic[@"msgs"];
        _replyuser = dataDic[@"replyuser"];
        _label.text = _replyuser;
        for(NSDictionary *dic in array){
            SelfMessageModel *model = [SelfMessageModel new];
            model.username = [NSString stringWithFormat:@"%@",dic[@"username"]];
            model.nickname = dic[@"username"];
            model.myself = [NSString stringWithFormat:@"%@",dic[@"myself"]];
            model.mid = [NSString stringWithFormat:@"%@",dic[@"mid"]];
            model.content = [NSString stringWithFormat:@"%@",dic[@"content"]];
            model.avatar = dic[@"avatar"];
            model.time = dic[@"time"];
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
    _myTableView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH , WIN_HEIGHT - 64)];
    [self.view addSubview:_myTableView];

    for(SelfMessageModel *model in _dataArray){
        if([model.myself isEqualToString:@"0"]){
            UIView *cellView = [[UIView alloc]init];
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 50)];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 18, WIN_WIDTH, 14)];
            label.textColor = A999;
            label.text = model.time;
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            [headView addSubview:label];
            [cellView addSubview:headView];
            UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(headView.frame), 53, 53)];
            headImage.layer.cornerRadius = 26.5;
            headImage.clipsToBounds = YES;
            [headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
            [cellView addSubview:headImage];
            CGSize messageSize = [self sizeWithText:model.content font:[UIFont systemFontOfSize:15] maxW:128];
            CGFloat height = messageSize.height + 40;
            UIImageView *qiPaoImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame) + 3,CGRectGetMaxY(headView.frame), 168, height)];
            UIEdgeInsets insets = UIEdgeInsetsMake(43, 40, 20, 20);
            UIImage *image = [UIImage imageNamed:@"baiseqibao"];
            CGSize heiSize = [self sizeWithText:@"ww" font:[UIFont systemFontOfSize:15] maxW:128];
            if(messageSize.height / heiSize.height > 1){
                image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            }
            qiPaoImg.image = image;
            [cellView addSubview:qiPaoImg];
            if(CGRectGetMaxY(_cellView.frame) > 0){
              cellView.frame = CGRectMake(0, CGRectGetMaxY(_cellView.frame), WIN_WIDTH, CGRectGetMaxY(qiPaoImg.frame));
            }else{
                cellView.frame = CGRectMake(0, 0, WIN_WIDTH, CGRectGetMaxY(qiPaoImg.frame));
            }
            
            UILabel *mesLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 128, messageSize.height)];
            mesLabel.textColor = A333;
            mesLabel.text = model.content;
            mesLabel.font = [UIFont systemFontOfSize:15];
            mesLabel.numberOfLines = 0;
            [qiPaoImg addSubview:mesLabel];
            [_myTableView addSubview:cellView];
            _cellView = cellView;
            
        }else{
            UIView *cellView = [[UIView alloc]init];
//            cellView.backgroundColor = [UIColor redColor];
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 50)];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 18, WIN_WIDTH, 14)];
            label.textColor = A999;
            label.text = model.time;
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            [headView addSubview:label];
            [cellView addSubview:headView];
            UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH - 65, CGRectGetMaxY(headView.frame), 53, 53)];
            headImage.layer.cornerRadius = 26.5;
            headImage.clipsToBounds = YES;
            [headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
            [cellView addSubview:headImage];
            CGSize messageSize = [self sizeWithText:model.content font:[UIFont systemFontOfSize:15] maxW:128];
            CGFloat height = messageSize.height + 40;
            UIImageView *qiPaoImg = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH - 236,CGRectGetMaxY(headView.frame), 168, height)];
            UIEdgeInsets insets = UIEdgeInsetsMake(43, 20, 20, 40);
            UIImage *image = [UIImage imageNamed:@"lanseqipao"];
            CGSize heiSize = [self sizeWithText:@"ww" font:[UIFont systemFontOfSize:15] maxW:128];
            if(messageSize.height / heiSize.height > 1){
                image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            }
            qiPaoImg.image = image;
            [cellView addSubview:qiPaoImg];
            if(CGRectGetMaxY(_cellView.frame) > 0){
                cellView.frame = CGRectMake(0, CGRectGetMaxY(_cellView.frame), WIN_WIDTH, CGRectGetMaxY(qiPaoImg.frame));
            }else{
                cellView.frame = CGRectMake(0, 0, WIN_WIDTH, CGRectGetMaxY(qiPaoImg.frame));
            }

            UILabel *mesLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 128, messageSize.height)];
            mesLabel.textColor = A333;
            mesLabel.text = model.content;
            mesLabel.numberOfLines = 0;
            mesLabel.font = [UIFont systemFontOfSize:15];
            [qiPaoImg addSubview:mesLabel];
            [_myTableView addSubview:cellView];
            _cellView = cellView;
        }
    }
    _myTableView.contentSize = CGSizeMake(0, CGRectGetMaxY(_cellView.frame) + 20);
}
#pragma mark- tableView代理
-(void)refreshData
{
    [_myTableView removeFromSuperview];
    [_dataArray removeAllObjects];
    _cellView = nil;
    [self prepareData];
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)callBack{
    SendPrivateMController *vc = [SendPrivateMController new];
    vc.userName = _replyuser;
    [self.navigationController pushViewController:vc animated:YES];
}
@end

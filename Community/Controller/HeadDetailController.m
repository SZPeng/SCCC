//
//  HeadDetailController.m
//  SCCBBS
//
//  Created by co188 on 16/11/25.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "HeadDetailController.h"
#import "SCCHeader.h"
#import "SCCAFnetTool.h"
#import "MessageTool.h"
#import "tools.h"
#import <MBProgressHUD.h>
#import "NameModel.h"
#import <UIImageView+WebCache.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import "WXApi.h"
#import "EnterViewController.h"

@interface HeadDetailController ()
{
    UIView *_headView;
    UILabel *_label;
    UIButton *_leftBtn;
    UIButton *_rightBtn;
    UIView *_backView;
    
    NSString *_collected;
    NSString *_description;
    NSString *_nFid;
    NSString *_icon;
    NSString *_name;
    NSString *_group;
    NSMutableArray *_nameArray;
    
    UIScrollView *_myScroll;
    UIButton *_btn;
}
@end

@implementation HeadDetailController

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
        _nameArray = [NSMutableArray new];
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
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    [_rightBtn setImage:[UIImage imageNamed:@"share"]  forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.center = CGPointMake(_rightBtn.center.x, _label.center.y);
    [_headView addSubview:_rightBtn];
    
    [self prepareData];
}

-(void)shareAction
{
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT)];
    _backView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    [self.view addSubview:_backView];
    
    UIView *shareView = [[UIView alloc]initWithFrame:CGRectMake(15, WIN_HEIGHT / 2 - 80, WIN_WIDTH - 30, 160)];
    shareView.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:shareView];
    shareView.layer.cornerRadius = 15;
    shareView.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(shareView.frame.size.width/2 - 25, 25, 50, 20)];
    label.text = @"分享至";
    label.textColor = TTG3;
    label.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16];
    label.textAlignment = NSTextAlignmentCenter;
    [shareView addSubview:label];
    UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(20, 34.5, CGRectGetMinX(label.frame) - 20 - 10, 1)];
    leftLine.backgroundColor = LINECOLOR;
    [shareView addSubview:leftLine];
    UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 10, 34.5, CGRectGetMinX(label.frame) - 20 - 10, 1)];
    rightLine.backgroundColor = LINECOLOR;
    [shareView addSubview:rightLine];
    CGFloat width = (shareView.frame.size.width - 110) / 3;
    UIButton *weixinBtn = [[UIButton alloc]initWithFrame:CGRectMake(width, CGRectGetMaxY(label.frame) + 15, 55, 55)];
    weixinBtn.tag = 10;
    [weixinBtn addTarget:self action:@selector(weiXinShare:) forControlEvents:UIControlEventTouchUpInside];
    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"weix50"] forState:UIControlStateNormal];
    weixinBtn.layer.cornerRadius = 27.5;
    weixinBtn.clipsToBounds = YES;
    [shareView addSubview:weixinBtn];
    UILabel *weiXinLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(weixinBtn.frame) + 3,60, 20)];
    weiXinLab.text = @"微信";
    weiXinLab.textColor = [UIColor grayColor];
    weiXinLab.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    weiXinLab.textAlignment = NSTextAlignmentCenter;
    weiXinLab.center = CGPointMake(weixinBtn.center.x, weiXinLab.center.y);
    [shareView addSubview:weiXinLab];
    
    UIButton *weiFrdBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(weixinBtn.frame)+width, CGRectGetMaxY(label.frame) + 15, 55, 55)];
    [weiFrdBtn setBackgroundImage:[UIImage imageNamed:@"peny50"] forState:UIControlStateNormal];
    weiFrdBtn.layer.cornerRadius = 27.5;
    weiFrdBtn.tag = 20;
    [weiFrdBtn addTarget:self action:@selector(weiXinShare:) forControlEvents:UIControlEventTouchUpInside];
    
    weiFrdBtn.clipsToBounds = YES;
    [shareView addSubview:weiFrdBtn];
    UILabel *weiFrenLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(weixinBtn.frame) + 3,60, 20)];
    weiFrenLab.text = @"朋友圈";
    weiFrenLab.textColor = [UIColor grayColor];
    weiFrenLab.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    weiFrenLab.textAlignment = NSTextAlignmentCenter;
    weiFrenLab.center = CGPointMake(weiFrdBtn.center.x, weiFrenLab.center.y);
    [shareView addSubview:weiFrenLab];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 100, CGRectGetMinY(shareView.frame) - 60, 30, 30)];
    //    btn.backgroundColor = [UIColor whiteColor];
    [btn setBackgroundImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionBUUT) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:btn];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(btn.frame) - 0.5, CGRectGetMaxY(btn.frame), 1, 30)];
    line.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:line];
    
}
#pragma mark-分享
-(void)weiXinShare:(UIButton *)btn
{
    NSString *str = [NSString stringWithFormat:@"%@%@%@",@"http://m.co188.com/bbs/forum-",_fid,@"-1.html"];
    if(btn.tag == 10){
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = _nameTitle;
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_icon]];
        [message setThumbImage:[UIImage imageWithData:data]];
        WXWebpageObject *webObject = [WXWebpageObject object];
        
        webObject.webpageUrl = str;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        
        [WXApi sendReq:req];
    }else{
        //微信朋友圈
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = _nameTitle;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_icon]];
        [message setThumbImage:[UIImage imageWithData:data]];
        WXWebpageObject *webObject = [WXWebpageObject object];
        
        webObject.webpageUrl = str;
        message.mediaObject = webObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        
        [WXApi sendReq:req];
    }

}

-(void)actionBUUT
{
    [UIView animateWithDuration:0.1 animations:^{
        _backView.alpha = 0.7;
    } completion:^(BOOL finished) {
        _backView.alpha = 0;
        [_backView removeFromSuperview];
    }];
}

-(void)prepareData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",PHPHOST,@"forumdetail"];
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:_fid forKey:@"fid"];
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",responseObject);
        NSString *dataStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([dataStr isEqualToString:@"0"]){
            NSDictionary *dataDic = responseObject[@"data"];
            _collected = [NSString stringWithFormat:@"%@",dataDic[@"collected"]];
            _description = [NSString stringWithFormat:@"%@",dataDic[@"description"]];
            _nFid = [NSString stringWithFormat:@"%@",dataDic[@"fid"]];
            _icon = dataDic[@"icon"];
            _name = dataDic[@"name"];
            _group = [NSString stringWithFormat:@"%@",dataDic[@"group"]];
            NSArray *modsArray = dataDic[@"mods"];
            for(NSDictionary *dic in modsArray){
                NameModel *model = [NameModel new];
                model.avatar = dic[@"avatar"];
                model.username = [NSString stringWithFormat:@"%@",dic[@"username"]];
                [_nameArray addObject:model];
            }
            [self createUI];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

-(void)createUI
{
    _myScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64)];
    _myScroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_myScroll];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 103)];
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(12, 15, 72.5, 72.5)];
    if(_icon.length > 5){
        [headImg sd_setImageWithURL:[NSURL URLWithString:_icon]];
    }else{
        headImg.image = [UIImage imageNamed:@"145"];
    }
    headImg.clipsToBounds = YES;
    [headView addSubview:headImg];
    [_myScroll addSubview:headView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImg.frame) + 19, 30, WIN_WIDTH - CGRectGetMaxX(headImg.frame) - 19 - 12,20)];
    titleLab.text = _name;
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textColor = A333;
    [headView addSubview:titleLab];
    
    UILabel *groupLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImg.frame) + 19, CGRectGetMaxY(titleLab.frame) + 13, 200, 15)];
    groupLab.font = [UIFont systemFontOfSize:13];
    groupLab.textColor = A999;
    groupLab.text = _group;
    [headView addSubview:groupLab];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), WIN_WIDTH, 20)];
    backView.backgroundColor = Af4f5f9;
    [_myScroll addSubview:backView];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 0.5)];
    line.backgroundColor = Ad6d6d6;
    [backView addSubview:line];
    
    UILabel *lineL = [[UILabel alloc]initWithFrame:CGRectMake(0, 19.5, WIN_WIDTH, 0.5)];
    lineL.backgroundColor = Ad6d6d6;
    [backView addSubview:lineL];
    UIView *banDetail = [[UIView alloc]init];//WithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame), WIN_WIDTH, <#CGFloat height#>)
    UILabel *labelBan = [[UILabel alloc]initWithFrame:CGRectMake(12, 19, 80, 20)];
    labelBan.text = @"板块说明:";
    labelBan.textColor = A333;
    labelBan.font = [UIFont systemFontOfSize:18];
    [banDetail addSubview:labelBan];
    CGSize decSize = [self sizeWithText:_description font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - CGRectGetMaxX(labelBan.frame) - 24];
    banDetail.frame = CGRectMake(0, CGRectGetMaxY(backView.frame), WIN_WIDTH, decSize.height + 40);
    UILabel *desLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labelBan.frame) + 12, 19, WIN_WIDTH - CGRectGetMaxX(labelBan.frame) - 24, decSize.height)];
    desLab.numberOfLines = 0;
    desLab.text = _description;
    desLab.font = [UIFont systemFontOfSize:18];
    desLab.textColor = [UIColor grayColor];
    [banDetail addSubview:desLab];
    [_myScroll addSubview:banDetail];
    
    UILabel *Line = [[UILabel alloc]initWithFrame:CGRectMake(0, banDetail.frame.size.height - 0.5, WIN_WIDTH, 0.5)];
    Line.backgroundColor = Ad6d6d6;
    [banDetail addSubview:Line];
    
    UIView *messageBan = [[UIView alloc]init];//WithFrame:CGRectMake(0, CGRectGetMaxY(banDetail.frame), WIN_WIDTH, <#CGFloat height#>)
    UILabel *messLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 19, 80, 20)];
    messLab.text = @"版主信息:";
    messLab.textColor = A333;
    messLab.font = [UIFont systemFontOfSize:18];
    [messageBan addSubview:messLab];
    
    CGFloat width = (WIN_WIDTH - CGRectGetMaxX(messLab.frame) - 87.5)/4;
    for(int i = 0;i<_nameArray.count;i++){
        NameModel *model = _nameArray[i];
        UIImageView* headImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(messLab.frame) + 17.5 + i%4*(width + 17.5), 19 + 100 * (i/4), width, width)];
        [headImg sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
        headImg.layer.cornerRadius = width/2;
        headImg.clipsToBounds = YES;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImg.frame), CGRectGetMaxY(headImg.frame) + 11, width, 20)];
        label.textColor = A333;
        label.text = model.username;
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        [messageBan addSubview:headImg];
        [messageBan addSubview:label];
    }
    messageBan.frame = CGRectMake(0, CGRectGetMaxY(banDetail.frame), WIN_WIDTH, (_nameArray.count/4 + 1) * (50 + width) + 42);
    [_myScroll addSubview:messageBan];
    UILabel *lastLine = [[UILabel alloc]initWithFrame:CGRectMake(0, messageBan.frame.size.height - 0.5, WIN_WIDTH, 0.5)];
    lastLine.backgroundColor = Ad6d6d6;
    [messageBan addSubview:lastLine];
    
    _btn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(messageBan.frame) + 28, WIN_WIDTH - 60, 51)];
    _btn.backgroundColor = TMHEADCOLO;
    _btn.layer.cornerRadius = 4;
    _btn.clipsToBounds = YES;
    if([_collected isEqualToString:@"no"]){
       [_btn setTitle:@"收藏本版本" forState:UIControlStateNormal];
    }else{
        [_btn setTitle:@"取消收藏" forState:UIControlStateNormal];
    }
    
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(favAction) forControlEvents:UIControlEventTouchUpInside];
    [_myScroll addSubview:_btn];
    
    _myScroll.contentSize = CGSizeMake(0, CGRectGetMaxY(_btn.frame) + 45);
    
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
                    [_btn setTitle:@"取消收藏" forState:UIControlStateNormal];
                }else{
                    [_btn setTitle:@"收藏本版本" forState:UIControlStateNormal];
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"favAction" object:nil];

            }else{
                NSLog(@"%@",responseObject[@"msg"]);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError* _Nonnull error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];
        
    }else{
        EnterViewController *vc = [EnterViewController new];
        [self presentViewController:vc animated:YES completion:nil];
    }

}

@end

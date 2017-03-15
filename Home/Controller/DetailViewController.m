//
//  DetailViewController.m
//  SCCBBS
//
//  Created by co188 on 16/10/31.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "DetailViewController.h"
#import "SCCHeader.h"
#import "RepliesViewController.h"
#import "PersonalMenu.h"
#import "SCCTitleMenuViewController.h"
#import "RewardViewController.h"
#import "WebViewJavascriptBridge.h"
#import <MBProgressHUD.h>
#import "WXApi.h"
#import "MessageTool.h"
#import "EnterViewController.h"
#import "CommunityDetailController.h"
#import "JuBaoViewController.h"
#import "SCCAFnetTool.h"
#import "tools.h"
#import "PersionMessageViewController.h"

@interface DetailViewController ()<UIWebViewDelegate>
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIWebView *_webView;
    UIButton *_rightbtn;
    UIButton *_rBtn;
    UIImageView *_coverView;
    UIButton *_button;
    BOOL _isCover;
    MBProgressHUD *_hud;
    UIView *_backView;
    
    UIView *backView;
    
//    NSString *_collected;
}
@property WebViewJavascriptBridge*bridge;
@end

@implementation DetailViewController

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isCover = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shuaxin) name:@"daShang" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"详情";
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
    
    _rBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 45, 0, 44, 44)];
    [_rBtn setImage:[UIImage imageNamed:@"Ellipsis"]  forState:UIControlStateNormal];
    _rBtn.userInteractionEnabled = YES;
    [_rBtn addTarget:self action:@selector(xiaoxi:) forControlEvents:UIControlEventTouchUpInside];
    _rBtn.center = CGPointMake(_rBtn.center.x, _label.center.y);
    [headView addSubview:_rBtn];
    
    _rightbtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 45 - 55, 10, 40, 24)];
    [_rightbtn setImage:[UIImage imageNamed:@"louzhu"]  forState:UIControlStateNormal];
    [_rightbtn setImage:[UIImage imageNamed:@"只看楼主"]  forState:UIControlStateSelected];
    [_rightbtn addTarget:self action:@selector(louZhuAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightbtn.center = CGPointMake(_rightbtn.center.x, _label.center.y);
    [headView addSubview:_rightbtn];
    
    [self prepareData];
//    [self createUI];
}

-(void)prepareData
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = @"http://app.co188.com/bbs/view.php?action=isfavorite";
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:_tid forKey:@"tid"];
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            NSDictionary *dic = responseObject[@"data"];
            _collected = dic[@"collected"];
            _authorid = [NSString stringWithFormat:@"%@",dic[@"authorid"]];
        }else if([code isEqualToString:@"500"]){
            [tools alert:responseObject[@"msg"]];
        }else if([code isEqualToString:@"401"]){
            [tools alert:responseObject[@"msg"]];
        }else{
            [tools alert:responseObject[@"msg"]];
        }
        [self createUI];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}
-(void)louZhuAction:(UIButton*)btn
{
    [[NSURLCache  sharedURLCache ] removeAllCachedResponses];
    [_webView removeFromSuperview];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64 - 49)];
    _webView.backgroundColor = Ae1e2e6;
    //    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    //    NSLog(@"%@",messageDic);
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    [_bridge callHandler:@"getUser" data:messageDic responseCallback:^(id responseData) {
        NSLog(@"from js: %@", responseData);
    }];
    //第一个功能跳转
    [_bridge registerHandler:@"getGoNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"okback  %@", data);
        NSDictionary *dic = (NSDictionary *)data;
        CommunityDetailController *vc = [CommunityDetailController new];
        vc.type = @"Detail";
        vc.fid = dic[@"secondlevel"];
        vc.firstId = dic[@"onelevel"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    //打赏功能
    [_bridge registerHandler:@"getRewardNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"okback  %@", data);
        NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
        if(str.length > 0){
            RewardViewController *vc = [RewardViewController new];
            vc.tid = _tid;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self goToEnterView];
        }
    }];
    //点赞功能
    [_bridge registerHandler:@"getLikeNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"okback  %@", data);
        NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
        if(str.length > 0){
            NSMutableDictionary *messageDic = [MessageTool getMessage];
            responseCallback(messageDic);
        }else{
            [self goToEnterView];
        }
    }];
    //评论功能
    [_bridge registerHandler:@"getDiscussNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"okback  %@", data);
        NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
        if(str.length > 0){
            RepliesViewController *vc = [RepliesViewController new];
            vc.name = @"楼主";
            vc.tid = _tid;
            if(_rightbtn.selected){
                vc.isLouZu = @"1";
            }else{
                vc.isLouZu = @"0";
            }
            [vc setCallBack:^{
                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://app.co188.com/bbs/view.php?tid=",_tid]]]];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self goToEnterView];
        }
    }];
    //举报功能
    [_bridge registerHandler:@"getReportNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"okback  %@", data);
        NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
        if(str.length > 0){
            JuBaoViewController *vc = [JuBaoViewController new];
            NSLog(@"%@   %@",data[@"PostId"],data[@"Postfid"]);
            vc.tid = [NSString stringWithFormat:@"%@",data[@"PostId"]];
            vc.fid = [NSString stringWithFormat:@"%@",data[@"Postfid"]];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self goToEnterView];
        }
    }];
    //回复功能
    [_bridge registerHandler:@"getReplyNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"okback  %@", data);
        NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
        if(str.length > 0){
            RepliesViewController *vc = [RepliesViewController new];
            vc.name = data[@"replyAuthor"];
            vc.tid = _tid;
            vc.pid = data[@"replyPid"];
            vc.isHuiFu = @"1";
            if(_rightbtn.selected){
                vc.isLouZu = @"1";
            }else{
                vc.isLouZu = @"0";
            }
            [vc setCallBack:^{
                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://app.co188.com/bbs/view.php?tid=",_tid]]]];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self goToEnterView];
        }
    }];

    //头像点击
    [_bridge registerHandler:@"getPersonMessageFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *uid = [NSString stringWithFormat:@"%@",data[@"uId"]];
        PersionMessageViewController *vc = [PersionMessageViewController new];
        vc.idString = uid;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    //昵称点击
    [_bridge registerHandler:@"getPersonNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *uid = [NSString stringWithFormat:@"%@",data[@"uId"]];
        PersionMessageViewController *vc = [PersionMessageViewController new];
        vc.idString = uid;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    //别人头像点击
    [_bridge registerHandler:@"getDiscussMessageFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *uid = [NSString stringWithFormat:@"%@",data[@"uId"]];
        PersionMessageViewController *vc = [PersionMessageViewController new];
        vc.idString = uid;
        [self.navigationController pushViewController:vc animated:YES];
    }];


    _rightbtn.selected = !_rightbtn.selected;
    if(_rightbtn.selected){
        _hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode=MBProgressHUDAnimationFade;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@&authorid=%@",@"http://app.co188.com/bbs/view.php?tid=",_tid,_authorid]]]];
        
    }else{
        _hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode=MBProgressHUDAnimationFade;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://app.co188.com/bbs/view.php?tid=",_tid]]]];
    }
}
-(void)createUI
{
    if (_bridge) { return; }
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64 - 49)];
    
    _webView.backgroundColor = Ae1e2e6;
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
//    [self callHandler:nil];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
//    NSLog(@"%@",messageDic);
    [_bridge callHandler:@"getUser" data:messageDic responseCallback:^(id responseData) {
        NSLog(@"from js: %@", responseData);
    }];
    //获取web端的返回消息
    //第一个功能跳转
    [_bridge registerHandler:@"getGoNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"okback  %@", data);
        NSDictionary *dic = (NSDictionary *)data;
        CommunityDetailController *vc = [CommunityDetailController new];
        vc.type = @"Detail";
        vc.fid = dic[@"secondlevel"];
        vc.firstId = dic[@"onelevel"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    //打赏功能
    [_bridge registerHandler:@"getRewardNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"okback  %@", data);
        NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
        if(str.length > 0){
            RewardViewController *vc = [RewardViewController new];
            vc.tid = _tid;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
           [self goToEnterView];
        }
    }];
    //点赞功能
    [_bridge registerHandler:@"getLikeNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"okback  %@", data);
        NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
        if(str.length > 0){
            NSMutableDictionary *messageDic = [MessageTool getMessage];
            responseCallback(messageDic);
        }else{
           [self goToEnterView];
        }
    }];
    //评论功能
    [_bridge registerHandler:@"getDiscussNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"okback  %@", data);
        NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
        if(str.length > 0){
            RepliesViewController *vc = [RepliesViewController new];
            vc.name = @"楼主";
            vc.tid = _tid;
            if(_rightbtn.selected){
                vc.isLouZu = @"1";
            }else{
                vc.isLouZu = @"0";
            }
            [vc setCallBack:^{
                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://app.co188.com/bbs/view.php?tid=",_tid]]]];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self goToEnterView];
        }
    }];
    //举报功能
    [_bridge registerHandler:@"getReportNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"okback  %@", data);
        NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
        if(str.length > 0){
            JuBaoViewController *vc = [JuBaoViewController new];
            NSLog(@"%@   %@",data[@"PostId"],data[@"Postfid"]);
            vc.tid = [NSString stringWithFormat:@"%@",data[@"PostId"]];
            vc.fid = [NSString stringWithFormat:@"%@",data[@"Postfid"]];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self goToEnterView];
        }
    }];
    //回复功能
    [_bridge registerHandler:@"getReplyNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"okback  %@", data);
        NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
        if(str.length > 0){
            RepliesViewController *vc = [RepliesViewController new];
            vc.name = data[@"replyAuthor"];
            vc.tid = _tid;
            vc.pid = data[@"replyPid"];
            vc.isHuiFu = @"1";
            if(_rightbtn.selected){
                vc.isLouZu = @"1";
            }else{
                vc.isLouZu = @"0";
            }
            [vc setCallBack:^{
                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://app.co188.com/bbs/view.php?tid=",_tid]]]];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self goToEnterView];
        }
    }];
    
    //头像点击
    [_bridge registerHandler:@"getPersonMessageFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"okback  %@", data);
//        NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
//        if(str.length > 0){
//            NSString *uid = [NSString stringWithFormat:@"%@",data[@"uId"]];
//            PersionMessageViewController *vc = [PersionMessageViewController new];
//            vc.idString = uid;
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        }else{
//            [self goToEnterView];
//        }
        NSString *uid = [NSString stringWithFormat:@"%@",data[@"uId"]];
        PersionMessageViewController *vc = [PersionMessageViewController new];
        vc.idString = uid;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    //昵称点击
    [_bridge registerHandler:@"getPersonNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *uid = [NSString stringWithFormat:@"%@",data[@"uId"]];
        PersionMessageViewController *vc = [PersionMessageViewController new];
        vc.idString = uid;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    //别人头像点击
    [_bridge registerHandler:@"getDiscussMessageFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"okback  %@", data);
//        NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
//        if(str.length > 0){
//            NSString *uid = [NSString stringWithFormat:@"%@",data[@"uId"]];
//            PersionMessageViewController *vc = [PersionMessageViewController new];
//            vc.idString = uid;
//            [self.navigationController pushViewController:vc animated:YES];
//
//        }else{
//            [self goToEnterView];
//        }
        NSString *uid = [NSString stringWithFormat:@"%@",data[@"uId"]];
        PersionMessageViewController *vc = [PersionMessageViewController new];
        vc.idString = uid;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self loadExamplePage:_webView];
    UIView *footorView = [[UIView alloc]initWithFrame:CGRectMake(0, WIN_HEIGHT - 49, WIN_WIDTH, 49)];
    footorView.backgroundColor = Af4f5f9;
    [self.view addSubview:footorView];
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(12, 7.5, WIN_WIDTH/2 - 12, 35)];
    textView.userInteractionEnabled = YES;
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(talkBack)];
    [textView addGestureRecognizer:Tap];
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.cornerRadius = 3;
    textView.layer.borderColor = Ad6d6d6.CGColor;
    textView.layer.borderWidth = 0.5;
    [footorView addSubview:textView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(7.5, 0, textView.frame.size.width - 15, 35)];
    label.text = @"回复楼主";
    label.textColor = Ac6c6c6;
    label.font = [UIFont systemFontOfSize:15];
    [textView addSubview:label];
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/2, 7.5, WIN_WIDTH/4, 35)];
    [shareBtn setImage:[UIImage imageNamed:@"share-1"] forState:UIControlStateNormal];
    shareBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [shareBtn setTitleColor:A666 forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [footorView addSubview:shareBtn];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shareBtn.frame), 14, 0.5, 22)];
    line.backgroundColor = Ad6d6d6;
    [footorView addSubview:line];
    
    UIButton *shangBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line.frame), 7.5, WIN_WIDTH/4, 35)];
    [shangBtn setTitleColor:A666 forState:UIControlStateNormal];
    shangBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);
    shangBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [shangBtn setImage:[UIImage imageNamed:@"money"] forState:UIControlStateNormal];
    [shangBtn setTitle:@"打赏" forState:UIControlStateNormal];
    [shangBtn addTarget:self action:@selector(shangAction) forControlEvents:UIControlEventTouchUpInside];
    [footorView addSubview:shangBtn];
}

- (void)loadExamplePage:(UIWebView*)webView {
    _hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode=MBProgressHUDAnimationFade;
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://app.co188.com/bbs/view.php?tid=",_tid]]]];
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",@"http://app.co188.com/bbs/view.php?tid=",_tid]);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    _rBtn.userInteractionEnabled = YES;
}
#pragma mark-回复
-(void)talkBack{
    NSString *ticket = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(ticket.length >0){
        RepliesViewController *vc = [RepliesViewController new];
        vc.name = @"楼主";
        vc.tid = _tid;
        if(_rightbtn.selected){
            vc.isLouZu = @"1";
        }else{
            vc.isLouZu = @"0";
        }
        [vc setCallBack:^{
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://app.co188.com/bbs/view.php?tid=",_tid]]]];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self goToEnterView];
    }
}

-(void)backClick{
    if([_comeFrom isEqualToString:@"1"]){
        _callBack();
    }
    [[NSURLCache  sharedURLCache ] removeAllCachedResponses];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 分享
-(void)shareAction:(UIButton *)Btn
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

-(void)weiXinShare:(UIButton *)btn
{
    NSString *str = [NSString stringWithFormat:@"%@%@%@",@"http://m.co188.com/bbs/thread-",_tid,@"-1-1.html"];
    if(btn.tag == 10){
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = _titleStr;
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imgUrl]];
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
        message.title = _titleStr;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imgUrl]];
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
-(void)xiaoxi:(UIButton *)btn
{
    _isCover = !_isCover;
    if(_isCover){
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64)];
        [self.view addSubview:backView];
        backView.userInteractionEnabled = YES;
          UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAction)];
        [backView addGestureRecognizer:tap];
        _coverView = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH - 165, 0, 157, 162)];
        _coverView.userInteractionEnabled = YES;
        _coverView.image = [UIImage imageNamed:@"kuang"];
        //    _coverView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
        [backView addSubview:_coverView];
        
        UIButton *upButtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, _coverView.frame.size.width, 53.5)];
        upButtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 30);
        upButtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        [upButtn setTitle:@"刷新" forState:UIControlStateNormal];
        [upButtn setImage:[UIImage imageNamed:@"Refresh"] forState:UIControlStateNormal];
        [upButtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        upButtn.titleLabel.font = [UIFont systemFontOfSize:18];
        upButtn.tag = 100;
        _button = upButtn;
        [upButtn addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
        [_coverView addSubview:upButtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(upButtn.frame), 157 - 26, 0.5)];
        line.backgroundColor = FD1;
        [_coverView addSubview:line];
        
        UIButton *downButtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(upButtn.frame), _coverView.frame.size.width, 53.5)];
        downButtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 30);
        downButtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        [downButtn setImage:[UIImage imageNamed:@"Collection"] forState:UIControlStateNormal];
        if([_collected isEqualToString:@"yes"]){
            [downButtn setTitle:@"取消" forState:UIControlStateNormal];
        }else{
            [downButtn setTitle:@"收藏" forState:UIControlStateNormal];
        }
        
        [downButtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        downButtn.tag = 200;
        downButtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [downButtn addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
        [_coverView addSubview:downButtn];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(downButtn.frame), 157 - 26, 0.5)];
        line1.backgroundColor = FD1;
        [_coverView addSubview:line1];
        UIButton *lastButtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame), _coverView.frame.size.width, 48.5)];
        lastButtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 30);
        lastButtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        [lastButtn setImage:[UIImage imageNamed:@"Report"] forState:UIControlStateNormal];
        [lastButtn setTitle:@"举报" forState:UIControlStateNormal];
        [lastButtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lastButtn.tag = 300;
        lastButtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [lastButtn addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
        [_coverView addSubview:lastButtn];
    }else{
        [backView removeFromSuperview];
    }
}

-(void)Action:(UIButton *)button
{
    _isCover = !_isCover;
    [backView removeFromSuperview];
    if(button.tag == 100){
//        if(_button == button){
//            
//        } else
//        {
//            if(_button.selected){
//                _button.selected = !_button.selected;
//            }
//            button.selected = !button.selected;
//            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://app.co188.com/bbs/view.php?tid=",_tid]]]];
//            
//            _button = button;
//        }
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://app.co188.com/bbs/view.php?tid=",_tid]]]];
        _button = button;
    }
    else if (button.tag == 200){
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode=MBProgressHUDAnimationFade;
        NSString *urlString = @"http://app.co188.com/bbs/view.php?action=favorite";
        SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
        //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
        NSMutableDictionary *messageDic = [MessageTool getMessage];
        [messageDic setObject:_tid forKey:@"tid"];
        [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@",responseObject);
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if([code isEqualToString:@"0"]){
                NSDictionary *dic = responseObject[@"data"];
                NSString *collected = dic[@"collected"];
                _collected = collected;
                if([collected isEqualToString:@"yes"]){
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"已取消收藏" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"isFavourite" object:nil];
            }else if([code isEqualToString:@"500"]){
                [tools alert:responseObject[@"msg"]];
            }else if([code isEqualToString:@"401"]){
                [tools alert:responseObject[@"msg"]];
            }else{
                [tools alert:responseObject[@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else{
        JuBaoViewController *vc = [JuBaoViewController new];
        vc.tid = _tid;
        vc.fid = _authorid;
        vc.juBaoLou = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)shangAction
{
    NSString *ticket = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(ticket.length >0){
        RewardViewController *vc = [RewardViewController new];
        vc.tid = _tid;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self goToEnterView];
    }
}

-(void)goToEnterView
{
    EnterViewController *vc = [EnterViewController new];
    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:Nav animated:YES completion:nil];
}
-(void)touchAction
{
    [backView removeFromSuperview];
}

-(void)shuaxin
{
     [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://app.co188.com/bbs/view.php?tid=",_tid]]]];
}

@end

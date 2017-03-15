//
//  SCCWebViewController.m
//  SCCBBS
//
//  Created by co188 on 17/2/6.
//  Copyright © 2017年 co188. All rights reserved.
//

#import "SCCWebViewController.h"
#import "SCCHeader.h"
@interface SCCWebViewController ()<UIWebViewDelegate>
{
    UILabel *_label;
    UIButton *_leftBtn;
    UIWebView *_webView;
}

@end

@implementation SCCWebViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    NSString *url=@"https://api.weibo.com/oauth2/authorize?client_id=4281350467&response_type=code&redirect_uri=http://co188.com";
    // client_id、redirect_uri后面的分别是App Key和回调页面，每个人的都是不同的，具体去微博开放平台查看
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64)];
    [self.view addSubview:_webView];
    [_webView setDelegate:self];
    [_webView loadRequest:request];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"微博登录";
    _label.textAlignment = NSTextAlignmentCenter;
    
    _label.font = [UIFont systemFontOfSize:18];//[UIFont fontWithName:@"STHeitiTC-Light" size:20];
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
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebView Delegate Methods

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *url = webView.request.URL.absoluteString;
    NSLog(@"absoluteString:%@",url);
    
    if ([url hasPrefix:@"https://api.weibo.com/oauth2/default.html?"]) {
        
        //找到”code=“的range
        NSRange rangeOne;
        rangeOne=[url rangeOfString:@"code="];
        
        //根据他“code=”的range确定code参数的值的range
        NSRange range = NSMakeRange(rangeOne.length+rangeOne.location, url.length-(rangeOne.length+rangeOne.location));
        //获取code值
        NSString *codeString = [url substringWithRange:range];
        NSLog(@"code = :%@",codeString);
        
        //access token调用URL的string
        NSMutableString *muString = [[NSMutableString alloc] initWithString:@"https://api.weibo.com/oauth2/access_token?client_id=4281350467&client_secret=53eb738048c92d0ae8badd2a91e4ce5a&grant_type=authorization_code&redirect_uri=https://co188.com&code="];
        // client_id、client_secret、redirect_uri后面的分别是App Key、App Secret、回调页面
        [muString appendString:codeString];
        NSLog(@"access token url :%@",muString);
        
        //第一步，创建URL
        NSURL *urlstring = [NSURL URLWithString:muString];
        //第二步，创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:urlstring cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str = @"type=focus-c";//设置参数
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        //第三步，连接服务器
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSError *error;
        //如何从str1中获取到access_token、uid
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:&error];
        
        NSString *_access_token = [dictionary objectForKey:@"access_token"];
        NSString *uid=[dictionary objectForKey:@"uid"];
        NSLog(@"%@   %@",_access_token,uid);
        //如果获取到access_token，则授权成功，接下来是获取微博用户数据，与上面类似
        if(_access_token)
        {
            //根据微博开放平台的要求，填写相应数据
            NSString *str2=[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",_access_token,uid];
            NSURL *url2 = [NSURL URLWithString:str];
            NSMutableURLRequest *request2= [[NSMutableURLRequest alloc]initWithURL:url2 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            [request2 setHTTPMethod:@"POST"];
            NSData *received2= [NSURLConnection sendSynchronousRequest:request2 returningResponse:nil error:nil];
            NSDictionary *dictionary2 = [NSJSONSerialization JSONObjectWithData:received2 options:NSJSONReadingMutableContainers error:&error];
            //输出接收到的字典，根据需要取相应的值
            NSLog(@"%@",dictionary);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL.absoluteString);
//    if([request.URL.absoluteString rangeOfString:@"———————"].location !=NSNotFound)
//    {
//        //微博登陆
//        NSString *account=nil,*token=nil,*nickName=nil;
//        NSArray *array=[request.URL.query componentsSeparatedByString:@"&"];
//        for (int i=0; i<[array count]; i++)
//        {
//            NSString *str=[array objectAtIndex:i];
//            if([str hasPrefix:@"account="])
//            {
//                account=[str substringFromIndex:8];
//            }
//            else if([str hasPrefix:@"token="])
//            {
//                token=[str substringFromIndex:6];
//            }
//            else if([str hasPrefix:@"nickname="])
//            {
//                nickName=[str substringFromIndex:9];
//            }
//        }
//        NSLog(@"%@  %@  %@",account,token,nickName);
//    }
    //微博登陆
    NSString *account=nil,*token=nil,*nickName=nil;
    NSArray *array=[request.URL.query componentsSeparatedByString:@"&"];
    NSLog(@"%@",array);
    for (int i=0; i<[array count]; i++)
    {
        NSString *str=[array objectAtIndex:i];
        if([str hasPrefix:@"account="])
        {
            account=[str substringFromIndex:8];
        }
        else if([str hasPrefix:@"token="])
        {
            token=[str substringFromIndex:6];
        }
        else if([str hasPrefix:@"nickname="])
        {
            nickName=[str substringFromIndex:9];
        }
    }
    NSLog(@"%@  %@  %@",account,token,nickName);
    return YES;
}
@end

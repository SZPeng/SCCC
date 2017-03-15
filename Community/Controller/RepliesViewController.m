//
//  RepliesViewController.m
//  SCCBBS
//
//  Created by co188 on 16/11/28.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "RepliesViewController.h"
#import "SCCHeader.h"
#import "TextView.h"
#import "CXXChooseImageViewController.h"
#import <MBProgressHUD.h>
#import "SCCAFnetTool.h"
#import "tools.h"
#import "MessageTool.h"

@interface RepliesViewController ()<CXXChooseImageViewControllerDelegate,UIAlertViewDelegate>
{
    UIView *_headView;
    UILabel *_label;
    UIButton *_leftBtn;
    UIButton *_rightBtn;
    TextView *_textView;
    UIButton *_camBtn;
    UIButton *_picBtn;
    UIScrollView *_backView;
    
    UIButton *_quBtn;
    UIView *_bottomView;
    
    NSMutableArray *_pictureArray;
}
@property (nonatomic, strong) CXXChooseImageViewController *vc;
@end

@implementation RepliesViewController

-(void)viewWillAppear:(BOOL)animated{
    
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
        _pictureArray = [NSMutableArray new];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHiden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,WIN_WIDTH ,64 )];
    _headView.backgroundColor = TMHEADCOLO;
    [self.view addSubview:_headView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.text = @"回复";
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
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 45, 0, 44, 44)];
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightBtn setImage:[UIImage imageNamed:@"Ellipsis"]  forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(faBuAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.center = CGPointMake(rightBtn.center.x, _label.center.y);
    [_headView addSubview:rightBtn];
    
//    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 64)];
//    if([_isLouZu isEqualToString:@"1"]){
//        headImg.image = [UIImage imageNamed:@"nav-1"];
//    }else{
//       headImg.image = [UIImage imageNamed:@"nav"];
//    }
//    [_headView addSubview:headImg];
    [self createUI];
}

-(void)createUI
{
    _backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64)];
    _backView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.98f alpha:1.00f];
    [self.view addSubview:_backView];
    
    UIButton *deleBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, 13, 44, 44)];
    deleBtn.layer.cornerRadius = 4;
    deleBtn.clipsToBounds = YES;
    [deleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [deleBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [deleBtn setTitleColor:A333 forState:UIControlStateNormal];
//    [_backView addSubview:deleBtn];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/2 - 30, 13, 44, 44)];
    [btn setTitle:@"回复" forState:UIControlStateNormal];
    [btn setTitleColor:A333 forState:UIControlStateNormal];
//    [_backView addSubview:btn];
    
    UIButton *fBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH - 85, 16, 70, 33)];
    [fBtn setTitle:@"发送" forState:UIControlStateNormal];
    [fBtn setTitleColor:A008cee forState:UIControlStateNormal];
    fBtn.layer.cornerRadius = 3;
    fBtn.layer.borderWidth = 0.5;
    [fBtn addTarget:self action:@selector(faBuAction) forControlEvents:UIControlEventTouchUpInside];
    fBtn.layer.borderColor = A008cee.CGColor;
//    [_backView addSubview:fBtn];
    
    _textView = [[TextView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH - 0, 254)];
    _textView.placeHolder = [NSString stringWithFormat:@"回复 %@",_name];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textColor = [UIColor lightGrayColor];
    [_backView addSubview:_textView];
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.borderWidth = 0.5;
    
    _camBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_textView.frame) + 12, 30, 25)];
    [_camBtn setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [_camBtn addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_camBtn];
    
#pragma mark-表情
    _picBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_camBtn.frame)+32, CGRectGetMaxY(_textView.frame) + 12, 25, 25)];
    [_picBtn setBackgroundImage:[UIImage imageNamed:@"biaoqing"] forState:UIControlStateNormal];
//    [_backView addSubview:_picBtn];
    
    if ((WIN_HEIGHT - 64 -  CGRectGetMaxY(_camBtn.frame)-12) < 262){
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_camBtn.frame) + 12, WIN_WIDTH, 262)];
    }else{
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_camBtn.frame) + 12, WIN_WIDTH, WIN_HEIGHT - 64 -  CGRectGetMaxY(_camBtn.frame)-12)];
    }
    _bottomView.backgroundColor = Aefefef;
    [_backView addSubview:_bottomView];
    
    CXXChooseImageViewController *vc = [[CXXChooseImageViewController alloc] init];
    vc.delegate = self;
    self.vc = vc;
    [self addChildViewController:vc];
    
    [vc setOrigin:CGPointMake(0, 50) ItemSize:CGSizeMake(69, 67) rowCount:4]; //注意要满足 ItemSize的宽度 * rowCount < 屏幕宽度
    [_bottomView addSubview:vc.view];
    
    vc.maxImageCount = 9;
    
    _quBtn = [[UIButton alloc]initWithFrame:CGRectMake(24, _bottomView.frame.size.height - 66, WIN_WIDTH - 48, 48)];
    _quBtn.layer.cornerRadius = 4;
    _quBtn.clipsToBounds = YES;
    [_quBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_quBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _quBtn.backgroundColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
    [_quBtn addTarget:self action:@selector(removeAll) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_quBtn];
    
    _backView.contentSize = CGSizeMake(WIN_WIDTH, CGRectGetMaxY(_bottomView.frame));
    
    [_textView becomeFirstResponder];
}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    _backView.contentSize = CGSizeMake(WIN_WIDTH, WIN_HEIGHT - 64);
    _bottomView.hidden = YES;
    NSDictionary *userInfo = [aNotification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.size.height;
    NSLog(@"%lf  %lf",WIN_HEIGHT- keyboardTop,CGRectGetMaxY(_camBtn.frame) + 64);
    if((CGRectGetMaxY(_camBtn.frame) + 64) > WIN_HEIGHT- keyboardTop){
        CGFloat height = (CGRectGetMaxY(_camBtn.frame) + 64) - keyboardTop;
        [UIView animateWithDuration:0.1 animations:^{
            
        } completion:^(BOOL finished) {
            
            _textView.frame = CGRectMake(0, 0, WIN_WIDTH - 0, 254-height + 30);
            _camBtn.frame = CGRectMake(12, CGRectGetMaxY(_textView.frame) + 12, 30, 25);
            _picBtn.frame = CGRectMake(CGRectGetMaxX(_camBtn.frame)+32, CGRectGetMaxY(_textView.frame) + 12, 25, 25);
        }];
        
    }
  
}

-(void)keyboardWillHiden:(NSNotification *)aNotification
{
    _backView.contentSize = CGSizeMake(WIN_WIDTH, CGRectGetMaxY(_bottomView.frame));
    [UIView animateWithDuration:0.1 animations:^{
        
    } completion:^(BOOL finished) {
        
        _bottomView.hidden = NO;
        _textView.frame = CGRectMake(0, 0, WIN_WIDTH - 0, 254);
        _camBtn.frame = CGRectMake(12, CGRectGetMaxY(_textView.frame) + 12, 30, 25);
        _picBtn.frame = CGRectMake(CGRectGetMaxX(_camBtn.frame)+32, CGRectGetMaxY(_textView.frame) + 12, 25, 25);
    }];

}

- (void)chooseImageViewControllerDidChangeCollectionViewHeigh:(CGFloat)height{
    NSLog(@"%lf",height);
    [_pictureArray removeAllObjects];
    self.vc.view.frame =  CGRectMake(0, 50, [[UIScreen mainScreen] bounds].size.width, height);
    if(_vc.dataArr.count /4 > 0){
        _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_camBtn.frame) + 12, WIN_WIDTH, 166+height);
        _quBtn.frame = CGRectMake(24, _bottomView.frame.size.height - 66, WIN_WIDTH - 48, 48);
        [_bottomView addSubview:_quBtn];
        
        _backView.contentSize = CGSizeMake(WIN_WIDTH, CGRectGetMaxY(_bottomView.frame));
    }
    NSLog(@"%@",_vc.dataArr);
    NSMutableArray *imgStrArr = [NSMutableArray new];
    for(UIImage *img in _vc.dataArr){
        NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
        //    NSString *imageString = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
        
        NSString *imageString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        [imgStrArr addObject:imageString];
    }
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    
    NSString *urlString = @"https://app.co188.com/bbs/pub.php?action=upimg";
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:imgStrArr forKey:@"imgArray"];
    [afTool postMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *codeStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([codeStr isEqualToString:@"0"]){
            NSDictionary *dic = responseObject[@"data"];
            NSArray *picArr = dic[@"picurl"];
            for(NSString *str in picArr){
                [_pictureArray addObject:str];
            }
        }else{
            [tools alert:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError* _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

-(void)photoAction
{
    [_textView resignFirstResponder];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)faBuAction
{
    [_textView resignFirstResponder];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = @"https://app.co188.com/bbs/pub.php?action=newpost";
    NSLog(@"%@",_tid);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:_tid forKey:@"tid"];
    if([_isHuiFu isEqualToString:@"1"]){
        [messageDic setObject:_pid forKey:@"pid"];
    }
    if(_pictureArray.count > 0){
        [messageDic setObject:_pictureArray forKey:@"pic"];
    }else{
        [messageDic setObject:@"" forKey:@"pic"];
    }
    NSString *str = _textView.text;
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [messageDic setObject:str forKey:@"message"];
    if(_textView.text.length > 0){
        [afTool postMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *codeStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if([codeStr isEqualToString:@"0"]){
                _callBack();
                [[NSNotificationCenter defaultCenter]postNotificationName:@"huiFu" object:nil];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"发表成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                
            }else{
                [tools alert:responseObject[@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError* _Nonnull error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];

    }else{
        [tools alert:@"请输入回复的内容"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0)
{
    
    [self backClick];
    [_textView resignFirstResponder];
}

-(void)removeAll
{
    [_pictureArray removeAllObjects];
    [_vc removeAllPhoto];
    [_textView becomeFirstResponder];
}
-(void)xiaoxi
{
    
}
@end

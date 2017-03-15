//
//  FaTieViewController.m
//  SCCBBS
//
//  Created by co188 on 16/11/28.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "FaTieViewController.h"
#import "SCCHeader.h"
#import "TextView.h"
#import "CXXChooseImageViewController.h"
#import <MBProgressHUD.h>
#import "SCCAFnetTool.h"
#import "tools.h"
#import "MessageTool.h"

@interface FaTieViewController ()<CXXChooseImageViewControllerDelegate,UIAlertViewDelegate>
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
    
    UITextField *_titleFed;
    
    UIView *_coverView;
    
    NSMutableArray *_pictureArray;
}

@property (nonatomic, strong) CXXChooseImageViewController *vc;

@end

@implementation FaTieViewController

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
        _pictureArray = [[NSMutableArray alloc]init];
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
    _label.text = @"发表帖子";
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
//    [rightBtn setImage:[UIImage imageNamed:@"Ellipsis"]  forState:UIControlStateNormal];
    [rightBtn setTitle:@"发表" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(faBiao) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.center = CGPointMake(rightBtn.center.x, _label.center.y);
    [_headView addSubview:rightBtn];

    [self createUI];
}

-(void)createUI
{
    _backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT - 64)];
    [self.view addSubview:_backView];
    
    _titleFed = [[UITextField alloc]initWithFrame:CGRectMake(12, 0, WIN_WIDTH - 24, 40)];
    _titleFed.placeholder = @"标题";
    _titleFed.textColor = [UIColor grayColor];
    _titleFed.font = [UIFont systemFontOfSize:16];
    [_backView addSubview:_titleFed];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_titleFed.frame), WIN_WIDTH - 24, 0.5)];
    line.backgroundColor = LINECOLOR;
    [_backView addSubview:line];
    
    _textView = [[TextView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(line.frame), WIN_WIDTH - 16, 189)];
    _textView.placeHolder = @"请输入帖子内容";
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.textColor = [UIColor lightGrayColor];
    [_backView addSubview:_textView];
    _textView.layer.borderWidth = 0;
    
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
    [_titleFed becomeFirstResponder];

}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
//    _coverView = [[UIView alloc]initWithFrame:_headView.frame];
//    _coverView.backgroundColor = [UIColor colorWithRed:0.00f green:0.55f blue:0.93f alpha:1.00f];
//    _coverView.alpha = 0.3;
    [self.view addSubview:_coverView];
    _bottomView.hidden = YES;
    _backView.contentSize = CGSizeMake(WIN_WIDTH, WIN_HEIGHT - 64);
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.size.height;
    NSLog(@"%lf  %lf",WIN_HEIGHT- keyboardTop,CGRectGetMaxY(_camBtn.frame) + 64);
    if((CGRectGetMaxY(_camBtn.frame) + 64) > WIN_HEIGHT- keyboardTop){
        CGFloat height = (CGRectGetMaxY(_camBtn.frame) + 64) - keyboardTop;
        [UIView animateWithDuration:0.1 animations:^{
            
        } completion:^(BOOL finished) {
            
            _textView.frame = CGRectMake(8, 40.5, WIN_WIDTH - 16, 189-height + 30);
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
        _textView.frame = CGRectMake(8, 40.5, WIN_WIDTH - 16, 189);
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
    NSMutableArray *imgStrArr = [NSMutableArray new];
    for(UIImage *img in _vc.dataArr){
        NSData *imageData = UIImageJPEGRepresentation(img, 1.0);
        //    NSString *imageString = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
        
        NSString *imageString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        [imgStrArr addObject:imageString];
    }
    NSLog(@"%@",imgStrArr);
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
    [_titleFed resignFirstResponder];
    [_textView resignFirstResponder];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)faBiao
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationFade;
    NSString *urlString = @"https://app.co188.com/bbs/pub.php?action=newthread";
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:_fid forKey:@"fid"];
    NSString *str = _titleFed.text;
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *detailStr = _textView.text;
    detailStr = [detailStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [messageDic setObject:str forKey:@"subject"];
    [messageDic setObject:detailStr forKey:@"message"];
    NSLog(@"%@",_pictureArray);
    if(_pictureArray.count > 0){
        [messageDic setObject:_pictureArray forKey:@"pic"];
    }else{
        [messageDic setObject:@[] forKey:@"pic"];
    }
    NSLog(@"%@",messageDic);
    if(_titleFed.text.length > 0){
        if(_textView.text.length > 0){
            [afTool postMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                 NSString *codeStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                if([codeStr isEqualToString:@"0"]){
                    _callBack();
                    [_textView resignFirstResponder];
                    [_titleFed resignFirstResponder];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"发表成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];

                }else{
                    [tools alert:responseObject[@"msg"]];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError* _Nonnull error) {
                NSLog(@"%@",error);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];

        }else {
            [tools alert:@"请输入内容"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }else {
        [tools alert:@"请输入标题"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0)
{
    [self backClick];
}

-(void)removeAll
{
    [_pictureArray removeAllObjects];
    [_vc removeAllPhoto];
    [_textView becomeFirstResponder];
}


@end

//
//  MyTableBarController.m
//  SCCQuShan
//
//  Created by HitoiMac001 on 16/6/8.
//  Copyright © 2016年 HitoiMac001. All rights reserved.
//

#import "MyTableBarController.h"
#import "HomeViewController.h"
#import "CommunityViewController.h"
#import "FocusViewController.h"
#import "MineViewController.h"
#import "MyButton.h"
#import "EnterViewController.h"
@interface MyTableBarController ()
{
    UIImageView *_myTableBar;
    UIImageView *_imageView;
    UIButton *_button;
    NSString *_str;
}
@end

@implementation MyTableBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createAllControllers];
    
    [self createMyTableBar];
    
    [self createTabBars];
    
    //homeBack
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enter) name:@"enter" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(choiceSend:)name:@"choiceSend"object:nil];
    
    //backHome
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeComeBack)name:@"backHomeView"object:nil];

}

-(void)createAllControllers
{
    
    HomeViewController *homeVC = [HomeViewController new];
    [homeVC.navigationController setNavigationBarHidden:YES];
    homeVC.currentPage = 1;
    UINavigationController *homeNAV = [[UINavigationController alloc]initWithRootViewController:homeVC];
    
    CommunityViewController *GetFoodVC = [CommunityViewController new];
    [GetFoodVC.navigationController setNavigationBarHidden:YES];
    GetFoodVC.currentPage = 2;
    UINavigationController *GetFoodNAV = [[UINavigationController alloc]initWithRootViewController:GetFoodVC];
    
    FocusViewController *VIPController = [FocusViewController new];
    VIPController.currentPage = 3;
    UINavigationController  *vipNAV = [[UINavigationController alloc]initWithRootViewController:VIPController];
    
    MineViewController *shopController = [MineViewController new];
    shopController.currentPage = 4;
    UINavigationController  *shopControllerNAV = [[UINavigationController alloc]initWithRootViewController:shopController];

    self.viewControllers = @[homeNAV,GetFoodNAV,vipNAV,shopControllerNAV];
}

-(void)createMyTableBar
{
    self.tabBar.backgroundColor = [UIColor clearColor];
    _myTableBar  =  [[UIImageView alloc]initWithFrame:self.tabBar.bounds];
    NSLog(@"%f",self.tabBar.bounds.size.height);
    _myTableBar.image = [UIImage imageNamed:@"bg_tab"];
    _myTableBar.backgroundColor = [UIColor whiteColor];
    _myTableBar.userInteractionEnabled = YES;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _myTableBar.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    [self.tabBar addSubview:_myTableBar];
    [self.tabBar addSubview:line];
}
-(void)createTabBars
{
    NSArray *titleArray = @[@"首页",@"社区",@"关注",@"我的"];
    NSArray *nomalArray = @[@"home-unselected-1",@"community-unselect",@"concern-unselect",@"home-unselected"];
    NSArray *selectedArray = @[@"home-selected-1",@"community-select",@"concern-select",@"home-selected"];
    CGFloat width = self.view.frame.size.width / (titleArray.count );
    for(int i = 0;i<titleArray.count;i++)
    {
        MyButton  *button = [[MyButton alloc]initWithFrame:CGRectMake(width * i, 0, width, 44)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:nomalArray[i]] forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:selectedArray[i]] forState:UIControlStateSelected ];
        
        button.tag = 100 + i;
        if(i == 0){
            button.selected = YES;
            _button = button;
        }
        [button addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_myTableBar addSubview:button];
    }
}
-(void)BtnAction:(MyButton *)btn
{
    NSInteger index = btn.tag - 100;
    if (index==3) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"denglu" object:nil];

    }else if(index == 2){
         [[NSNotificationCenter defaultCenter]postNotificationName:@"guanZhu" object:nil];
    }
//        else{
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"4" object:nil];
//        }
//        _str = @"0";
//        
//    }else if(index == 1)
//    {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"1" object:nil];
//    }else if(index == 2){
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"vipXuanCai" object:nil];
//    }
    if(_button != btn){
        _button.selected = NO;
    }
    btn.selected = YES;
//    NSLog(@"%@",[LoginTools sharedUdowsTools].verify);

    self.selectedIndex = index;
    _button = btn;
}

- (void)choiceSend:(NSNotification *)noti{
    
    [UIView animateWithDuration:0.15 animations:^{
        
    } completion:^(BOOL finished) {
        MyButton *btn = (MyButton *)[_myTableBar viewWithTag:101];
        [self BtnAction:btn];
    }];
}
-(void)homeComeBack
{
    [UIView animateWithDuration:0.15 animations:^{
        
    } completion:^(BOOL finished) {
        MyButton *btn = (MyButton *)[_myTableBar viewWithTag:100];
        [self BtnAction:btn];
    }];

}
-(void)enter
{
//    MyButton *btn = (MyButton *)[_myTableBar viewWithTag:100];
//    [self BtnAction:btn];
}


@end

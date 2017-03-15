//
//  HTTPRequestManager.m
//  我爱看电影
//
//  Created by KevinHan on 31/8/15.
//  Copyright (c) 2015年 chunchendeMac. All rights reserved.
//


#import "SCCImagePickerController.h"

@interface SCCImagePickerController ()

@end

@implementation SCCImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *string = @"相册";
    NSMutableAttributedString *str2=[[NSMutableAttributedString alloc]initWithString:string];
    
    [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0,2)];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    lable.attributedText = str2;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = lable;
    // Do any additional setup after loading the view.
}

#pragma mark- 修改状态栏
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault ;
}

@end

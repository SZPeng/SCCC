//
//  SCCTitleMenuViewController.m
//  YBZF
//
//  Created by chunchendeMac on 15/11/19.
//  Copyright © 2015年 ChunChen.App. All rights reserved.
//

#import "SCCTitleMenuViewController.h"
#import "SCCHeader.h"
#import "tools.h"
@interface SCCTitleMenuViewController ()

@end

@implementation SCCTitleMenuViewController
{
    UIButton *_button;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAll) name:@"GetAll" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(careAbout) name:@"careAbout" object:nil];
    [self uiConFig];
}

+(id)shareSccTitle
{
    static SCCTitleMenuViewController *sharedInstance = nil;
    if (!sharedInstance) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}


-(void)uiConFig
{
    UIButton *upButtn = [[UIButton alloc]initWithFrame:CGRectMake(-108, 0, self.view.frame.size.width, 51)];
    upButtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 30);
    upButtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    [upButtn setTitle:@"刷新" forState:UIControlStateNormal];
    [upButtn setImage:[UIImage imageNamed:@"Refresh"] forState:UIControlStateNormal];
    [upButtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    upButtn.titleLabel.font = [UIFont systemFontOfSize:18];
    upButtn.tag = 100;
    _button = upButtn;
    [upButtn addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upButtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(upButtn.frame), 157 - 10, 0.5)];
    line.backgroundColor = FD1;
    [self.view addSubview:line];
    
    UIButton *downButtn = [[UIButton alloc]initWithFrame:CGRectMake(-108, CGRectGetMaxY(upButtn.frame), self.view.frame.size.width, 51)];
    downButtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 30);
    downButtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    [downButtn setImage:[UIImage imageNamed:@"Collection"] forState:UIControlStateNormal];
    [downButtn setTitle:@"收藏" forState:UIControlStateNormal];
    [downButtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    downButtn.tag = 200;
    downButtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [downButtn addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downButtn];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(downButtn.frame), 157 - 10, 0.5)];
    line1.backgroundColor = FD1;
    [self.view addSubview:line1];
    UIButton *lastButtn = [[UIButton alloc]initWithFrame:CGRectMake(-108, CGRectGetMaxY(line1.frame) + 10, self.view.frame.size.width, 35)];
    lastButtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 30);
    lastButtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    [lastButtn setImage:[UIImage imageNamed:@"Report"] forState:UIControlStateNormal];
    [lastButtn setTitle:@"举报" forState:UIControlStateNormal];
    [lastButtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    lastButtn.tag = 300;
    lastButtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [lastButtn addTarget:self action:@selector(Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastButtn];

    
}



-(void)Action:(UIButton *)button
{
    if(button.tag == 100){
        if(_button == button){
            
        } else
        {
            if(_button.selected){
                _button.selected = !_button.selected;
                
            }
            button.selected = !button.selected;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"message" object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"remove" object:nil];
            _button = button;
        }
        

    }
    else if (button.tag == 200){
        if(_button == button){
            

        } else
        {
            if(_button.selected){
                _button.selected = !_button.selected;
            }
            button.selected = !button.selected;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"personCenter" object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"remove" object:nil];
            
            _button = button;
        }
    }else{
        
        if(_button == button){
            
            
        } else
        {
            if(_button.selected){
                _button.selected = !_button.selected;
            }
            button.selected = !button.selected;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeView" object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"remove" object:nil];
            
            _button = button;
        }

    }

}



-(void)back
{
    _Back();
}

@end

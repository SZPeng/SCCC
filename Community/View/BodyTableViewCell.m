//
//  BodyTableViewCell.m
//  SCCBBS
//
//  Created by co188 on 16/11/1.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "BodyTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "SCCHeader.h"
#import "SCCAFnetTool.h"
#import "MessageTool.h"
#import "tools.h"
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>
@implementation BodyTableViewCell

-(void)setModel:(BodyModel *)model
{
    _model = model;
    _titleLab.text = model.name;
    _titleLab.textColor = A333;
    NSString *todayPost = [NSString stringWithFormat:@"今日贴数: %@",model.todayposts];
    _lookLab.text = todayPost;
    _lookLab.textColor = A666;
    if([model.collected isEqualToString:@"no"]){
        [_favLab setImage:[UIImage imageNamed:@"hobby"] forState:UIControlStateNormal];
    }else{
        [_favLab setImage:[UIImage imageNamed:@"favorite-select"] forState:UIControlStateNormal];
    }
    _headImg.layer.cornerRadius = 3;
    _headImg.clipsToBounds = YES;
    _LineLab.backgroundColor = [UIColor colorWithRed:0.88f green:0.89f blue:0.90f alpha:1.00f];
    NSLog(@"%@",model.icon);
    if([model.icon isEqualToString:@"no"]){
        
    }else{
        [_headImg sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"图标"]];
    }
}
- (IBAction)favAction:(id)sender {
    NSString *urlString =[NSString stringWithFormat:@"%@%@",PHPHOST,@"favorite"];
    NSString *ticket = [[NSUserDefaults standardUserDefaults]valueForKey:@"sticket"];
    if(ticket.length >0){
        MBProgressHUD *hud;
        if([_name isEqualToString:@"1"]){
            hud = [MBProgressHUD showHUDAddedTo:_ViewC.view animated:YES];
        }else{
            hud = [MBProgressHUD showHUDAddedTo:_vc.view animated:YES];
        }
        
        hud.mode=MBProgressHUDAnimationFade;
        SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
        NSMutableDictionary *messageDic = [MessageTool getMessage];
        [messageDic setObject:_model.fid forKey:@"fid"];
        NSLog(@"%@",messageDic);
        [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            if([_name isEqualToString:@"1"]){
                [MBProgressHUD hideHUDForView:_ViewC.view animated:YES];
            }else{
               [MBProgressHUD hideHUDForView:_vc.view animated:YES];
            }
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if([code isEqualToString:@"0"]){
                NSDictionary *dic = responseObject[@"data"];
                NSString *collected = dic[@"collected"];
                if([collected isEqualToString:@"yes"]){
                    [_favLab setImage:[UIImage imageNamed:@"favorite-select"] forState:UIControlStateNormal];
                }else{
                    [_favLab setImage:[UIImage imageNamed:@"hobby"] forState:UIControlStateNormal];
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:@"changeFav" object:nil];
            }else{
                NSLog(@"%@",responseObject[@"msg"]);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError* _Nonnull error) {
            NSLog(@"%@",error);
            if([_name isEqualToString:@"1"]){
                [MBProgressHUD hideHUDForView:_ViewC.view animated:YES];
            }else{
               [MBProgressHUD hideHUDForView:_vc.view animated:YES];
            }
            
        }];
        
    }else{
        _callBack();
    }
}
@end

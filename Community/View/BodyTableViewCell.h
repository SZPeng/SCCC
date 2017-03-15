//
//  BodyTableViewCell.h
//  SCCBBS
//
//  Created by co188 on 16/11/1.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BodyModel.h"
#import "CommunityViewController.h"
#import "FocusViewController.h"
@interface BodyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *lookLab;
@property (weak, nonatomic) IBOutlet UIButton *favLab;
@property (weak, nonatomic) IBOutlet UILabel *LineLab;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,strong)CommunityViewController *vc;

@property(nonatomic,strong)FocusViewController *ViewC;

@property(nonatomic,strong)void(^callBack)();

@property(nonatomic,strong)BodyModel *model;

@end

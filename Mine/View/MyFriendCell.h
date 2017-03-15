//
//  MyFriendCell.h
//  SCCBBS
//
//  Created by co188 on 17/1/17.
//  Copyright © 2017年 co188. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFriendModel.h"

@interface MyFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *persionMes;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *qianLab;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;

@property(nonatomic,strong)MyFriendModel *model;
@property(nonatomic,strong)void(^callBack)(NSString *name);
@end

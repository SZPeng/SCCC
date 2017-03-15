//
//  SistemMessageCell.h
//  SCCBBS
//
//  Created by co188 on 16/11/11.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SistemMessage.h"
@interface SistemMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabHeight;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
@property(nonatomic,strong) SistemMessage *model;
@end

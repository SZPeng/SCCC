//
//  MyCallBackCell.h
//  SCCBBS
//
//  Created by co188 on 16/11/16.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCallBackModel.h"

@interface MyCallBackCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *PersionLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabHeight;

@property(nonatomic,strong)MyCallBackModel *model;
@end

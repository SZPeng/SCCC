//
//  GChenTableViewCell.h
//  SCCBBS
//
//  Created by co188 on 17/1/11.
//  Copyright © 2017年 co188. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GChenModel.h"

@interface GChenTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numlab;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;

@property(nonatomic,strong)GChenModel *model;

@end

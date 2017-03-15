//
//  MineTableViewCell.h
//  SCCBBS
//
//  Created by co188 on 16/11/8.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineModel.h"
@interface MineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UIImageView *headIMg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineWidth;

@property(nonatomic,copy)NSString *name;
@property(nonatomic,strong)MineModel *model;

@end

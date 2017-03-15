//
//  FPictrureCell.h
//  SCCBBS
//
//  Created by co188 on 16/11/24.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListModel.h"
@interface FPictrureCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageHeight;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property(nonatomic,strong)ListModel *model;

@end

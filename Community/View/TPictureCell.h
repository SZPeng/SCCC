//
//  TPictureCell.h
//  SCCBBS
//
//  Created by co188 on 16/11/24.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListModel.h"
@interface TPictureCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLab;
@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UIImageView *secImg;
@property (weak, nonatomic) IBOutlet UIImageView *thiImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageHeight;

@property(nonatomic,strong)ListModel *model;
@end

//
//  HomeTableViewCell.h
//  SCCBBS
//
//  Created by co188 on 16/10/31.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLab;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descripHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numWidth;

@property(nonatomic,strong)HomeModel *model;
@end

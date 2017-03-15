//
//  SearchCell.h
//  SCCBBS
//
//  Created by co188 on 16/11/23.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModle.h"
@interface SearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageHeigh;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timelab;
@property (weak, nonatomic) IBOutlet UILabel *biaoLab;

@property(nonatomic,strong)SearchModle *model;
@end

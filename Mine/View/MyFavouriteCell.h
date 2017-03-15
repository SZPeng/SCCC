//
//  MyFavouriteCell.h
//  SCCBBS
//
//  Created by co188 on 16/11/16.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCallBackModel.h"
@interface MyFavouriteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabHeight;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;

@property(nonatomic,strong)MyCallBackModel *model;

@property(nonatomic,strong)void(^callBack)();

@end

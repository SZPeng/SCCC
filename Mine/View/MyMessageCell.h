//
//  MyMessageCell.h
//  SCCBBS
//
//  Created by co188 on 16/11/11.
//  Copyright © 2016年 co188. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMessageModel.h"
@interface MyMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;

@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property(nonatomic,strong)MyMessageModel *model;
@end

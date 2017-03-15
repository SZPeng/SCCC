//
//  SecTableViewCell.h
//  SCCQuShan
//
//  Created by HitoiMac001 on 16/7/12.
//  Copyright © 2016年 HitoiMac001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "leftModel.h"
@interface SecTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *SecLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,strong) leftModel *model;
@end

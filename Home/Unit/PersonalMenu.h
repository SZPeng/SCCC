//
//  PersonalMenu.h
//  YBZF
//
//  Created by chunchendeMac on 15/12/5.
//  Copyright © 2015年 ChunChen.App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

@interface PersonalMenu : UIView

+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;

@end

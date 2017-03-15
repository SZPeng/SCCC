//
//  TextView.h
//  带有PlaceHolder的TextView
//
//  Created by huangdl on 15/9/9.
//  Copyright (c) 2015年 黄驿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextView : UITextView

@property(nonatomic) UITextBorderStyle borderStyle;

@property (nonatomic,copy) NSString *placeHolder;

@end

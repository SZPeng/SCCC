//
//  SCCPageController.m
//  SCCBBS
//
//  Created by co188 on 16/11/4.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "SCCPageController.h"
#import <Foundation/Foundation.h>

@interface SCCPageController ()
{
    
    UIImage* activeImage;
    
    UIImage* inactiveImage;
    
}
@end
@implementation SCCPageController

//-(id) initWithFrame:(CGRect)frame
//
//{
//    
//    self = [super initWithFrame:frame];
//    
//    
//    activeImage = [UIImage imageNamed:@"dot-select"];
//    
//    inactiveImage = [UIImage imageNamed:@"dot-unselect"];
//    
//    
//    return self;
//    
//}
//
//
//-(void) updateDots
//
//{
//    NSLog(@"%ld",[self.subviews count]);
//    for (int i=0; i<[self.subviews count]; i++) {
//        
//        UIImageView* dot = [self.subviews objectAtIndex:i];
//        
//        CGSize size;
//        
//        size.height = 7;     //自定义圆点的大小
//        
//        size.width = 7;      //自定义圆点的大小
//        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.width)];
//        if (i==self.currentPage){
//            dot.image = [UIImage imageNamed:@"dot-select"];
//
//        }else{
//           dot.image = [UIImage imageNamed:@"dot-unselect"];
//        }
//        
//    }
//    
//}

-(void) setCurrentPage:(NSInteger)page

{
    
    [super setCurrentPage:page];
    
//    [self updateDots];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 6;
        size.width = 6;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];

    }
    
}


@end

//
//  PersonalMenu.m
//  YBZF
//
//  Created by chunchendeMac on 15/12/5.
//  Copyright © 2015年 ChunChen.App. All rights reserved.
//

#import "PersonalMenu.h"
#import "SCCHeader.h"

@interface PersonalMenu ()

@property (nonatomic, weak) UIView *containerView;

@end

@implementation PersonalMenu
{
    UIView *view;
}
- (UIView *)containerView
{
    if (!_containerView) {
        // 添加一个灰色图片控件
        UIImageView *containerView = [[UIImageView alloc] init];
        containerView.image = [UIImage imageNamed:@"kuang"];
        containerView.userInteractionEnabled = YES; // 开启交互
        [self addSubview:containerView];
        self.containerView = containerView;
    }
    return _containerView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除颜色
        self.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesBegan:withEvent:) name:@"remove" object:nil];

    }
    return self;
}


+ (instancetype)menu
{
    return [[self alloc] init];
}

- (void)setContent:(UIView *)content
{
    _content = content;
    
    // 调整内容的位置
    content.x = 10;
    content.y = 10;
    
    // 调整内容的宽度
    //    content.width = self.containerView.width - 2 * content.x;
    
    // 设置灰色的高度
    self.containerView.height = CGRectGetMaxY(content.frame);
    // 设置灰色的宽度
    self.containerView.width = CGRectGetMaxX(content.frame);
    
    // 添加内容到灰色图片中
    [self.containerView addSubview:content];
}

- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    
    self.content = contentController.view;
}

/**
 *  显示
 */
- (void)showFrom:(UIView *)from
{
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    self.frame = window.bounds;
    view = [[UIView alloc]initWithFrame:window.bounds];
    view.backgroundColor = FF2;
    view.alpha = 0.15;
    [window addSubview:view];
    
    // 2.添加自己到窗口上
    [UIView animateWithDuration:2.0 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [window addSubview:self];
    }];
    // 3.设置尺寸
    
    // 4.调整图片的位置
    // 默认情况下，frame是以父控件左上角为坐标原点
    // 转换坐标系
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    self.containerView.centerX = CGRectGetMidX(newFrame) - 70;
    self.containerView.y = CGRectGetMaxY(newFrame) + 7;
}

/**
 *  销毁
 */
- (void)dismiss
{
    [self removeFromSuperview];
    [UIView animateWithDuration:2.0 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:-20 options:UIViewAnimationOptionCurveLinear animations:^{
        [self dismiss];
    } completion:nil];
}




@end

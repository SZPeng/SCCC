//
//  MyFavouriteCell.m
//  SCCBBS
//
//  Created by co188 on 16/11/16.
//  Copyright © 2016年 co188. All rights reserved.
//

#import "MyFavouriteCell.h"
#import "SCCHeader.h"
#import "SCCAFnetTool.h"
#import "MessageTool.h"
#import "tools.h"
@implementation MyFavouriteCell

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    NSLog(@"%@",text);
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

-(void)setModel:(MyCallBackModel *)model
{
    _model = model;
    
    CGSize common = [self sizeWithText:@"www" font:[UIFont systemFontOfSize:18] maxW:1000];
    _model = model;
    NSLog(@"%@",model.subject);
    _titleLab.text = model.subject;
    CGSize titleSize = [self sizeWithText:model.subject font:[UIFont systemFontOfSize:18] maxW:WIN_WIDTH - 24];
    if(titleSize.height / common.height > 2){
        _titleLabHeight.constant = common.height*2 + 3;
    }else{
        _titleLabHeight.constant = titleSize.height + 3;
    }
    
    _titleLab.font = [UIFont systemFontOfSize:18];
    _titleLab.textColor = A333;
    _titleLab.numberOfLines = 2;
    _nameLab.text = [NSString stringWithFormat:@"最新回复: %@",model.lastposter];
    _nameLab.textColor = A999;
    _nameLab.font = [UIFont systemFontOfSize:15];
    
    //8小时误差
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    //    NSString *string = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeIntervalSince1970:model.lastpost.doubleValue]];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.lastpost.doubleValue]];
    _timeLab.text = time;
    _timeLab.textColor = A999;
    _timeLab.font = [UIFont systemFontOfSize:15];
    
    _lineLab.backgroundColor = Ae1e2e6;

}

- (IBAction)delegateAction:(id)sender {
    NSString *urlString = DELETEFAV;
    NSLog(@"%@",urlString);
    SCCAFnetTool *afTool = [[SCCAFnetTool alloc]init];
    //    NSDictionary *dic = @{@"charset":@"utf-8",@"version":VERSION};
    NSMutableDictionary *messageDic = [MessageTool getMessage];
    [messageDic setObject:_model.tid forKey:@"tid"];
    NSLog(@"%@",messageDic);
    [afTool getMessage:urlString useDictonary:messageDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
        if([code isEqualToString:@"0"]){
            _callBack();
        }else if([code isEqualToString:@"500"]){
            [tools alert:responseObject[@"msg"]];
        }else if([code isEqualToString:@"401"]){
            [tools alert:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

    
}
@end

//
//  NSFileManager+FileSize.h
//  Fenxiao
//
//  Created by sny on 15/5/7.
//  Copyright (c) 2015年 sny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (FileSize)
/**
 根据路径计算文件或文件夹的大小 返回单位M
 */
+(float)getFileSizeForDir:(NSString*)filePath;
@end

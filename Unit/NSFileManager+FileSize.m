//
//  NSFileManager+FileSize.m
//  Fenxiao
//
//  Created by sny on 15/5/7.
//  Copyright (c) 2015年 sny. All rights reserved.
//

#import "NSFileManager+FileSize.h"

@implementation NSFileManager (FileSize)
+(float)getFileSizeForDir:(NSString*)filePath
{
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float size =0;
    NSArray* array = [fileManager contentsOfDirectoryAtPath:filePath error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [filePath stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size+= fileAttributeDic.fileSize/ 1024.0/1024.0;
        }
        else
        {
            size+=[self getFileSizeForDir:fullPath];
        }
    }
    return size;

}
@end

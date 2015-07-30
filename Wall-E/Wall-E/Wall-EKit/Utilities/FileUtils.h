//
//  FileUtils.h
//  YLY11_10
//
//  Created by 严林燕 on 14/11/10.
//  Copyright (c) 2014年 严林燕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 
 * 数据库和账户信息，放在Documents目录
 * 程序长期使用的缓存，放在Library/Caches目录
 * 只在当次程序打开使用的，放在tmp目录
 
 **/


@interface FileUtils : NSObject

+ (NSString *)documentsDirectory;
+ (NSString *)tmpDirectory;
+ (NSString *)cacheDirectory;
+ (NSString *)subDocumentsPath:(NSString *)subFilepath;
+ (NSString *)ensureDirectory:(NSString *)filepath;
+ (NSString *)ensureParentDirectory:(NSString *)filepath;  //如果父级目录不存在就创建

+ (void)saveImage:(UIImage *)image toFile:(NSString *)filePath;
+ (void)saveImage:(UIImage *)image toFile:(NSString *)filePath maxWidth:(CGFloat)maxWidth;
+ (NSString *)saveImageWithTimestampName:(UIImage *)image;

+ (NSString *)convertString:(NSString *)string fromFormat:(NSString *)oldFormat toFormat:(NSString *)newFormat;


@end

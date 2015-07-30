//
//  LogManager.m
//  YLY11_10
//
//  Created by 严林燕 on 14/11/10.
//  Copyright (c) 2014年 严林燕. All rights reserved.
//

#import "LogManager.h"
#import "StorageManager.h"
#import "NSDate+TimeUtils.h"

@implementation LogManager


+ (void)saveLog:(NSString *)logString {
    NSString *logDirectory = [[StorageManager sharedInstance] documentsDirectoryLogPath];
    NSString *fileName = [NSDate fullTimeStringNowWithFormater:@"yyyy-MM-dd"];
    NSString *logFilePath = [logDirectory stringByAppendingPathComponent:fileName];
    NSString *logStringWithTime = [NSString stringWithFormat:@"%@ -> %@\r\n", [NSDate fullTimeStringNowWithFormater:@"HH:mm:ss SSS"], logString];
    NSLog(@"logFilePath = %@", logFilePath);
    NSLog(@"logStringWithTime = %@", logStringWithTime);
    
    NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
    if ( ! fh ) {
        [[NSFileManager defaultManager] createFileAtPath:logFilePath contents:nil attributes:nil];
        fh = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
    }
    
    @try {
        [fh seekToEndOfFile];
        [fh writeData:[logStringWithTime dataUsingEncoding:NSUTF8StringEncoding]];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    [fh closeFile];
}
@end

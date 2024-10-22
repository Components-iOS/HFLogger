//
//  HFLogger.m
//  HFLogger
//
//  Created by liuhongfei on 2024/10/6.
//

#import "HFLogger.h"
#import <HFLogger/HFLogger-Swift.h>

static HFLogger *_BVLogger;

@implementation HFLogger

#pragma mark - 单例的初始化
+ (HFLogger *)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _BVLogger = [[HFLogger alloc] init];
    });
    return _BVLogger;
}

/// 初始化日志
- (void)initLogger {
    HFLogBeaver *logger = [HFLogBeaver shared];
    [logger setupLogger];
}

/// 日志信息
- (void)logInfo:(id)message
           file:(const char *)file
       function:(const char *)function
           line:(int)line {
    NSString *fileName = [NSString stringWithUTF8String:file];
    NSString *functionName = [NSString stringWithUTF8String:function];
    [[HFLogBeaver shared] logInfo:message file:fileName function:functionName line:line];
}

/// 警告日志
- (void)logWarning:(id)message
              file:(const char *)file
          function:(const char *)function
              line:(int)line {
    NSString *fileName = [NSString stringWithUTF8String:file];
    NSString *functionName = [NSString stringWithUTF8String:function];
    [[HFLogBeaver shared] logWarning:message file:fileName function:functionName line:line];
}

/// 错误日志
- (void)logError:(id)message
            file:(const char *)file
        function:(const char *)function
            line:(int)line {
    NSString *fileName = [NSString stringWithUTF8String:file];
    NSString *functionName = [NSString stringWithUTF8String:function];
    [[HFLogBeaver shared] logError:message file:fileName function:functionName line:line];
}

/// 获取日志文件列表
- (NSArray *)getLoggerDisplayFilesArr {
    NSString *logsDirectory = [[HFLogBeaver shared] getLogDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 获取目录的内容
    NSError *error = nil;
    NSArray *fileURLs = [fileManager contentsOfDirectoryAtPath:logsDirectory error:&error];
    
    if (error) {
        HFLogError(@"Error while enumerating files %@: %@", logsDirectory, error.localizedDescription);
        return @[];
    }
    
    NSMutableArray *dateMArr = @[].mutableCopy;
    for (NSString *pathStr in [fileURLs valueForKey:@"lastPathComponent"]) {
        NSString *YMDStr = [pathStr componentsSeparatedByString:@"_"].firstObject;
        NSString *displayStr = [YMDStr stringByReplacingOccurrencesOfString:@"app-" withString:@""];
        [dateMArr insertObject:displayStr atIndex:0];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSArray *sortedDateArr = [dateMArr sortedArrayUsingComparator:^NSComparisonResult(NSString *dateStr1, NSString *dateStr2) {
        NSDate *date1 = [dateFormatter dateFromString:dateStr1];
        NSDate *date2 = [dateFormatter dateFromString:dateStr2];
        return [date2 compare:date1];
    }];
    
    return sortedDateArr;
}

/// 获取日志文件路径
- (NSString *)getFilePath:(NSString *)displayFileName {
    NSString *logsDirectory = [[HFLogBeaver shared] getLogDirectory];
    NSString *pathStr = [NSString stringWithFormat:@"app-%@_00-00-00.log", displayFileName];
    NSString *logFilePath = [NSString stringWithFormat:@"%@/%@", logsDirectory, pathStr];
    return logFilePath;
}

/// 打印日志文件内容
- (void)loggerFileContent:(NSString *)displayFileName {
    NSString *logFilePath = [self getFilePath:displayFileName];
    NSString *logContent = [NSString stringWithContentsOfFile:logFilePath encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"=== Log content start ===");
    NSLog(@"Log content: %@", logContent);
    NSLog(@"=== Log content end ===");
}

@end

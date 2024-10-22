//
//  HFLogger.h
//  HFLogger
//
//  Created by liuhongfei on 2024/10/6.
//

#define HFLogInfo(frmt, ...) [[HFLogger defaultManager] logInfo:[NSString stringWithFormat:(frmt), ##__VA_ARGS__] \
    file:__FILE__ function:__FUNCTION__ line:__LINE__]
#define HFLogWarning(frmt, ...) [[HFLogger defaultManager] logWarning:[NSString stringWithFormat:(frmt), ##__VA_ARGS__] \
    file:__FILE__ function:__FUNCTION__ line:__LINE__]
#define HFLogError(frmt, ...) [[HFLogger defaultManager] logError:[NSString stringWithFormat:(frmt), ##__VA_ARGS__] \
    file:__FILE__ function:__FUNCTION__ line:__LINE__]

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFLogger : NSObject

/// 初始化日志
- (void)initLogger;

/// 日志信息
- (void)logInfo:(id)message
           file:(const char *)file
       function:(const char *)function
           line:(int)line;

/// 警告日志
- (void)logWarning:(id)message
              file:(const char *)file
          function:(const char *)function
              line:(int)line;

/// 错误日志
- (void)logError:(id)message
            file:(const char *)file
        function:(const char *)function
            line:(int)line;

/// 获取日志文件列表
- (NSArray *)getLoggerDisplayFilesArr;

/// 获取日志文件路径
/// - Parameter fileName: 文件名称
- (NSString *)getFilePath:(NSString *)displayFileName;

/// 打印日志文件内容
/// - Parameter fileName: 文件名称
- (void)loggerFileContent:(NSString *)displayFileName;

/// 模式管理单例
+ (HFLogger *)defaultManager;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

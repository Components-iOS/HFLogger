//
//  HFLogger.swift
//  HFLogger
//
//  Created by liuhongfei on 2024/10/12.
//

import Foundation
import SwiftyBeaver

@objc public class HFLogBeaver: NSObject {
    @objc public static let shared = HFLogBeaver()
    @objc public var logDirectory: String?
    private let log: SwiftyBeaver.Type = SwiftyBeaver.self
    private let maxLogFiles = 8
    private var fileDestination: FileDestination?
    
    private override init() {
        super.init()
    }
    
    @objc public func setupLogger() {
        let console = ConsoleDestination()
        console.minLevel = .debug 
        log.addDestination(console)
        
        // 默认日志目录
        self.logDirectory = logDirectory ?? "\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)/Logs"
        createLogDirectory()
        
        // 创建文件目标，只在这里添加一次
        self.fileDestination = FileDestination()
        if let fileDestination = self.fileDestination {
            fileDestination.logFileURL = logFilePath()
            log.addDestination(fileDestination)
        }
        
        // 定时旋转日志
        rotateLogs()
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(rotateLogs), userInfo: nil, repeats: true)
    }
    
    private func createLogDirectory() {
        let url = URL(fileURLWithPath: logDirectory!)
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                log.error("创建日志目录时出错: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func rotateLogs() {
        do {
            guard let logDirectoryURL = URL(string: logDirectory!) else { return }
            
            let keys: [URLResourceKey] = [.nameKey, .creationDateKey]
            let fileURLs = try FileManager.default.contentsOfDirectory(at: logDirectoryURL, includingPropertiesForKeys: keys)
            
            let logFiles = fileURLs.filter { $0.lastPathComponent.hasPrefix("app-") && $0.lastPathComponent.hasSuffix(".log") }
            
            // 检查当天的日志文件路径并更新文件目标
            let currentLogFileURL = logFilePath()
            if fileDestination?.logFileURL != currentLogFileURL {
                fileDestination?.logFileURL = currentLogFileURL
            }

            // 管理日志文件数量，确保不超过最大数量
            if logFiles.count >= maxLogFiles {
                let sortedLogFiles = logFiles.sorted { $0.lastPathComponent < $1.lastPathComponent }
                for fileURL in sortedLogFiles.prefix(sortedLogFiles.count - maxLogFiles + 1) {
                    try FileManager.default.removeItem(at: fileURL)
                }
            }
        } catch {
            log.error("旋转日志时出错: \(error.localizedDescription)")
        }
    }
    
    private func logFilePath() -> URL {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let dateString = dateFormatter.string(from: startOfDay)
        let logFileName = "app-\(dateString).log"
        return URL(fileURLWithPath: logDirectory!).appendingPathComponent(logFileName)
    }
    
    @objc public func getLogDirectory() -> String {
        return logDirectory!
    }
    
    @objc public func logInfo(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        let formattedMessage: String
        
        if let convertibleMessage = message as? CustomStringConvertible {
            formattedMessage = convertibleMessage.description
        } else {
            formattedMessage = "\(message)"
        }
        
        log.info(formattedMessage)
    }
    
    @objc public func logWarning(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let formattedMessage: String
        
        if let convertibleMessage = message as? CustomStringConvertible {
            formattedMessage = convertibleMessage.description
        } else {
            formattedMessage = "\(message)"
        }
        
        log.custom(level: .warning, message: formattedMessage, file: fileName, function: function, line: line, context: nil)
    }
    
    @objc public func logError(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let formattedMessage: String
        
        if let convertibleMessage = message as? CustomStringConvertible {
            formattedMessage = convertibleMessage.description
        } else {
            formattedMessage = "\(message)"
        }
        
        log.custom(level: .error, message: formattedMessage, file: fileName, function: function, line: line, context: nil)
    }
}

//
//  ZHCCache.swift
//  ZHCCache
//
//  Created by 张行 on 2018/11/24.
//  Copyright © 2018 张行. All rights reserved.
//

import Foundation

class ZHCCache {
    
    func fix() {
        guard let CONFIGURATION = filterValue(key: "CONFIGURATION") else {
            printLog(string:"参数错误 参数缺少 CONFIGURATION 参数")
            return
        }
        printLog(string:"CONFIGURATION=\(CONFIGURATION)")
        if CONFIGURATION == "Debug" {
            printLog(string: "Debug 模式退出!")
            return
        }
        guard let PWD = filterValue(key: "PWD")  else {
            printLog(string:"参数错误 参数缺少 PWD 参数")
            return
        }
        printLog(string:"PWD=\(PWD)")
        guard let OTHER_CFLAGS = filterValue(key: "OTHER_CFLAGS") else {
            printLog(string:"参数错误 参数缺少 OTHER_CFLAGS 参数")
            return
        }
        printLog(string:"OTHER_CFLAGS=\(OTHER_CFLAGS)")
        guard let PODS_CONFIGURATION_BUILD_DIR = filterPodConfigurationBuildDir(otherCFlage: OTHER_CFLAGS) else {
            printLog(string:"无法解析 PODS_CONFIGURATION_BUILD_DIR 路径")
            return
        }
        printLog(string:"PODS_CONFIGURATION_BUILD_DIR=\(PODS_CONFIGURATION_BUILD_DIR)")
//        let PODS_CONFIGURATION_BUILD_DIR = "/Users/zhangxing/Library/Developer/Xcode/DerivedData/GearBest-civigpnhcossbibqlyzbsbtghkco/Build/Intermediates.noindex/ArchiveIntermediates/GearBest/BuildProductsPath/AdHoc-iphoneos"
        
        guard let FIX_PATH = filterValue(key: "FIX_PATH") else {
            printLog(string:"参数错误 参数缺少 FIX_PATH 参数")
            return
        }
        printLog(string:"FIX_PATH=\(FIX_PATH)")
        
        guard let  contents = try? FileManager.default.contentsOfDirectory(atPath: FIX_PATH) else {
            printLog(string:"FIX_PATH路径错误!")
            return
        }
        printLog(string:"配置数组->\(contents)")
        contents.forEach { (file) in
            if file.range(of: ".DS_Store") != nil {
                return
            }
            let filePath = "\(FIX_PATH)/\(file)"
            printLog(string:"配置文件\(filePath)")
            if let data = FileManager.default.contents(atPath: filePath), let text = String(data: data, encoding: String.Encoding.utf8) {
                let filterList = text.components(separatedBy: ">>>\n")
                var path = filterList[0]
                let old = filterList[1]
                let new = filterList[2]
                if path.range(of: "$PWD") != nil {
                    path = path.replacingOccurrences(of: "$PWD", with: "")
                    path = "\(PWD)\(path)"
                } else if path.range(of: "$PODS_CONFIGURATION_BUILD_DIR") != nil {
                    if PODS_CONFIGURATION_BUILD_DIR.range(of: "Intermediates.noindex/ArchiveIntermediates") != nil {
                        var list = PODS_CONFIGURATION_BUILD_DIR.components(separatedBy: "/")
                        list.removeLast()
                        list.removeLast()
                        let PODS_CONFIGURATION_BUILD_DIR_TEMP = "\(list.joined(separator: "/"))/IntermediateBuildFilesPath/UninstalledProducts/iphoneos"
                        var pathList = path.components(separatedBy: "/")
                        pathList.removeFirst()
                        pathList.removeFirst()
                        let pathTemp = "\(pathList.joined(separator: "/"))"
                        printLog(string:"->>>\(PODS_CONFIGURATION_BUILD_DIR_TEMP)")
                        path = "\(PODS_CONFIGURATION_BUILD_DIR_TEMP)/\(pathTemp)"
                    } else {
                        path = path.replacingOccurrences(of: "$PODS_CONFIGURATION_BUILD_DIR", with: "")
                        printLog(string:"->>>\(PODS_CONFIGURATION_BUILD_DIR)")
                        path = "\(PODS_CONFIGURATION_BUILD_DIR)\(path)"
                    }
                }
                path = path.replacingOccurrences(of: "\n", with: "")
                printLog(string:"需要修改的文件路径为:👉🏻\(path)👉🏻")
                if let data1 = FileManager.default.contents(atPath: path) {
                    if var fileContent = String(data: data1, encoding: String.Encoding.utf8) {
                        if fileContent.range(of: old) == nil {
                            printLog(string: "文件不需要改动已经支持!")
                            return
                        }
                        fileContent = fileContent.replacingOccurrences(of: old, with: new)
                        do {
                            try fileContent.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
                        } catch {
                            printLog(string:"\(path)文件写入失败")
                        }
                    } else {
                        printLog(string:"读取文件String内容报错:\(path)")
                    }
                } else {
                    printLog(string:"读取文件Data内容报错:\(path)")
                }
                
            } else {
                printLog(string:"读取文件内容报错:\(filePath)")
            }
        }
        
    }
    func filterValue(key:String) -> String? {
        var value:String?
        CommandLine.arguments.forEach { (argument) in
            if argument.range(of: "\(key)=") != nil {
                let splitList = argument.components(separatedBy: "=")
                if splitList.count == 2 {
                    value = splitList.last
                }
            }
        }
        return value
    }
    
    func filterPodConfigurationBuildDir(otherCFlage:String) -> String? {
        var value:String?
        let spliteList = otherCFlage.components(separatedBy: " -iquote ")
        spliteList.forEach { (item) in
            if value != nil {
                return
            }
            if item.range(of: ".framework") != nil {
                var spliteList1 = item.components(separatedBy: "/")
                printLog(string:"\(spliteList1)")
                spliteList1.removeLast()
                spliteList1.removeLast()
                spliteList1.removeLast()
                value = spliteList1.joined(separator: "/")
            }
        }
        return value?.replacingOccurrences(of: "\"", with: "")
    }
    
    func printLog(string:String) {
        print("👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻👉🏻\n\(string)\n")
    }
}

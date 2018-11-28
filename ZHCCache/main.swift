//
//  main.swift
//  ZHCCache
//
//  Created by 张行 on 2018/11/24.
//  Copyright © 2018 张行. All rights reserved.
//

import Foundation

CommandLine.arguments.forEach { (argument) in
    print("CommandLine参数:\(argument)");
}

let ccache = ZHCCache()
ccache.fix()

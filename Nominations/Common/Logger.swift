//
//  Logger.swift
//  Nominations
//
//  Created by cabbage on 2023/10/24.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import Foundation

func CubeLog(_ message: Any, line: Int = #line, function: String = #function, file: String = #file) {
    #if LOGGING
    print("🥬 \(URL(fileURLWithPath: file).lastPathComponent) :: \(function) [\(line)] > \(message)")
    #endif
}

//
//  BaseURL.swift
//  Nominations
//
//  Created by cabbage on 2023/10/24.
//

import Foundation

extension URL {
    enum Host {
        case API
        
        var url: URL {
            switch self {
            case .API: return URL(string: "https://cube-academy-api.cubeapis.com/api/")!
            }
        }
    }
}

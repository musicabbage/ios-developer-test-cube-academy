//
//  Errors.swift
//  Nominations
//
//  Created by cabbage on 2023/10/29.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import Foundation

enum CubeError: Error, LocalizedError {
    case fetchNominationsFail(Error)
    case fetchNomineesFail(Error)
    case submitNominationFail(Error)
    
    var errorDescription: String? {
        switch self {
        case .fetchNominationsFail: "Fetch nominations list failed.😢"
        case .fetchNomineesFail: "Fetch nominees list failed.😢"
        case let .submitNominationFail(error): "Submit nomination failed. Message: \(error.localizedDescription)"
        }
    }
}


//
//  NetworkError.swift
//  Nominations
//
//  Created by cabbage on 2023/10/29.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case cubeResponseError(NetworkErrorModel?)
    case requestError(Error)
}

struct NetworkErrorModel: Decodable {
    /**
     "message": "The reason field is required.",
     "errors": {
        "reason": [
          "The reason field is required."
        ]
     }
     */
    let message: String
    let reasons: [String]
    
    enum CodingKeys: String, CodingKey {
        case message, errors
    }

    enum ErrorCodingKeys: String, CodingKey {
      case reason
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        let errorsContainer = try container.nestedContainer(keyedBy: ErrorCodingKeys.self, forKey: .errors)
        reasons = try errorsContainer.decode([String].self, forKey: .reason)
      }
}

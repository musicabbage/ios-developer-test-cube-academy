//
//  NomineeListModel.swift
//  Nominations
//
//  Created by cabbage on 2023/10/26.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import Foundation

struct NomineeListModel: Decodable {
    struct Item: Decodable {
        let nomineeId: String
        let firstName: String
        let lastName: String
        var id: String { nomineeId }
    }
    
    let data: [Item]
}

extension NomineeListModel {
    static var mock: NomineeListModel {
        let mockJson = """
        {"data":
        [
          {
            "nominee_id": "9a4bd093-e74c-4918-87cc-0c689cca78bf",
            "first_name": "Alex",
            "last_name": "Errington"
          },
          {
            "nominee_id": "9a4bd093-e9d9-44a2-836b-f4fd8f5579ba",
            "first_name": "Alex",
            "last_name": "McDonough"
          }
        ]}
        """
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try! decoder.decode(NomineeListModel.self, from: mockJson.data(using: .utf8)!)
    }
}

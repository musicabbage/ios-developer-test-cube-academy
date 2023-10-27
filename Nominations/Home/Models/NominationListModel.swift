//
//  NominationListModel.swift
//  Nominations
//
//  Created by cabbage on 2023/10/25.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import Foundation

struct NominationListModel: Decodable {
    struct Item: Decodable, Identifiable {
        var id: String { nominationId }
        
        /**
         "nomination_id": "string",
         "nominee_id": "string",
         "reason": "string",
         "process": "string",
         "date_submitted": "string",
         "closing_date": "string"
         */
        let nominationId: String
        let nomineeId: String
        let reason: String
        let process: String
        let dateSubmitted: String
        let closingDate: String
    }
    
    let data: [Item]
}

struct NominationDisplayModel: Identifiable {
    var id: String { nominationId }
    
    let nominationId: String
    let reason: String
    let name: String
}

extension NominationDisplayModel {
    static let mock: NominationDisplayModel = .init(nominationId: "yyy",
                                                    reason: "Always goes above and...",
                                                    name: "Cube")
}

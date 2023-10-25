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

extension NominationListModel.Item {
    static let mock: NominationListModel.Item = .init(nominationId: "xxx",
                                                      nomineeId: "yyy",
                                                      reason: "Always goes above and...",
                                                      process: "very_fair",
                                                      dateSubmitted: "2023-10-24",
                                                      closingDate: "2023-10-25")
}

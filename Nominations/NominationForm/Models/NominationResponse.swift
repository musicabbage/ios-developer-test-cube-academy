//
//  NominationResponse.swift
//  Nominations
//
//  Created by cabbage on 2023/10/27.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import Foundation

struct NominationResponse: Decodable {
    struct Data: Decodable {
        /**
         "nomination_id": "9a747232-84ef-4e6c-abff-6e04aba4d5a1",
         "nominee_id": "9a4bd093-eb49-479d-aad4-d9f793c6d2bd",
         "reason": "Ali Ali",
         "process": "not_sure",
         "date_submitted": "2023-10-25 15:53:47",
         "closing_date": "2023-10-25 15:53:47"
         */
        let nominationId: String
        let nomineeId: String
        let reason: String
        let process: String
        let dateSubmitted: String
        let closingDate: String
    }
    
    let data: Data
}

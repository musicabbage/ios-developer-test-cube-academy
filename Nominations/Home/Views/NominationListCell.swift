//
//  NominationListCell.swift
//  Nominations
//
//  Created by cabbage on 2023/10/25.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

struct NominationListCell: View {
    let item: NominationListModel.Item
    
    var body: some View {
        VStack(alignment: .leading, content: {
            Text(item.nomineeId)
                .foregroundStyle(Color.black)
                .style(.bodyBold)
            Text(item.reason)
                .foregroundStyle(Color.cubeDarkGrey)
                .style(.body)
        })
        .padding(.horizontal, 16.5)
        .padding(.vertical, 24)
        .frame(maxHeight: 87)
    }
}

#Preview {
    NominationListCell(item: .mock)
}

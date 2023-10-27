//
//  FormTitleView.swift
//  Nominations
//
//  Created by cabbage on 2023/10/26.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

struct FormTitleView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Text(title)
                .textCase(.uppercase)
                .style(.boldHeadlineSmall)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(description)
                .style(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        })
    }
}

#Preview {
    FormTitleView(title: "I’d like to nominate... ", description: "Please select a cube who you feel has done something honourable this month or just all round has a great work ethic.")
}

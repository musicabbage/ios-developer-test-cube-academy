//
//  FormTitleView.swift
//  Nominations
//
//  Created by cabbage on 2023/10/26.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

struct FormTitleView: View {
    enum TitleString {
        case string(String)
        case attributedString(AttributedString)
    }
    
    let title: TitleString
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            switch title {
            case let .string(string):
                Text(string)
                    .textCase(.uppercase)
                    .style(.boldHeadlineSmall)
            case let .attributedString(attributedString):
                Text(attributedString)
                    .textCase(.uppercase)
                    .style(.boldHeadlineSmall)
            }
            Text(description)
                .style(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        })
    }
}

#Preview {
    FormTitleView(title: .string("I’d like to nominate... "),
                  description: "Please select a cube who you feel has done something honourable this month or just all round has a great work ethic.")
}

//
//  FormFieldView.swift
//  Nominations
//
//  Created by cabbage on 2023/10/25.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

struct FormFieldView<Content: View>: View {
    private let title: String
    private let content: () -> Content
    private let isRequired: Bool

    init(title: String, isRequired: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
        self.isRequired = isRequired
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 8, content: {
                if isRequired {
                    Text("*")
                        .style(.boldHeadlineSmallest)
                        .foregroundColor(.cubePink)
                }
                Text(title)
                    .style(.boldHeadlineSmallest)
            })
            content()
        }
    }
}

#Preview {
    FormFieldView(title: "123", isRequired: true) {
        Text("456")
    }
}

//
//  ButtonBoxView.swift
//  Nominations
//
//  Created by cabbage on 2023/10/25.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

struct ButtonBoxView: View {
    let type: ButtonType
    let title: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            CubeButton(state: .constant(.active), type: type, title: title, action: action)
                .padding(24)
                .frame(maxWidth: .infinity)
        }
        .background(Color.white)
        .buttonBoxShadow()
    }
}

#Preview {
    ButtonBoxView(type: .primary, title: "cabbage", action: {})
}

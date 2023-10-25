//
//  HomeEmptyStateView.swift
//  Nominations
//
//  Created by cabbage on 2023/10/24.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI
import CubeFoundationSwiftUI

struct HomeEmptyStateView: View {
    var body: some View {
        VStack {
            Image(.inbox)
            Text("once you submit a nomination, you will be able to SEE it here.")
                .style(.boldHeadlineMedium)
                .textCase(.uppercase)
                .multilineTextAlignment(.center)
                .foregroundStyle(.cubeDarkGrey)
                .frame(width: 317, height: 162, alignment: .center)
        }
    }
}

#Preview {
    HomeEmptyStateView()
}

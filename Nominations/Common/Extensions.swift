//
//  Extensions.swift
//  Nominations
//
//  Created by cabbage on 2023/10/28.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

extension View {
    func buttonBoxShadow() -> some View {
        self.background(
            Rectangle()
                .fill(Color.white)
                .ignoresSafeArea()
                .shadow(.strong)
        )
    }
}

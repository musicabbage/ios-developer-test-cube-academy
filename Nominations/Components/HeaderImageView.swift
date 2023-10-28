//
//  HeaderImageView.swift
//  Nominations
//
//  Created by cabbage on 2023/10/28.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

struct HeaderImageView: View {
    let imageResource: ImageResource
    
    init(_ imageResource: ImageResource) {
        self.imageResource = imageResource
    }
    
    var body: some View {
        Image(.formHeader)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

#Preview {
    HeaderImageView(.formHeader)
}

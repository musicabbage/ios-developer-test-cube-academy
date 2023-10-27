//
//  ToastView.swift
//  Nominations
//
//  Created by cabbage on 2023/10/27.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

struct ToastModel: Equatable {
    var message: String
    var duration: Double = 3
}

struct ToastView: View {
    var message: String
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text(message)
                                .foregroundColor(Color.black.opacity(0.6))
                                .font(.system(size: 14, weight: .semibold))
                        }
                        
                        Spacer(minLength: 10)
                        
                        Button {
                            onCancelTapped()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(Color.black)
                        }
                    }
                    .padding()
                }
                .background(Color.gray)
                .frame(minWidth: 0, maxWidth: .infinity)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
                .padding(.horizontal, 16)
    }
}

#Preview {
    ToastView(message: "message", onCancelTapped: {})
}

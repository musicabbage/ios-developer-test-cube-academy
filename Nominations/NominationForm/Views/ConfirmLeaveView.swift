//
//  ConfirmLeaveView.swift
//  Nominations
//
//  Created by cabbage on 2023/10/27.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

struct ConfirmLeaveView: View {
    enum Action {
        case leave, cancel
    }
    
    private var actionClosure: (_ action: Action) -> Void = { _ in }
    
    var body: some View {
        VStack(spacing: 0, content: {
            Spacer()
            VStack(alignment: .leading, spacing: 18, content: {
                Text("Are you sure?")
                    .textCase(.uppercase)
                    .style(.boldHeadlineSmall)
                    .padding(.horizontal, 18)
                    .padding(.top, 24)
                Text("If you leave this page, you will loose any progress made.")
                    .style(.body)
                    .padding(.horizontal, 18)
                    .padding(.bottom, 51)
                VStack {
                    CubeButton(state: .constant(.active), 
                               type: .secondary,
                               title: "Yes, leave page",
                               action: { actionClosure(.leave) })
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                    CubeButton(state: .constant(.active),
                               type: .secondary,
                               title: "Cancel", action: { actionClosure(.cancel) })
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24.69)
                }
                .buttonBoxShadow()
            })
            .background(Color.white)
        })
        .ignoresSafeArea()
        .background(
            Rectangle()
                .fill(Color.black)
                .opacity(0.6)
        )
    }
}

extension ConfirmLeaveView {
    func onTapButton(perform action: @escaping(Action) -> Void) -> Self {
        var copy = self
        copy.actionClosure = action
        return copy
    }
}

#Preview {
    ConfirmLeaveView()
}

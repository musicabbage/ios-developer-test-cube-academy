//
//  CubeButton.swift
//  Nominations
//
//  Created by cabbage on 2023/10/25.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

enum ButtonType {
    case primary, secondary
}

enum ButtonState {
    case active, inactive, loading
}

struct CubeButton: View {
    
    @Binding private var state: ButtonState
    
    let type: ButtonType
    let title: String
    let action: () -> Void
    
    init(state: Binding<ButtonState>, type: ButtonType, title: String, action: @escaping () -> Void) {
        self._state = state
        self.type = type
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: {
            switch state {
            case .loading:
                ProgressView()
                    .tint(type == .primary ? .white : .black)
            default:
                Text(title)
            }
        })
        .disabled(state != .active)
        .buttonStyle(CubeButtonStyle(state: state, type: type))
        .frame(maxWidth: .infinity)
    }
}

private struct CubeButtonStyle: ButtonStyle {
    private let state: ButtonState
    private let type: ButtonType
    
    private var isDisabled: Bool { state != .active }
    
    init(state: ButtonState, type: ButtonType) {
        self.state = state
        self.type = type
    }
    
    func makeBody(configuration: Configuration) -> some View {
        switch type {
        case .primary:
            configuration.label
                .style(.button)
                .textCase(.uppercase)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(isDisabled ? Color.cubeMidGrey :  (configuration.isPressed ? Color.cubeDarkGrey : Color.black))
                .border(isDisabled ? Color.cubeMidGrey : Color.black, width: 2)
        case .secondary:
            configuration.label
                .style(.button)
                .textCase(.uppercase)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .foregroundColor(isDisabled ? Color.cubeDarkGrey : Color.black)
                .border(isDisabled ? Color.cubeMidGrey : configuration.isPressed ? Color.accentColor : Color.black, width: 2)
        }
    }
}

#Preview {
    CubeButton(state: .constant(.active), type: .secondary, title: "cabbage", action: {})
}

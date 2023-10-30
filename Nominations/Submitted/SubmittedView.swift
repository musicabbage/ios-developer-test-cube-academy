//
//  SubmittedView.swift
//  Nominations
//
//  Created by cabbage on 2023/10/27.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

struct SubmittedView: View {
    
    @EnvironmentObject private var router: NominationsRouter
    
    var body: some View {
        VStack {
            HeaderImageView(.submittedHeader)
                .frame(maxHeight: 212)
            VStack {
                Text("NOMINATION SUBMITTED")
                    .style(.boldHeadlineLarge)
                    .multilineTextAlignment(.center)
                Text("Thank you for taking the time to fill out this form! Why not nominate another cube?")
                    .style(.body)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding(.horizontal, 12)
            
            VStack {
                CubeButton(state: .constant(.active), type: .primary, title: "CREATE NEW NOMINATION", action: createNewNomination)
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                CubeButton(state: .constant(.active), type: .secondary, title: "BACK TO HOME", action: backToHome)
                .padding(.horizontal, 24)
                .padding(.bottom, 24.69)
            }
            .buttonBoxShadow()
        }
        .navigationStyle(title: "Nomination Submitted")
    }
}

private extension SubmittedView {
    func backToHome() {
        router.navigateToRoot()
    }
    
    func createNewNomination() {
        router.navigate(to: .NominationForm)
    }
}

#Preview {
    SubmittedView()
}

//
//  NominationForm.swift
//  Nominations
//
//  Created by cabbage on 2023/10/25.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

struct NominationForm<ViewModel: NominationViewModelProtocol>: View {
    
    @EnvironmentObject private var router: NominationsRouter
    @ObservedObject private var viewModel: ViewModel
    @State private var saveButtonState: ButtonState = .inactive
    @State private var toast: ToastModel? = nil
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            ZStack {
                ScrollView {
                    Image(.formHeader)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                    VStack(spacing: 34) {
                        FormTitleView(title: "I’d like to nominate... ", description: "Please select a cube who you feel has done something honourable this month or just all round has a great work ethic.")
                        FormFieldView(title: "Cube’s name", isRequired: true) {
                            NomineesPickerView(nominees: $viewModel.nomineesList, selectedNomineeIndex: $viewModel.nomineeIndex)
                        }
                        
                        FormTitleView(title: "I’d like to nominate THIS CUBE BECAUSE...", description: "Please let us know why you think this cube deserves the ‘cube of the month’ title 🏆⭐")
                            .frame(maxWidth: .infinity)
                        FormFieldView(title: "Reasoning", isRequired: true) {
                            TextEditor(text: $viewModel.reason)
                                .style(.body)
                                .border(.cubeDarkGrey, width: 1)
                                .frame(minHeight: 207)
                        }
                        
                        FormTitleView(title: "IS HOW WE CURRENTLY RUN CUBE OF THE MONTH FAIR?", description: "As you know, out the nominees chosen, we spin a wheel to pick the cube of the month. What’s your opinion on this method?")
                        
                        RadioButtonView(items: RadioButtonView.RadioItem.processOptions, selectedId: $viewModel.process)
                    }
                    .padding(.horizontal, 16)
                }
            }
            HStack(spacing: 14) {
                Spacer()
                CubeButton(state: .constant(.active), type: .secondary, title: "Back") {
                    
                }
                CubeButton(state: $saveButtonState, type: .primary, title: "Next", action: sendNomination)
                    .containerRelativeFrame(.horizontal, count: 5, span: 3, spacing: 0)
                Spacer()
            }
            .frame(maxHeight: 91.38)
            .background(
                Rectangle()
                    .fill(Color.white)
                    .shadow(.strong)
            )
        }
        .onChange(of: viewModel.canSave, onCanSendChanged)
        .onChange(of: viewModel.errorMessage, showErrorMessage)
        .toastView($toast)
        .navigationTitle("Create a nomination")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
}

private extension NominationForm {
    func sendNomination() {
        saveButtonState = .loading
        var success = false
        Task {
            success = await viewModel.nominate()
        }
        saveButtonState = success ? .inactive : .active
        router.navigate(to: .NominationSubmitted)
    }
    
    func onCanSendChanged() {
        saveButtonState = viewModel.canSave ? .active : .inactive
    }
    
    func showErrorMessage() {
        guard let errorMessage = viewModel.errorMessage else { return }
        toast = ToastModel(message: errorMessage)
    }
}

#Preview {
    NominationForm(viewModel: NominationViewModel_Preview())
}

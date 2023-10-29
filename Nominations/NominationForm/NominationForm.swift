//
//  NominationForm.swift
//  Nominations
//
//  Created by cabbage on 2023/10/25.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI
import CubeFoundationSwiftUI

struct NominationForm<ViewModel: NominationViewModelProtocol>: View {
    
    @EnvironmentObject private var router: NominationsRouter
    @ObservedObject private var viewModel: ViewModel
    @State private var saveButtonState: ButtonState = .inactive
    @State private var toast: ToastModel? = nil
    @State private var showConfirmView: Bool = false
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    HeaderImageView(.formHeader)
                        .frame(maxWidth: .infinity)
                    VStack(spacing: 34) {
                        ForEach(Field.allCases) { field in
                            titleView(field: field)
                            controlView(field: field)
                            if field.id < Field.allCases.count - 1 {
                                Divider()
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 30, leading: 16, bottom: 70, trailing: 16))
                }
                
                stickyButtonsView
            }
            if showConfirmView {
                ConfirmLeaveView()
                    .onTapButton(perform: onTapConfirmViewAction(_:))
            }
        }
        .onChange(of: viewModel.canSave, onCanSendChanged)
        .onChange(of: viewModel.errorMessage, showErrorMessage)
        .toastView($toast)
        .navigationStyle(title: "Create a nomination")
    }
}

private extension NominationForm {
    var stickyButtonsView: some View {
        HStack(spacing: 14) {
            Spacer()
            CubeButton(state: .constant(.active),
                       type: .secondary,
                       title: "Back",
                       action: { showConfirmView = true })
            CubeButton(state: $saveButtonState,
                       type: .primary,
                       title: "Next",
                       action: sendNomination)
                .containerRelativeFrame(.horizontal, count: 5, span: 3, spacing: 0)
            Spacer()
        }
        .frame(maxHeight: 91.38)
        .buttonBoxShadow()
    }
}

private extension NominationForm {
    
    private enum Field: CaseIterable, Identifiable {
        case nominee, reason, process
        
        typealias ID = Int
        var id: Int {
            switch self {
            case .nominee: 0
            case .reason: 1
            case .process: 2
            }
        }
        
        var title: FormTitleView.TitleString {
            switch self {
            case .nominee:
                return .string("I’d like to nominate... ")
            case .reason:
                return .string("I’d like to nominate THIS CUBE BECAUSE...")
            case .process:
                let textStyle = TextStyle.boldHeadlineSmall
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = textStyle.lineSpacing
                let titleAttributes = AttributeContainer([
                    .font: textStyle.font,
                    .tracking: textStyle.letter,
                    .paragraphStyle: paragraphStyle
                ])
                var title = AttributedString("IS HOW WE CURRENTLY RUN", attributes: titleAttributes)
                title.foregroundColor = .black
                var highlightText = AttributedString(" CUBE OF THE MONTH", attributes: titleAttributes)
                highlightText.foregroundColor = .cubePink
                title.append(highlightText)
                title.append(AttributedString(" FAIR?"))
                return .attributedString(title)
            }
        }
        
        var description: String {
            switch self {
            case .nominee:
                "Please select a cube who you feel has done something honourable this month or just all round has a great work ethic."
            case .reason:
                "Please let us know why you think this cube deserves the ‘cube of the month’ title 🏆⭐"
            case .process:
                "As you know, out the nominees chosen, we spin a wheel to pick the cube of the month. What’s your opinion on this method?"
            }
        }
        
        var controlTitle: String {
            switch self {
            case .nominee: "Cube’s name"
            case .reason: "Reasoning"
            case .process: ""
            }
        }
        
        var required: Bool { true }
    }
    
    private func titleView(field: Field) -> FormTitleView {
        return FormTitleView(title: field.title, description: field.description)
    }
    
    @ViewBuilder 
    private func controlView(field: Field) -> some View {
        switch field {
        case .nominee:
            FormFieldView(title: field.controlTitle, isRequired: field.required) {
                NomineesPickerView(nominees: $viewModel.nomineesList, selectedNomineeIndex: $viewModel.nomineeIndex)
            }
        case .reason:
            FormFieldView(title: field.controlTitle, isRequired: field.required) {
                TextEditor(text: $viewModel.reason)
                    .style(.body)
                    .border(.cubeDarkGrey, width: 1)
                    .frame(minHeight: 207)
            }
        case .process:
            RadioButtonView(items: RadioButtonView.RadioItem.processOptions, 
                            selectedId: $viewModel.process)
        }
    }
    
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
    
    func onTapConfirmViewAction(_ action: ConfirmLeaveView.Action) {
        switch action {
        case .leave:
            router.navigateBack()
        case .cancel:
            showConfirmView = false
        }
    }
    
    func getProcessAttributedTitle() -> AttributedString {
        /**
         "IS HOW WE CURRENTLY RUN CUBE OF THE MONTH FAIR?"
         
         font(style.font.weight(style.weight))
         .tracking(style.letter)
         .underline(style.underline)
         .lineSpacing(style.lineSpacing)
         .padding(.vertical, style.lineSpacing / 2)
         */
        let textStyle = TextStyle.boldHeadlineSmall
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = textStyle.lineSpacing
        let titleAttributes = AttributeContainer([
            .font: textStyle.font,
            .tracking: textStyle.letter,
            .paragraphStyle: paragraphStyle
        ])
        var title = AttributedString("IS HOW WE CURRENTLY RUN", attributes: titleAttributes)
        title.foregroundColor = .black
        var highlightText = AttributedString(" CUBE OF THE MONTH", attributes: titleAttributes)
        highlightText.foregroundColor = .cubePink
        title.append(highlightText)
        title.append(AttributedString(" FAIR?"))
        return title
    }
}

#Preview {
    NominationForm(viewModel: NominationViewModel_Preview())
}

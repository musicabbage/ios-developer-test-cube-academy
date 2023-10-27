//
//  NomineesPickerView.swift
//  Nominations
//
//  Created by cabbage on 2023/10/26.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI



struct NomineesPickerView: View {
    typealias NomineeModel = NomineeListModel.Item
    
    @Binding var nominees: [NomineeModel]
    @Binding private var selectedNomineeIndex: Int
    
    init(nominees: Binding<[NomineeModel]>, selectedNomineeIndex: Binding<Int>) {
        self._nominees = nominees
        self._selectedNomineeIndex = selectedNomineeIndex
    }
    
    var body: some View {
        Menu {
            Picker(selection: $selectedNomineeIndex) {
                ForEach(0..<nominees.count, id: \.self) { index in
                    let nominee = nominees[index]
                    Text("\(nominee.firstName) \(nominee.lastName)").tag(index)
                }
            } label: { 
                Text("Select a nominee")
            }
        } label: {
            Text(selectedNomineeIndex < 0 ? "Select Option" :
                    "\(nominees[selectedNomineeIndex].firstName) \(nominees[selectedNomineeIndex].lastName)")
                .style(.body)
                .frame(height: 55)
                .foregroundColor(.black)
                .padding(.horizontal, 13)
            Spacer()
            Image(.dropdownArrow)
                .padding(.horizontal, 19)
        }
        .border(.cubeMidGrey, width: 1)
    }
}

#Preview {
    NomineesPickerView(nominees: .constant(NomineeListModel.mock.data), selectedNomineeIndex: .constant(1))
}

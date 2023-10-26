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
    
    @State var nominees: [NomineeModel]
    @Binding private var selectedNomineeId: String?
    
    private let nomineesList: [String]
    private let nomineesMap: [String: NomineeModel]
    
    init(nominees: [NomineeModel] = [], selectedNomineeId: Binding<String?>) {
        self.nominees = nominees
        self._selectedNomineeId = selectedNomineeId
        
        var nomineesList = [String]()
        var nomineesMap = [String: NomineeModel]()
        for nominee in nominees {
            nomineesList.append(nominee.id)
            nomineesMap[nominee.id] = nominee
        }
        self.nomineesList = nomineesList
        self.nomineesMap = nomineesMap
    }
    
    var body: some View {
        Menu {
            Picker(selection: $selectedNomineeId) {
                ForEach(0..<nomineesList.count, id: \.self) { index in
                    let nominee = nomineesMap[nomineesList[index]]
                    Text(nominee != nil ? "\(nominee!.firstName) \(nominee!.lastName)" : "?_____?")
                }
            } label: { 
                Text("Select a nominee")
            }
        } label: {
            Text("Select Option")
                .style(.body)
                .foregroundColor(.black)
                .padding(13)
            Spacer()
            Image(.dropdownArrow)
                .padding(.horizontal, 19)
        }
        .border(.cubeMidGrey, width: 1)
    }
}

#Preview {
    NomineesPickerView(nominees: NomineeListModel.mock.data, selectedNomineeId: .constant(nil))
}

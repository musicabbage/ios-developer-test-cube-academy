//
//  RadioButtonView.swift
//  Nominations
//
//  Created by cabbage on 2023/10/26.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

struct RadioButtonView: View {
    struct RadioItem: Identifiable {
        let id: String
        let title: String
        let image: ImageResource
    }
    
    @Binding private var selectedId: String?
    
    private var items: [RadioItem]
    
    init(items: [RadioItem], selectedId: Binding<String?>) {
        self.items = items
        self._selectedId = selectedId
    }
    
    var body: some View {
        VStack(spacing: 12, content: {
            ForEach(items) { item in
                RadioButtonCellView(item: item, isSelected: selectedId == item.id)
                    .onTapGesture {
                        selectedId = item.id
                    }
            }
        })
    }
}

fileprivate struct RadioButtonCellView: View {
    
    private let item: RadioButtonView.RadioItem
    private let isSelected: Bool
    
    init(item: RadioButtonView.RadioItem, isSelected: Bool) {
        self.item = item
        self.isSelected = isSelected
    }
    
    var body: some View {
        HStack {
            Image(item.image)
                .padding(12)
            Text(item.title)
                .style(.boldHeadlineSmallest)
                .padding(.leading, 2)
            Spacer()
            Image(isSelected ? .radioButtonActive : .radioButtonInactive)
                .padding(12)
        }
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
            .fill(Color.white)
            .shadow(isSelected ? .strong : .none)
            .border(isSelected ? .cubeDarkGrey : .cubeMidGrey, width: 1)
        )
    }
}

extension RadioButtonView.RadioItem {
    typealias RadioItem = RadioButtonView.RadioItem
    
    static let processOptions: [RadioItem] = [
        RadioItem(id: "very_unfair", title: "Very Unfair", image: .processOptionVeryUnfair),
        RadioItem(id: "unfair", title: "Unfair", image: .processOptionUnfair),
        RadioItem(id: "not_sure", title: "Not Sure", image: .processOptionNotSure),
        RadioItem(id: "fair", title: "Fair", image: .processOptionFair),
        RadioItem(id: "very_fair", title: "Very Fair", image: .processOptionVeryFair)
    ]
}

#Preview {
    RadioButtonView(items: RadioButtonView.RadioItem.processOptions, selectedId: .constant("very_fair"))
}

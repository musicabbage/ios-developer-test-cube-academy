//
//  HomeView.swift
//  Nominations
//
//  Created by cabbage on 2023/10/24.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

struct HomeView<ViewModel: HomeViewModelProtocol>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderBarView()
            if viewModel.items.isEmpty {
                VStack(alignment: .center, content: {
                    NominationsHeaderView()
                    HomeEmptyStateView()
                        .frame(maxHeight: .infinity)
                })
            } else {
                ScrollView {
                    NominationsHeaderView()
                    LazyVStack(alignment: .leading, content: {
                        ForEach(viewModel.items) { item in
                            NominationListCell(item: item)
                            Divider()
                        }
                    })
                }
            }
            ButtonBoxView(type: .primary, title: "create NEW NOMINATION") { }
        }
        .background(.cubeLightGrey)
        .onAppear(perform: {
            Task {
                await viewModel.fetchNominationList()
            }
        })
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel_Preview())
}




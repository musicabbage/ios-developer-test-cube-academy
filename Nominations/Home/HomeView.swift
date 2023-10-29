//
//  HomeView.swift
//  Nominations
//
//  Created by cabbage on 2023/10/24.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

struct HomeView<ViewModel: HomeViewModelProtocol>: View {
    
    @EnvironmentObject private var router: NominationsRouter
    @ObservedObject private var viewModel: ViewModel
    @State private var toast: ToastModel? = nil
    
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
            ButtonBoxView(type: .primary, title: "create NEW NOMINATION") { 
                router.navigate(to: .NominationForm)
            }
        }
        .toastView($toast)
        .background(.cubeLightGrey)
    }
}

private extension HomeView {
    func showErrorMessage() {
        guard let errorMessage = viewModel.errorMessage else { return }
        toast = ToastModel(message: errorMessage)
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel_Preview())
}




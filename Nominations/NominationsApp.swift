//
//  NominationsApp.swift
//  Nominations
//
//  Created by Sam Davis on 20/10/2023.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

@main
struct NominationsApp: App {
    
    @ObservedObject private var router = NominationsRouter()
    
    private let networkService = NetworkService(authorisation: .init())
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                HomeView(viewModel: HomeViewModel(networkService: networkService))
                    .navigationDestination(for: NominationsRouter.Destination.self) { destination in
                        switch destination {
                        case .home:
                            HomeView(viewModel: HomeViewModel(networkService: networkService))
                        case .NominationForm:
                            EmptyView()
                        case .NominationSubmitted:
                            EmptyView()
                        }
                    }
            }
            .environmentObject(router)
        }
    }
}

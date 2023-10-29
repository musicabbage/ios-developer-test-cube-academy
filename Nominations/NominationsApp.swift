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
    
    @StateObject private var router: NominationsRouter = NominationsRouter()
    
    private let networkService: NetworkService
    private let nomineeListManager: NomineesListManager
    
    init() {
        let defaultAuthorisation = Authorisation()
        let networkService = NetworkService(authorisation: defaultAuthorisation)
        self.networkService = networkService
        self.nomineeListManager = NomineesListManager(networkService: networkService)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                HomeView(viewModel: HomeViewModel(networkService: networkService,
                                                  nomineeListManager: nomineeListManager))
                    .navigationDestination(for: NominationsRouter.Destination.self) { destination in
                        switch destination {
                        case .home:
                            HomeView(viewModel: HomeViewModel(networkService: networkService,
                                                              nomineeListManager: nomineeListManager))
                        case .NominationForm:
                            NominationForm(viewModel: NominationViewModel(networkService: networkService, nomineeListManager: nomineeListManager))
                        case .NominationSubmitted:
                            SubmittedView()
                        }
                    }
            }
            .environmentObject(router)
        }
    }
}

//
//  NominationViewModel.swift
//  Nominations
//
//  Created by cabbage on 2023/10/26.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI
import Combine

protocol NominationViewModelProtocol: ObservableObject {
    var reason: String { get set }
    var process: String? { get set }
    var nomineeIndex: Int { get set }
    var nomineesList: [NomineeListModel.Item] { get set }
    
    func nominate()
}

class NominationViewModel: NominationViewModelProtocol {
    
    @Published var reason: String = ""
    @Published var process: String? = nil
    @Published var nomineeIndex: Int = -1
    @Published var nomineesList: [NomineeListModel.Item] = []
    
    private let networkService: NetworkServiceProtocol
    private let nomineeListManager: NomineesListManager
    private var cancellables: Set<AnyCancellable> = []
    
    init(networkService: NetworkServiceProtocol, nomineeListManager: NomineesListManager) {
        self.networkService = networkService
        self.nomineeListManager = nomineeListManager
        setupBindings()
    }
    
    func nominate() {
        
    }
}

private extension NominationViewModel {
    func setupBindings() {
        nomineeListManager.nomineeListPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] nomineeListModel in
                guard let self else { return }
                self.nomineesList = nomineeListModel.data
            })
            .store(in: &cancellables)
    }
}

class NominationViewModel_Preview: NominationViewModelProtocol {
    @Published var reason: String = "MOCK MOCK!!"
    @Published var process: String? = nil
    @Published var nomineeIndex: Int = -1
    @Published var nomineesList: [NomineeListModel.Item] = NomineeListModel.mock.data
    
    func nominate() { }
}

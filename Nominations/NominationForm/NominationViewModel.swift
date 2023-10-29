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
    var canSave: Bool { get }
    var errorMessage: String? { get }
    
    func nominate() async -> Bool
}

class NominationViewModel: NominationViewModelProtocol {
    
    @Published var reason: String = ""
    @Published var process: String? = nil
    @Published var nomineeIndex: Int = -1
    @Published var nomineesList: [NomineeListModel.Item] = []
    @Published var canSave: Bool = false
    @Published var errorMessage: String? = nil
    
    private let networkService: NetworkServiceProtocol
    private let nomineeListManager: NomineesListManager
    private var cancellables: Set<AnyCancellable> = []
    
    init(networkService: NetworkServiceProtocol, nomineeListManager: NomineesListManager) {
        self.networkService = networkService
        self.nomineeListManager = nomineeListManager
        setupBindings()
    }
    
    func nominate() async -> Bool {
        guard let process, 0 ..< nomineesList.count ~= nomineeIndex else { return false }
        /**
         "nominee_id": "9a4bd093-eb49-479d-aad4-d9f793c6d2bd",
         "reason": "ooxx",
         "process": "not_sure"
         */
        let nomineeId = nomineesList[nomineeIndex].nomineeId
        let requestData = ["nominee_id": nomineeId,
                           "reason": reason,
                           "process": process]
        let api = TargetAPI(method: .post, bodySchema: .requestJSONObject(requestData), path: "nomination")
        let result = await networkService.request(api, decode: NominationResponse.self)
        switch result {
        case .success:
            return true
        case let .failure(error):
            showErrorMessage(error.localizedDescription)
            return false
        }
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
        
        Publishers.CombineLatest3($reason, $process, $nomineeIndex)
            .map { [weak self] (reason, process, nomineeIndex) -> Bool in
                guard let self else { return false }
                let selectedNominee = 0..<nomineesList.count ~= nomineeIndex
                let wroteReason = !reason.isEmpty
                let selectedProcess = (process != nil) && (process?.isEmpty == false)
                
                return selectedNominee && wroteReason && selectedProcess
            }
            .assign(to: &$canSave)
    }
    
    func showErrorMessage(_ error: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            errorMessage = error
        }
    }
}

class NominationViewModel_Preview: NominationViewModelProtocol {
    @Published var reason: String = "MOCK MOCK!!"
    @Published var process: String? = nil
    @Published var nomineeIndex: Int = -1
    @Published var nomineesList: [NomineeListModel.Item] = NomineeListModel.mock.data
    @Published var canSave: Bool = true
    @Published var errorMessage: String? = "Error"
    
    func nominate() async -> Bool { return true }
}

//
//  HomeViewModel.swift
//  Nominations
//
//  Created by cabbage on 2023/10/25.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import Foundation
import Combine

protocol HomeViewModelProtocol: ObservableObject {
    var items: [NominationDisplayModel] { get }
    var errorMessage: String? { get }
}

class HomeViewModel: HomeViewModelProtocol {
    
    @Published var items: [NominationDisplayModel] = []
    @Published var errorMessage: String?
    
    private let nominationListSubject: PassthroughSubject<NominationListModel, Error> = .init()
    private let networkService: NetworkServiceProtocol
    private let nomineeListManager: NomineesListManagerProtocol
    private var cancellable: AnyCancellable?
    private var nomineesNamesMap: [String: String] = [:]
    
    init(networkService: NetworkServiceProtocol, nomineeListManager: NomineesListManagerProtocol) {
        self.networkService = networkService
        self.nomineeListManager = nomineeListManager
        setupBindings()

        Task {
            await fetchNominationList()
        }
    }
}

private extension HomeViewModel {
    func setupBindings() {
        cancellable = Publishers.CombineLatest(nominationListSubject, nomineeListManager.nomineeListPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard case let .failure(error) = completion, let self else { return }
                
                self.errorMessage = error.localizedDescription
            }, receiveValue: { [weak self] nominationsList, nomineesList in
                guard let self else { return }
                
                let nominees = nomineesList.data
                self.items = nominationsList.data.reduce(into: [NominationDisplayModel](), { partialResult, nominationItem in
                    
                    let name: String
                    if let nominee = nominees.first(where: { $0.nomineeId == nominationItem.nomineeId }) {
                        name = "\(nominee.firstName) \(nominee.lastName)"
                    } else {
                        name = "Cannot find the nominee's name ?_____? "
                    }
                    let displayModel = NominationDisplayModel(nominationId: nominationItem.nominationId,
                                                              reason: nominationItem.reason,
                                                              name: name)
                    partialResult.append(displayModel)
                })
            })
    }
    
    func fetchNominationList() async {
        let api = TargetAPI(bodySchema: .plain, path: "nomination")
        let result = await networkService.request(api, decode: NominationListModel.self)
        
        switch result {
        case let .success(result):
            nominationListSubject.send(result)
        case let .failure(error):
            nominationListSubject.send(completion: .failure(error))
        }
    }
}

class HomeViewModel_Preview: HomeViewModelProtocol {    
    @Published var items: [NominationDisplayModel] = []
    @Published var errorMessage: String?
    
    init() {
        fetchNominationList()
    }
    
    private func fetchNominationList() {
        let mockJson = """
        {"data":[{"nomination_id":"9a7267b8-ced4-484e-949b-209aaefb3c68","nominee_id":"9a4bd093-e9d9-44a2-836b-f4fd8f5579ba","reason":"David always goes above and beyond with all the work that he does. He's also a lovey person to work with!","process":"very_fair","date_submitted":"2023-10-24","closing_date":"2023-10-24"},{"nomination_id":"9a747232-84ef-4e6c-abff-6e04aba4d5a1","nominee_id":"9a4bd093-eb49-479d-aad4-d9f793c6d2bd","reason":"Ali Ali","process":"not_sure","date_submitted":"2023-10-25","closing_date":"2023-10-25"}]}
        """
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let model = try! decoder.decode(NominationListModel.self, from: mockJson.data(using: .utf8)!)
        var mockItems: [NominationDisplayModel] = []
        for nominationItem in model.data {
            let displayItem = NominationDisplayModel(nominationId: nominationItem.nominationId,
                                                     reason: nominationItem.reason,
                                                     name: "mock")
            mockItems.append(displayItem)
        }
        items = mockItems
    }
}

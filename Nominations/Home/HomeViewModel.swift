//
//  HomeViewModel.swift
//  Nominations
//
//  Created by cabbage on 2023/10/25.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import Foundation

protocol HomeViewModelProtocol: ObservableObject {
    var items: [NominationListModel.Item] { get }
    
    func fetchNominationList() async
}

class HomeViewModel: HomeViewModelProtocol {
    
    @Published var items: [NominationListModel.Item] = []
    @Published var errorMessage: String?
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchNominationList() async {
        let api = TargetAPI(bodySchema: .plain, path: "nomination")
        let result = await networkService.request(api, decode: NominationListModel.self)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch result {
            case let .success(result):
                self.items = result.data
            case let .failure(failure):
                self.errorMessage = failure.localizedDescription
            }
        }
    }
}

class HomeViewModel_Preview: HomeViewModelProtocol {
    @Published var items: [NominationListModel.Item] = []
    
    func fetchNominationList() async { 
        let mockJson = """
        {"data":[{"nomination_id":"9a7267b8-ced4-484e-949b-209aaefb3c68","nominee_id":"9a4bd093-e9d9-44a2-836b-f4fd8f5579ba","reason":"David always goes above and beyond with all the work that he does. He's also a lovey person to work with!","process":"very_fair","date_submitted":"2023-10-24","closing_date":"2023-10-24"},{"nomination_id":"9a747232-84ef-4e6c-abff-6e04aba4d5a1","nominee_id":"9a4bd093-eb49-479d-aad4-d9f793c6d2bd","reason":"Ali Ali","process":"not_sure","date_submitted":"2023-10-25","closing_date":"2023-10-25"}]}
        """
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let model = try! decoder.decode(NominationListModel.self, from: mockJson.data(using: .utf8)!)
        items = model.data
    }
}

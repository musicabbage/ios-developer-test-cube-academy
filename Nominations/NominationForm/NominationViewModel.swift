//
//  NominationViewModel.swift
//  Nominations
//
//  Created by cabbage on 2023/10/26.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import SwiftUI

protocol NominationViewModelProtocol: ObservableObject {
    var reason: String { get set }
    var process: String? { get set }
    var nomineeIndex: Int { get set }
    
    func nominate()
}

class NominationViewModel: NominationViewModelProtocol {
    
    @Published var reason: String = ""
    @Published var process: String? = nil
    @Published var nomineeIndex: Int = -1
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func nominate() {
        
    }
}

class NominationViewModel_Preview: NominationViewModelProtocol {
    @Published var reason: String = "MOCK MOCK!!"
    @Published var process: String? = nil
    @Published var nomineeIndex: Int = -1
    
    func nominate() { }
}

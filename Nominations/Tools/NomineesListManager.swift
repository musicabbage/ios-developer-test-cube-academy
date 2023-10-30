//
//  NomineesListManager.swift
//  Nominations
//
//  Created by cabbage on 2023/10/27.
//  Copyright © 2023 3 Sided Cube (UK) Ltd. All rights reserved.
//

import Foundation
import Combine

protocol NomineesListManagerProtocol {
    var nomineeListPublisher: AnyPublisher<NomineeListModel, CubeError> { get }
}

struct NomineesListManager: NomineesListManagerProtocol {
    private let localFilePath = URL.documentsDirectory.appending(path: ".nominees")
    private let ioQueue = DispatchQueue(label: "com.nominations.nomineeslistmanager", qos: .default)
    private let networkService: NetworkService
    private let nomineeListSubject: CurrentValueSubject<NomineeListModel, CubeError> = .init(NomineeListModel(data: []))
    
    let nomineeListPublisher: AnyPublisher<NomineeListModel, CubeError>
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        self.nomineeListPublisher = nomineeListSubject.eraseToAnyPublisher()
        readLocalNomineeList()
        fetchNomineeList()
    }
}

private extension NomineesListManager {
    func fetchNomineeList() {
        Task {
            let api = TargetAPI(bodySchema: .plain, path: "nominee")
            let result = await networkService.request(api, decode: NomineeListModel.self)
            switch result {
            case let .success(model):
                nomineeListSubject.send(model)
                saveNomineeListToLocal(model: model)
            case let .failure(error):
                if nomineeListSubject.value.data.isEmpty {
                    nomineeListSubject.send(completion: .failure(.fetchNomineesFail(error)))
                }
            }
        }
    }
    
    func saveNomineeListToLocal(model: NomineeListModel) {
        ioQueue.async {
            do {
                let encoder = JSONEncoder()
                encoder.keyEncodingStrategy = .convertToSnakeCase
                let data = try encoder.encode(model)
                try data.write(to: localFilePath)
            } catch {
                CubeLog(error)
            }
        }
    }
    
    func readLocalNomineeList() {
        guard FileManager.default.fileExists(atPath: localFilePath.path) else { return }
        ioQueue.async {
            do {
                let localData = try Data(contentsOf: localFilePath)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let nomineeListModel = try decoder.decode(NomineeListModel.self, from: localData)
                nomineeListSubject.send(nomineeListModel)
            } catch {
                CubeLog(error)
            }
        }
    }
}

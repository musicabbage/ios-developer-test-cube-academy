//
//  NetworkService.swift
//  Nominations
//
//  Created by cabbage on 2023/10/24.
//

import Foundation

struct TargetAPI {
    enum Method: String {
        case get, post, put, delete
    }
    
    enum BodySchema {
        case plain
        case requestJSONEncodable(Encodable)
        case requestMultipleDataForm(MultipleBodyDataForm)
    }
    
    let method: Method
    let host: URL.Host
    let schema: BodySchema
    let path: String
    let timeoutInterval: TimeInterval
    
    init(method: Method = .get, host: URL.Host = .API, bodySchema: BodySchema, path: String, timeout: TimeInterval = 15) {
        self.method = method
        self.host = host
        self.schema = bodySchema
        self.path = path
        self.timeoutInterval = timeout
    }
}

protocol NetworkServiceProtocol {
    func request(_ target: TargetAPI) async -> Result<Data, Error>
}

struct NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let authorisation: Authorisation
    
    init(configuration: URLSessionConfiguration = .default, authorisation: Authorisation) {
        session = URLSession(configuration: configuration)
        self.authorisation = authorisation
    }
    
    func request(_ target: TargetAPI) async -> Result<Data, Error> {
        let url = target.host.url.appendingPathComponent(target.path)
        let task = Task { () -> Data in
            var request = URLRequest(url: url)
            request.httpMethod = target.method.rawValue.uppercased()
            request.timeoutInterval = target.timeoutInterval
            //request.httpBody = data
            switch target.schema {
            case .plain:
                let authToken = await authorisation.authToken()
                request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            case let .requestJSONEncodable(encodable):
                let authToken = await authorisation.authToken()
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                request.httpBody = try JSONEncoder().encode(encodable)
            case let .requestMultipleDataForm(form):
                request.setValue(form.contentType, forHTTPHeaderField: "Content-Type")
                request.httpBody = form.encode()
            }
            let (data, _) = try await session.data(for: request)
            return data
        }
        
        return await task.result
    }
}
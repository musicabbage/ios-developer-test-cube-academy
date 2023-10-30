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
        case requestJSONObject(Any)
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
    func request<T: Decodable>(_ target: TargetAPI, decode: T.Type) async -> Result<T, NetworkError>
}

struct NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let authorisation: Authorisation
    
    init(configuration: URLSessionConfiguration = .default, authorisation: Authorisation) {
        session = URLSession(configuration: configuration)
        self.authorisation = authorisation
    }
    
    func request<T: Decodable>(_ target: TargetAPI, decode: T.Type) async -> Result<T, NetworkError> {
        let url = target.host.url.appendingPathComponent(target.path)
        let task = Task { () -> T in
            var request = URLRequest(url: url)
            request.httpMethod = target.method.rawValue.uppercased()
            request.timeoutInterval = target.timeoutInterval
            switch target.schema {
            case .plain:
                let authToken = await authorisation.authToken()
                request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            case let .requestJSONEncodable(encodable):
                let authToken = await authorisation.authToken()
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                let jsonEncoder = JSONEncoder()
                jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
                request.httpBody = try jsonEncoder.encode(encodable)
            case let .requestJSONObject(jsonObject):
                let authToken = await authorisation.authToken()
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
                let jsonData = try JSONSerialization.data(withJSONObject: jsonObject)
                request.httpBody = jsonData
            case let .requestMultipleDataForm(form):
                request.setValue(form.contentType, forHTTPHeaderField: "Content-Type")
                request.httpBody = form.encode()
            }
            
            let (data, response) = try await session.data(for: request)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let response = response as? HTTPURLResponse, 200..<299 ~= response.statusCode {
                let model = try decoder.decode(T.self, from: data)
                return model
            } else if let errorModel = try? decoder.decode(NetworkErrorModel.self, from: data) {
                throw NetworkError.cubeResponseError(errorModel)
            } else {
                throw NetworkError.cubeResponseError(nil)
            }
        }
        
        let result = await task.result
        switch result {
        case let .success(model):
            return .success(model)
        case let .failure(error):
            if let cubeError = error as? NetworkError {
                return .failure(cubeError)
            } else {
                return .failure(.requestError(error))
            }
        }
    }
}

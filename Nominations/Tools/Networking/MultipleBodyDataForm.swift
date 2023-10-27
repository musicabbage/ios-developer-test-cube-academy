//
//  MultipleBodyDataForm.swift
//  Nominations
//
//  Created by cabbage on 2023/10/24.
//

import Foundation

private let streamBufferSize = 1024

class MultipleBodyDataForm {
    fileprivate class BodyPart {
        private(set) var size = 0
        let stream: InputStream
        let header: String
        //swiftlint:disable:next force_unwrapping
        var prefixData: Data { header.data(using: .utf8)! }
        //swiftlint:disable:next force_unwrapping
        var postfixData: Data { "\r\n".data(using: .utf8)! }
        
        init(stream: InputStream, header: String, contentSize: Int = 0) {
            self.stream = stream
            self.header = header
            self.size = contentSize + prefixData.count + postfixData.count
        }

        func encodedData() -> Data {
            let inputStream = stream
            inputStream.open()
            defer { inputStream.close() }
            var encoded = Data()

            while inputStream.hasBytesAvailable {
                var buffer = [UInt8](repeating: 0, count: streamBufferSize)
                let bytesRead = inputStream.read(&buffer, maxLength: streamBufferSize)

                if let error = inputStream.streamError {
                    
                    break
                }

                if bytesRead > 0 {
                    encoded.append(buffer, count: bytesRead)
                } else {
                    break
                }
            }
            return encoded
        }
    }
    private let boundary = UUID().uuidString
    private var boundraySize: Int {
        //swiftlint:disable:next force_unwrapping
        "--\(boundary)\r\n".data(using: .utf8)!.count
    }
    private var bodyParts: [BodyPart] = []
    var contentType: String { "multipart/form-data; boundary=\(boundary)" }
    var bodyContentSize: Int {
        boundraySize * bodyParts.count +
            bodyParts.reduce(0, { $0 + $1.size }) +
            "--\(boundary)--\r\n".data(using: .utf8)!.count //swiftlint:disable:this force_unwrapping
    }

    func append(_ value: String, key: String) {
        let data = value.data(using: .utf8)! // swiftlint:disable:this force_unwrapping
        let stream = InputStream(data: data)
        let header = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
        let part = BodyPart(stream: stream, header: header, contentSize: data.count)
        bodyParts.append(part)
    }

    func append(_ data: Data, key: String) {
        let stream = InputStream(data: data)
        let header = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
        let part = BodyPart(stream: stream, header: header, contentSize: data.count)
        bodyParts.append(part)
    }

    func encode() -> Data {
        var data = Data()

        guard !bodyParts.isEmpty else { return data }

        for part in bodyParts {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)//swiftlint:disable:this force_unwrapping
            data.append(part.header.data(using: .utf8)!) //swiftlint:disable:this force_unwrapping
            data.append(part.encodedData())
            data.append("\r\n".data(using: .utf8)!)//swiftlint:disable:this force_unwrapping
        }
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)//swiftlint:disable:this force_unwrapping
        return data
    }
}

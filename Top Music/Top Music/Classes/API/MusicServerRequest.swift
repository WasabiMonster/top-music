//
//  MusicServerRequest.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/25/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation

typealias MusicServerResponse = Decodable
typealias MusicServerRequestObject = Encodable
typealias HTTPHeaders = [String: String]

enum MultipartType {
    case image
    case json

    func fileExtension() -> String {
        switch self {
        case .image:
            return ".jpg"
        case .json:
            return ".json"
        }
    }
}

struct MultipartRequestObject {
    let name: String
    let filename: String
    let type: MultipartType
    let data: Data
}

// A configurable protocol to be implemented for any server request
// Requests can also be added to the ApiRequest enum for convenience
protocol MusicServerRequest {
    associatedtype ResponseType: MusicServerResponse
    typealias RequestCompletion = (Result<ResponseType, ApiError>) -> Void

    // Implementers must specify the path for the request
    // Should begin with a slash (/)
    // The base server URL is defined by the MuiscApiManager
    var path: String { get }

    // implementers can specify the http method for the request
    // default is GET
    var method: HTTPMethod { get }

    // Implementers can specify any url params to be included in the request
    // UUID, version, and authToken are automatically included in all requests, and don't need
    // to be specified here
    // default is empty list of parameters
    var urlParams: Parameters { get }

    // Implementers can specify any headers to be included in the request
    // defaults to empty list of headers
    var headers: HTTPHeaders { get }

    // Implementers specify any Encodable object to be sent as the body in JSON format
    // default is nil
    var requestBodyObject: MusicServerRequestObject? { get }
}

// Default values
extension MusicServerRequest {

    var method: HTTPMethod {
        return .get
    }

    var urlParams: Parameters {
        return Parameters()
    }

    var headers: HTTPHeaders {
        return [:]
    }

    var requestBodyObject: MusicServerRequestObject? {
        return nil
    }

    var multipartObjects: [MultipartRequestObject] {
        return []
    }
}

// Main execute function
extension MusicServerRequest {
    func execute(apiManager: ApiManager, completion: @escaping RequestCompletion) -> URLSessionTask? {
        log(message: "Start", apiManager: apiManager)
        guard let urlRequest = buildURLRequest(apiManager: apiManager) else {
            fail(withError: .badUrl, apiManager: apiManager, completion: completion)
            return nil
        }

        log(message: "\nMaking request: \(urlRequest.url?.absoluteString ?? "")", apiManager: apiManager)
        let task = apiManager.urlSession.dataTask(with: urlRequest) { data, urlResponse, error in
            self.handleDataTaskResult(data: data,
                                      urlResponse: urlResponse,
                                      error: error,
                                      apiManager: apiManager,
                                      completion: completion)
        }

        task.resume()
        return task as? URLSessionTask
    }

    func handleDataTaskResult(data: Data?,
                              urlResponse: URLResponse?,
                              error: Error?,
                              apiManager: ApiManager,
                              completion: @escaping RequestCompletion) {
        guard error == nil,
            let httpResponse = urlResponse as? HTTPURLResponse,
            let data = data else {
                self.fail(withError: .serverError, apiManager: apiManager, completion: completion)
                return
        }

        guard httpResponse.statusCode > 0 else {
            self.fail(withError: .noInternetConnection, apiManager: apiManager, completion: completion)
            return
        }

        guard httpResponse.statusCode != 503 else {
            self.fail(withError: .serverOverload, apiManager: apiManager, completion: completion)
            return
        }

        guard httpResponse.statusCode != 408 else {
            self.fail(withError: .timeout, apiManager: apiManager, completion: completion)
            return
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            self.fail(withError: .unexpectedResultCode(statusCode: httpResponse.statusCode),
                      apiManager: apiManager,
                      completion: completion)
            return
        }

        self.log(message: "data: \(String(data: data, encoding: .utf8) ?? "<could not decode>")",
                 apiManager: apiManager)
        self.parse(data: data, apiManager: apiManager, completion: completion)
    }

    func parse(data: Data, apiManager: ApiManager, completion: @escaping RequestCompletion) {
        if let responseObject = try? data.decoded(ofType: ResponseType.self) {
            complete(withResponseObject: responseObject, apiManager: apiManager, completion: completion)
        } else if ResponseType.self == EmptyServerResponse.self,
            let response = EmptyServerResponse() as? ResponseType {
            complete(withResponseObject: response, apiManager: apiManager, completion: completion)
        } else {
            fail(withError: .responseDecodingFailed, apiManager: apiManager, completion: completion)
        }
    }
}

// Building request
extension MusicServerRequest {

    func buildURLRequest(apiManager: ApiManager) -> URLRequest? {

        if let url = URL(string: apiManager.baseUrl + path) {
            var request = URLRequest(url: url)

            // method
            request.httpMethod = self.method.rawValue

            // url params
            var params = apiManager.baseUrlParameters
            params.merge(self.urlParams) { _, new in new }
            ParameterEncoder.encode(urlRequest: &request, with: params)

            // headers
            var headers = apiManager.baseHeaders
            headers.merge(self.headers) { _, new in new }
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }

            // body
            if self.multipartObjects.count > 0 {
                let boundary = "Boundary-\(UUID().uuidString)"
                request.httpBody = buildMultipartBody(boundary: boundary)
                request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                request.addValue(String(request.httpBody?.count ?? 0), forHTTPHeaderField: "Content-Length")
            } else if let bodyObject = self.requestBodyObject {
                request.httpBody = try? bodyObject.encoded()
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            return request
        }
        return nil
    }

    func buildMultipartBody(boundary: String) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"

        for multipartObject in self.multipartObjects {
            body.append(Data(boundaryPrefix.utf8))
            switch multipartObject.type {
            case .image:
                body.append(Data("Content-Disposition: form-data; name=\"\(multipartObject.name)\"; filename=\"\(multipartObject.filename)\"\r\n".utf8))
                body.append(Data("Content-Type: image/jpeg\r\nContent-Transfer-Encoding: binary\r\n\r\n".utf8))
            case .json:
                body.append(Data("Content-Disposition: form-data; name=\"\(multipartObject.name)\"\r\n".utf8))
                body.append(Data("Content-Type: application/json\r\n\r\n".utf8))
            }
            body.append(multipartObject.data)
            body.append(Data("\r\n".utf8))
        }

        body.append(Data("--\(boundary)--".utf8))
        return body
    }
}

// Logging
extension MusicServerRequest {

    func complete(withResponseObject responseObject: ResponseType,
                  apiManager: ApiManager,
                  completion: @escaping RequestCompletion ) {
        log(message: "COMPLETED: \(String(describing: responseObject))", apiManager: apiManager)
        DispatchQueue.main.async {
            completion(.success(responseObject))
        }
    }

    func fail(withError error: ApiError,
              apiManager: ApiManager,
              completion: @escaping RequestCompletion) {
        let message = "ERROR: \(String(describing: error))"
        log(message: message, apiManager: apiManager)
        DispatchQueue.main.async {
            completion(.failure(error))
        }
    }

    func log(message: String, apiManager: ApiManager) {
        if apiManager.debuggingEnabled {
            print("[MusicApiRequest: \(String(describing: type(of: self)))] \(message)")
        }
    }

}

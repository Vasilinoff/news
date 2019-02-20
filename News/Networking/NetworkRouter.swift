//
//  NetworkRouter.swift
//  News
//
//  Created by Ponomarev Vasiliy on 16/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//

import Foundation

typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol NetworkRouter: class {
    associatedtype Configuration: ConfigurationType

    func request(_ configuration: Configuration, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<Configuration: ConfigurationType>: NetworkRouter {
    private var task: URLSessionTask?

    func request(_ configuration: Configuration, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared

        do {
            let request = try self.buildRequest(from: configuration)
            print(request.url)
            
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                completion(data, response, error)
            })
            task?.resume()
        } catch {
            completion(nil, nil, error)
        }
    }

    func cancel() {
        self.task?.cancel()
    }

    private func buildRequest(from configuration: Configuration) throws -> URLRequest {
        var request = URLRequest(url: configuration.baseURL.appendingPathComponent(configuration.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = configuration.httpMethod.rawValue
        do {
            switch configuration.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            case .requestParametersAndHeaders(let bodyParameters,
                                              let urlParameters,
                                              let additionHeaders):
                self.addAdditionalHeaders(additionHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            }
        }
        return request
    }

    private func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }

    func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}

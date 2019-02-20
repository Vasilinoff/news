//
//  ConfigurationType.swift
//  News
//
//  Created by Ponomarev Vasiliy on 16/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//

import Foundation

protocol ConfigurationType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: Method { get }
    var task: Task { get }
    var headers: HTTPHeaders? { get }
}

enum Method: String {
    case get = "GET"
    case post = "POST"
}

public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]


enum Task {
    case request

    case requestParameters(bodyParameters: Parameters?, urlParameters: Parameters?)

    case requestParametersAndHeaders(bodyParameters: Parameters?,
                                     urlParameters: Parameters?,
                                     additionHeaders: HTTPHeaders?)
}

enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}


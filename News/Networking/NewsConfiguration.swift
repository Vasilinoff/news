//
//  NewsConfiguration.swift
//  News
//
//  Created by Ponomarev Vasiliy on 16/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//

import Foundation


enum NetworkEnvironment {
    case dev
}

enum NewsApi {
    case articles
    case article(newsId: NewsId)
}

extension NewsApi: ConfigurationType {

    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .dev: return "https://cfg.tinkoff.ru/news/public/api/platform/v1/"
        }
    }

    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }

    var path: String {
        switch self {

        case .articles:
            return "getArticles"
        case .article:
            return "getArticle"
        }
    }

    var httpMethod: Method {
        return .get
    }

    var task: Task {
        switch self {
        case .articles:
            return .requestParameters(bodyParameters: nil, urlParameters: [
                "pageSize": 10,
                "pageOffset": 40
                ])
        case .article(let newsId):
            return .requestParameters(bodyParameters: nil, urlParameters: ["urlSlug": newsId])
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}

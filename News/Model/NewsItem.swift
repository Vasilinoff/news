//
//  NewsItem.swift
//  News
//
//  Created by Ponomarev Vasiliy on 18/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//

import Foundation

struct NewsArticleResponse: Decodable {
    let response: NewsItem

    enum CodingKeys: String, CodingKey {
        case response
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.response = try container.decode(NewsItem.self, forKey: .response)
    }

}

struct NewsItem {
    let title: String
    let date: String
    let text: String
}

extension NewsItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case title
        case date
        case text
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        let tempDate: Date = try container.decodeDate(.date)
        self.date = DateFormatterBuilder.ddMMyyyy.string(from: tempDate)
        self.text = try container.decode(String.self, forKey: .text)
    }
}

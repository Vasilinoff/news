//
//  NewsItem.swift
//  News
//
//  Created by Ponomarev Vasiliy on 18/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
import CoreData
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

struct NewsItem: Decodable {
    let id: String
    let title: String
    let date: String
    let text: String

    enum CodingKeys: String, CodingKey {
        case title
        case date
        case text
        case id
    }

    init(id: String, title: String, date: String, text: String) {
        self.id = id
        self.text = text
        self.title = title
        self.date = date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        let tempDate: Date = try container.decodeDate(.date)
        self.date = DateFormatterBuilder.ddMMyyyyHHmmString(from: tempDate)
        self.text = try container.decode(String.self, forKey: .text)
        self.id = try container.decode(String.self, forKey: .id)
    }
}

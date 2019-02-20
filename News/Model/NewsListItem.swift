//
//  NewsListItem.swift
//  News
//
//  Created by Ponomarev Vasiliy on 18/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
import UIKit
import Foundation

struct NewsListResponse: Decodable {
    let response: Response

    enum CodingKeys: String, CodingKey {
        case response
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.response = try container.decode(Response.self, forKey: .response)
    }

}

struct Response: Decodable {
    let total: Int
    let news: [NewsListItem]

    enum CodingKeys: String, CodingKey {
        case total
        case news
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.news = try container.decode([NewsListItem].self, forKey: .news)
        self.total = try container.decode(Int.self, forKey: .total)
    }
}


struct NewsListItem {
    let id: String
    let title: String
    let date: String
    let slug: String
}

extension NewsListItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case date
        case slug
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        let tempDate: Date = try container.decodeDate(.date)
        self.date = DateFormatterBuilder.ddMMyyyy.string(from: tempDate)
        self.slug = try container.decode(String.self, forKey: .slug)
    }
}


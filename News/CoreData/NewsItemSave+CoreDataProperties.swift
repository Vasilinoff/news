//
//  NewsItemSave+CoreDataProperties.swift
//  News
//
//  Created by Ponomarev Vasiliy on 22/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
//

import Foundation
import CoreData

extension NewsItemSave {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsItemSave> {
        return NSFetchRequest<NewsItemSave>(entityName: "NewsItemSave")
    }

    @NSManaged public var date: String
    @NSManaged public var text: String
    @NSManaged public var title: String
    @NSManaged public var id: String
}

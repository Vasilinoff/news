//
//  NewsListItemSave+CoreDataProperties.swift
//  News
//
//  Created by Ponomarev Vasiliy on 22/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
//

import Foundation
import CoreData

extension NewsListItemSave {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsListItemSave> {
        return NSFetchRequest<NewsListItemSave>(entityName: "NewsListItemSave")
    }

    @NSManaged public var date: String
    @NSManaged public var slug: String
    @NSManaged public var title: String
    @NSManaged public var id: String
    @NSManaged public var counter: NSNumber

}

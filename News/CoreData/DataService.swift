//
//  NewSaveService.swift
//  News
//
//  Created by Ponomarev Vasiliy on 22/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
import CoreData
import Foundation

class DataService {
    fileprivate let coreDataStack = CoreDataStack.sharedCoreDataStack

    func getNewsListItem() throws -> [NewsListItem]  {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsListItemSave")
        request.returnsObjectsAsFaults = false
        var newsListItems = [NewsListItem]()
        do {
            guard let result = try coreDataStack.mainContext?.fetch(request) as? [NSManagedObject] else { return newsListItems }
            for item in result {
                guard let newsItem = item as? NewsListItemSave else { return newsListItems}
                let newsListItem = NewsListItem(id: newsItem.id, title: newsItem.title, date: newsItem.date, slug: newsItem.slug)
                newsListItems.append(newsListItem)
            }
            return newsListItems

        } catch {
            print("Failed")
        }
        return newsListItems
    }

    func getNewsItem(id: String) throws -> NewsItem? {
        guard let context = coreDataStack.mainContext else { return nil }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsItemSave")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", id)
        guard let items = try? context.fetch(request),
            let newsItems = items as? [NSManagedObject],
            let newsItemSave = newsItems.first as? NewsItemSave else { return nil }

        let newsItem = NewsItem(id: newsItemSave.id, title: newsItemSave.title, date: newsItemSave.date, text: newsItemSave.text)
        return newsItem
    }

    func saveNewsListItem(_ newsListItem: NewsListItem) {
        if let context = coreDataStack.saveContext {
            let entity = NSEntityDescription.entity(forEntityName: "NewsListItemSave", in: context)
            let newsListSaveItem = NSManagedObject(entity: entity!, insertInto: context)
            newsListSaveItem.setValue(newsListItem.title, forKey: "title")
            newsListSaveItem.setValue(newsListItem.slug, forKey: "slug")
            newsListSaveItem.setValue(newsListItem.date, forKey: "date")
            newsListSaveItem.setValue(newsListItem.id, forKey: "id")
            performSave(context: context, completionHandler: { _,_ in })
        }
    }

    func saveNewsItem(_ newsItem: NewsItem) {
        if let context = coreDataStack.saveContext {
            let entity = NSEntityDescription.entity(forEntityName: "NewsItemSave", in: context)
            let newsItemSave = NSManagedObject(entity: entity!, insertInto: context)
            newsItemSave.setValue(newsItem.title, forKey: "title")
            newsItemSave.setValue(newsItem.text, forKey: "text")
            newsItemSave.setValue(newsItem.date, forKey: "date")
            newsItemSave.setValue(newsItem.id, forKey: "id")
            performSave(context: context, completionHandler: { _, error in
            })
        }
    }

    func deleteAllNews() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsListItemSave")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        if let saveContext = coreDataStack.saveContext {
            do {
                try saveContext.persistentStoreCoordinator?.execute(deleteRequest, with: saveContext)
            } catch {
                print("failed to delete Entities")
            }
        }
    }

    fileprivate func performSave(context: NSManagedObjectContext, completionHandler: @escaping (Bool, Error?) -> Void) {
        if context.hasChanges {
            context.perform {
                [weak self] in

                do {
                    try context.save()
                }
                catch {
                    DispatchQueue.main.async { completionHandler(false, error) }
                    print("Context save error: \(error)")
                }

                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                }
                else {
                    DispatchQueue.main.async { completionHandler(true, nil) }
                }
            }
        }
        else {
            completionHandler(true, nil)
        }
    }
}

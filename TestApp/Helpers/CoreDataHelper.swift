//
//  CoreDataHelper.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 5.10.2022.
//

import UIKit
import CoreData
import Combine

final class CoreDataHelper {
    static let shared = CoreDataHelper.init()
    private var context:NSManagedObjectContext?
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.context = appDelegate?.persistentContainer.viewContext
    }
}

//MARK: - functions
extension CoreDataHelper: ServiceHelperProtocol {
    //get Items from Core Data
    public func fetchItems() -> Future<[ToDoItem], CoreDataErrors> {
        return Future { promise in
         
            guard let context = self.context else { return promise(.failure(CoreDataErrors.contextIsNil)) }
            let fetchContext = NSFetchRequest<NSFetchRequestResult>(entityName: StaticValues.coreDataEntityName.rawValue)
            fetchContext.returnsDistinctResults = false
            
            do {
                if let coreDataArray = try context.fetch(fetchContext) as? [NSManagedObject] {
                    let toDoItemArray = coreDataArray.map(ToDoItem.init)
                    promise(.success(toDoItemArray))
                }else {
                    promise(.failure(CoreDataErrors.parseError))
                }
            }catch {
                promise(.failure(CoreDataErrors.parseError))
            }
            
        }
    }
    
    
    //Save item to Core Data
    public func saveItem(title: String?, detail: String?) -> Future<UUID, CoreDataErrors> {
        return Future { promise in
            
            guard let context = self.context else { return promise(.failure(CoreDataErrors.contextIsNil)) }
            if let title = title, let detail = detail {
                let saveContext = NSEntityDescription.insertNewObject(forEntityName: StaticValues.coreDataEntityName.rawValue, into: context)
                let id = UUID()
                saveContext.setValue(id, forKey: StaticValues.coreDateAttribute_id.rawValue)
                saveContext.setValue(title, forKey: StaticValues.coreDateAttribute_title.rawValue)
                saveContext.setValue(detail, forKey: StaticValues.coreDateAttribute_detail.rawValue)
                
                do{
                    try context.save()
                    promise(.success(id))
                } catch {
                    promise(.failure(CoreDataErrors.coreDataSaveError))
                }
                
            }else {
                promise(.failure(CoreDataErrors.attributeIsNil))
            }
            
        }
    }
    
    
    //Remove item from Core Data
    public func removeItem(id: UUID) -> Future<UUID, CoreDataErrors> {
        return Future { promise in
            
            guard let context = self.context else { return promise(.failure(CoreDataErrors.contextIsNil)) }
            let removeContext = NSFetchRequest<NSFetchRequestResult>(entityName: StaticValues.coreDataEntityName.rawValue)
            removeContext.predicate = NSPredicate.init(format: "\(StaticValues.coreDateAttribute_id.rawValue) = %@", "\(id)")
            do {
                guard let results = try context.fetch(removeContext) as? [NSManagedObject] else { return promise(.failure(CoreDataErrors.parseError)) }
                
                if results.count > 0 {
                    for result in results {
                        context.delete(result)
                    }
                    try context.save()
                    return promise(.success(id))
                } else {
                    return promise(.failure(CoreDataErrors.notFound))
                }
                
            }catch {
                return promise(.failure(CoreDataErrors.notFound))
            }
            
        }
    }
}

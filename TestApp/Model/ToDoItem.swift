//
//  ToDoItem.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 5.10.2022.
//

import Foundation
import CoreData

struct ToDoItem: Hashable {    
    public init(coreDataItem: NSManagedObject?) {
        self.id = coreDataItem?.value(forKey: StaticValues.coreDateAttribute_id.rawValue) as? UUID
        self.title = coreDataItem?.value(forKey: StaticValues.coreDateAttribute_title.rawValue) as? String
        self.detail = coreDataItem?.value(forKey: StaticValues.coreDateAttribute_detail.rawValue) as? String
    }
    
    public init(id: UUID?, title: String?, detail: String?) {
        self.id = id ?? UUID()
        self.title = title ?? ""
        self.detail = detail ?? ""
    }
    
    var id: UUID?
    var title: String?
    var detail: String?
}

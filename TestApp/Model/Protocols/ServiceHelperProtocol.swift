//
//  ToDoListActionProtocol.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 5.10.2022.
//

import Foundation
import Combine

protocol ServiceHelperProtocol {
    func fetchItems() -> Future<[ToDoItem], CoreDataErrors>
    func saveItem(title: String?, detail: String?) -> Future<UUID, CoreDataErrors>
    func removeItem(id: UUID) -> Future<UUID, CoreDataErrors>
}

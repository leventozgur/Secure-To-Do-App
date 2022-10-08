//
//  CustomDiffableDataSourceProtocol.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 6.10.2022.
//

import Foundation

protocol CustomDiffableDataSourceProtocol {
    func isDeletedItem(item: ToDoItem, index: Int)
}

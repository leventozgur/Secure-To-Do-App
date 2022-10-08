//
//  CustomDiffableDataSource.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 6.10.2022.
//
import UIKit

class CustomDiffableDataSource: UITableViewDiffableDataSource<TableViewSection, ToDoItem> {

    public var delegate: CustomDiffableDataSourceProtocol?

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let item = itemIdentifier(for: indexPath) else { return }
            delegate?.isDeletedItem(item: item, index: indexPath.row)
        }
    }

}

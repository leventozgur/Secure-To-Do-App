//
//  MainViewModel.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 5.10.2022.
//

import Combine
import UIKit

final class MainViewModel {
    
    public var source: ServiceHelperProtocol?
    
    private var toDoItemsArray: [ToDoItem]?   
    private var dataSource: UITableViewDiffableDataSource<TableViewSection, ToDoItem>?
    
    public let action = PassthroughSubject<Int, Never>()
    private var observers: [AnyCancellable] = []
    
    public init(source: ServiceHelperProtocol) {
        self.source = source
        fetchItems()
    }
    
    deinit {
        observers.forEach({ $0.cancel() })
    }
    
}

//MARK: - Functions
extension MainViewModel {
    func getToDoItemsArrayCount() -> Int {
        return toDoItemsArray?.count ?? 0
    }
    
    func getToDoItemsArrayItem(with index: Int) -> ToDoItem? {
        guard let item = toDoItemsArray?[index] else { return nil }
        return item
    }
    
    public func defineDiffDataSource(_ todoTableview: UITableView) {
        let customDiffableDataSource = CustomDiffableDataSource(tableView: todoTableview) { tableView, indexPath, itemIdentifier in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
            if let item = self.getToDoItemsArrayItem(with: indexPath.row), let title = item.title, let detail = item.detail {
                cell.configure(title: title, detail: detail)
            }
            return cell
        }
        customDiffableDataSource.delegate = self
        self.dataSource = customDiffableDataSource
        dataSource?.defaultRowAnimation = .fade
        updateDataSource()
    }
    
    public func updateDataSource() {
        guard let toDoItemsArray = toDoItemsArray else {return}
        var snapShot = NSDiffableDataSourceSnapshot<TableViewSection, ToDoItem>()
        snapShot.appendSections([.main])
        snapShot.appendItems(toDoItemsArray)
        dataSource?.apply(snapShot, animatingDifferences: true, completion: nil)
        
        self.action.send(self.getToDoItemsArrayCount())
    }
}

//MARK: - CustomDiffableDataSourceProtocol
extension MainViewModel:CustomDiffableDataSourceProtocol {
    func isDeletedItem(item: ToDoItem, index: Int) {
        guard let uuid = item.id else { return }
        removeItem(id: uuid)
    }
}

//MARK: - Core Data Actions
extension MainViewModel {
    func fetchItems() {
        source?.fetchItems()
            .sink { completion in
            switch completion {
            case .finished:
                self.updateDataSource()
            case .failure(let error):
                print(error)
            }
        } receiveValue: { [weak self] items in
            guard let strongSelf = self else { return }
            strongSelf.toDoItemsArray = items
        }.store(in: &observers)
    }
    
    func addItem(title: String?, detail: String?) {
        source?.saveItem(title: title, detail: detail)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.updateDataSource()
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { [weak self] id in
            guard let strongSelf = self else { return }
            let item = ToDoItem(id: id, title: title, detail: detail)
            strongSelf.toDoItemsArray?.append(item)
        }).store(in: &observers)
    }
    
    func removeItem(id: UUID) {
        source?.removeItem(id: id)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.updateDataSource()
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { [weak self] id in
            guard let strongSelf = self else { return }
            if let index = strongSelf.toDoItemsArray?.firstIndex(where: { $0.id == id }) {
                strongSelf.toDoItemsArray?.remove(at: index)
            }
        }).store(in: &observers)
    }
}

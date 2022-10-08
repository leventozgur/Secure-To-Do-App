//
//  DetailViewModel.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 7.10.2022.
//

import Foundation

final class DetailViewModel {
    
    private var item: ToDoItem?
    
    init(item: ToDoItem){
        self.item = item
    }
}

extension DetailViewModel {
    public func getItemDetail() -> ToDoItem? {
        return item
    }
}

//
//  TestAppTests.swift
//  TestAppTests
//
//  Created by Levent ÖZGÜR on 5.10.2022.
//

import XCTest
import Combine
@testable import TestApp

class CoreDataTests: XCTestCase {

    var observers: [AnyCancellable] = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test01_SaveItem_CoreDataHelper() throws {
        CoreDataHelper.shared.saveItem(title: "title", detail: "detail").sink { completion in
            switch completion {
            case .failure(let error):
                XCTFail(String(describing: error))
            case .finished:
                print("finished")
            }
        } receiveValue: { uuid in
            XCTAssertNotNil(uuid, "UUID comes nil")
        }.store(in: &observers)
    }

    func test02_GetItems_CoreDataHelper() throws {
        CoreDataHelper.shared.fetchItems().sink { completion in
            switch completion {
            case .failure(let error):
                XCTFail(String(describing: error))
            case .finished:
                print("finished")
            }
        } receiveValue: { items in
            XCTAssertGreaterThan(items.count, 0)
        }.store(in: &observers)
    }

    func test03_DeleteItem_CoreDataHelper() throws {
        
        CoreDataHelper.shared.fetchItems().sink { completion in
            switch completion {
            case .failure(let error):
                XCTFail(String(describing: error))
            case .finished:
                print("finished")
            }
        } receiveValue: { items in
            
            CoreDataHelper.shared.removeItem(id: (items.last?.id)!).sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail(String(describing: error))
                case .finished:
                    print("finished")
                }
            } receiveValue: { uuid in
                XCTAssertNotNil(uuid, "UUID comes nil")
            }.store(in: &self.observers)
            
        }.store(in: &observers)
    }
    
    func test04_FailDeleteItem_CoreDataHelper() throws {
        CoreDataHelper.shared.removeItem(id: UUID()).sink { completion in
            switch completion {
            case .failure(let error):
                XCTAssertEqual(String(describing: error), "notFound")
            case .finished:
                print("finished")
            }
        } receiveValue: { uuid in
            XCTFail("Not working correctly")
        }.store(in: &self.observers)
    }
    
    func test05_SaveItem_MainViewModel() throws {
        let vm = MainViewModel(source: CoreDataHelper.shared)
        let currentItemCount = vm.getToDoItemsArrayCount()
        
        vm.action.sink { count in
            XCTAssertGreaterThan(count, currentItemCount)
        }.store(in: &observers)

        vm.addItem(title: "title", detail: "detail")
    }
    
    func test06_FetchItem_MainViewModel() throws {
        let vm = MainViewModel(source: CoreDataHelper.shared)
        let currentItemCount = vm.getToDoItemsArrayCount()
        XCTAssertGreaterThan(currentItemCount, 0)
        
        let itemCount = vm.getToDoItemsArrayCount()
        let lastItem = vm.getToDoItemsArrayItem(with: itemCount - 1)
        XCTAssertEqual("title", lastItem?.title)
        XCTAssertEqual("detail", lastItem?.detail)
    }
    
    func test07_RemoveItem_MainViewModel() throws {
        let vm = MainViewModel(source: CoreDataHelper.shared)
        let currentItemCount = vm.getToDoItemsArrayCount()
        
        vm.action.sink { count in
            XCTAssertLessThan(count, currentItemCount)
        }.store(in: &observers)

        let itemCount = vm.getToDoItemsArrayCount()
        let lastItem = vm.getToDoItemsArrayItem(with: itemCount - 1)
        guard let uuid = lastItem?.id else {return XCTFail("UUID nil")}
        vm.removeItem(id: uuid)
    }

}

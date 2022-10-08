//
//  KeyChainTests.swift
//  TestAppTests
//
//  Created by Levent ÖZGÜR on 7.10.2022.
//

import XCTest
import Combine
@testable import TestApp

class KeyChainTests: XCTestCase {
    var observers: [AnyCancellable] = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test01_savePassword_KeyChainHelper() throws {
        KeyChainHepler.shared.savePassword(password: "leventozgur123").sink { completion in
            switch completion {
            case .failure(let error):
                if error != KeyChainErrors.duplicateEntry {
                    XCTFail(String(describing: error))
                }
            case .finished:
                print("finished")
                self.getPassword_KeyChainHelper(isEqualPassword: "leventozgur123")
            }
        } receiveValue: { _ in }.store(in: &observers)

    }

    func test02_getPassword_KeyChainHelper() throws {
        getPassword_KeyChainHelper(isEqualPassword: "leventozgur123")
    }

    func test03_updatePassword_KeyChainHelper() throws {
        KeyChainHepler.shared.updatePassword(newPassword: "LeventOzgur123*").sink { completion in
            switch completion {
            case .failure(let error):
                XCTFail(String(describing: error))
            case .finished:
                self.getPassword_KeyChainHelper(isEqualPassword: "LeventOzgur123*")
            }
        } receiveValue: { _ in }.store(in: &observers)
    }

    func test04_deletePassword_KeyChainHelper() throws {
        KeyChainHepler.shared.deletePassword().sink { completion in
            switch completion {
            case .failure(let error):
                if error != KeyChainErrors.duplicateEntry {
                    XCTFail(String(describing: error))
                }
            case .finished:
                print("finished")
            }
        } receiveValue: { _ in }.store(in: &observers)
    }

    func test05_checkPassword_LoginViewModel() throws {
        try test01_savePassword_KeyChainHelper()
        
        let vm = LoginViewModel(source: KeyChainHepler.shared)

        vm.action.sink { status in
            XCTAssertTrue(status)
        }.store(in: &observers)

        vm.checkPassword(userPassword: "leventozgur123")
    }

}

//MARK: - Functions
extension KeyChainTests {
    func getPassword_KeyChainHelper(isEqualPassword: String) {
        KeyChainHepler.shared.getPassword().sink { completion in
            switch completion {
            case .failure(let error):
                XCTFail(String(describing: error))
            case .finished:
                print("finished")
            }
        } receiveValue: { password in
            XCTAssertEqual(password, isEqualPassword)
        }.store(in: &observers)
    }
}

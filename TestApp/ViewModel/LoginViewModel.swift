//
//  LoginViewModel.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 7.10.2022.
//

import Foundation
import Combine

final class LoginViewModel {
    public var source: PasswordStoreServiceProtocol?
    public let action = PassthroughSubject<Bool, Never>()
    private var observers: [AnyCancellable] = []
    
    public init(source: PasswordStoreServiceProtocol) {
        self.source = source
    }
    
    deinit {
        observers.forEach({ $0.cancel() })
    }
}

//MARK: - PasswordStoreService Function
extension LoginViewModel {
    func checkPassword(userPassword: String) {
        source?.getPassword().sink(receiveCompletion: {completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(let error):
                print(error)
                self.action.send(false)
            }
        }, receiveValue: { password in
            if userPassword == password {
                self.action.send(true)
            }else {
                self.action.send(false)
            }
        }).store(in: &observers)
    }
}

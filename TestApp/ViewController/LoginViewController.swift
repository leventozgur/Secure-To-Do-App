//
//  LoginViewController.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 7.10.2022.
//

import UIKit
import Combine

class LoginViewController: UIViewController {

    private var viewModel = LoginViewModel(source: KeyChainHepler.shared)
    private var observers: [AnyCancellable] = []
    private let isDemoMode: Bool = true

    let titleLbl: UILabel = {
        let tmp = UILabel()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.font = UIFont.boldSystemFont(ofSize: 18)
        tmp.textAlignment = .center
        tmp.text = "Secure To-Do List App Login"
        return tmp
    }()
    
    let hintLbl: UILabel = {
        let tmp = UILabel()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.font = UIFont.systemFont(ofSize: 13)
        tmp.textAlignment = .center
        tmp.text = "Hint: Password is leventozgur123"
        tmp.textColor = .gray
        return tmp
    }()

    let passwordTextField: CustomTextField = {
        let tmp = CustomTextField()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.layer.borderColor = UIColor.lightGray.cgColor
        tmp.layer.borderWidth = 1
        tmp.layer.cornerRadius = 6
        tmp.isSecureTextEntry = true
        tmp.placeholder = "Password enter here..."
        return tmp
    }()

    let loginBtn: UIButton = {
        let tmp = UIButton()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.backgroundColor = .systemBlue
        tmp.setTitle("Login", for: .normal)
        tmp.layer.cornerRadius = 6
        var configuration = UIButton.Configuration.plain()
        configuration.baseBackgroundColor = .systemBlue
        tmp.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        return tmp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObservers()
        setupUI()
        
        if isDemoMode {
            demoMode()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        observers.forEach({ $0.cancel() })
    }

}

//MARK: - settings
extension LoginViewController {

    private func setupUI() {
        self.view.backgroundColor = .white

        self.view.addSubview(titleLbl)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginBtn)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: self.view.layer.bounds.height / 10),
            titleLbl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
            titleLbl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),

            passwordTextField.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 30.0),
            passwordTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
            passwordTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),

            loginBtn.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: isDemoMode ? 40.0 : 10.0),
            loginBtn.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
            loginBtn.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
        ])
    }

    private func setObservers() {
        self.viewModel.action.sink { [weak self] status in
            guard let strongSelf = self else { return }
            if status {
                let vc = MainViewController()
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            } else {
                strongSelf.showAlert(text: "Wrong Password. Please try again.")
            }
        }.store(in: &observers)
    }
}

//MARK: - functions
extension LoginViewController {
    private func demoMode() {
        KeyChainHepler.shared.savePassword(password: "leventozgur123")
        KeyChainHepler.shared.updatePassword(newPassword: "leventozgur123")
        
        let safeArea = self.view.safeAreaLayoutGuide
        if isDemoMode {
            self.view.addSubview(hintLbl)
            NSLayoutConstraint.activate([
                hintLbl.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5.0),
                hintLbl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
                hintLbl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
            ])
        }
    }
    
    private func showAlert(text: String) {
        let alert = UIAlertController(title: "Alert", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

//MARK: objc functions
@objc
extension LoginViewController {
    func loginBtnTapped() {
        if let password = self.passwordTextField.text, password.count > 0 {
            self.viewModel.checkPassword(userPassword: password)
        } else {
            showAlert(text: "Password area is empty.")
        }
    }
}

//
//  AddNewItemView.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 5.10.2022.
//

import UIKit

final class AddNewItemAlertView: UIViewController {
    public var delegate: AddNewItemAlertViewProtocol?

    let cancelBtn: UIButton = {
        let tmp = UIButton()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.backgroundColor = .clear
        tmp.accessibilityIdentifier = "cancelBtn"
        tmp.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        return tmp
    }()

    let closeBtn: UIButton = {
        let tmp = UIButton()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.backgroundColor = .clear
        tmp.accessibilityIdentifier = "closeBtn"
        tmp.setImage(UIImage(systemName: "multiply"), for: .normal)
        tmp.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        return tmp
    }()

    let container: UIView = {
        let tmp = UIView()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.backgroundColor = .white
        tmp.layer.cornerRadius = 10
        return tmp
    }()

    let alertTitleLbl: UILabel = {
        let tmp = UILabel()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.text = "Add New Item"
        tmp.font = UIFont.boldSystemFont(ofSize: 18)
        tmp.textColor = .black
        tmp.textAlignment = .center
        return tmp
    }()

    let itemTitleTextField: CustomTextField = {
        let tmp = CustomTextField()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.layer.borderColor = UIColor.lightGray.cgColor
        tmp.layer.borderWidth = 1
        tmp.layer.cornerRadius = 6
        tmp.placeholder = "Title"
        return tmp
    }()

    let itemDetailTextField: UITextView = {
        let tmp = UITextView()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.layer.borderColor = UIColor.lightGray.cgColor
        tmp.layer.borderWidth = 1
        tmp.layer.cornerRadius = 6
        tmp.returnKeyType = .done
        return tmp
    }()

    let sendBtn: UIButton = {
        let tmp = UIButton()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.backgroundColor = .systemBlue
        tmp.setTitle("save", for: .normal)
        tmp.accessibilityIdentifier = "sendButton"
        tmp.layer.cornerRadius = 6
        var configuration = UIButton.Configuration.plain()
        configuration.baseBackgroundColor = .systemBlue
        tmp.addTarget(self, action: #selector(saveDataTapped), for: .touchUpInside)
        return tmp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

//MARK: - settings
extension AddNewItemAlertView {
    private func setupUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        self.view.addSubview(cancelBtn)
        self.view.addSubview(container)
        self.container.addSubview(closeBtn)
        self.container.addSubview(alertTitleLbl)
        self.container.addSubview(itemTitleTextField)
        self.container.addSubview(itemDetailTextField)
        self.container.addSubview(sendBtn)

        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            cancelBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            cancelBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            cancelBtn.topAnchor.constraint(equalTo: self.view.topAnchor),
            cancelBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            closeBtn.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 1),
            closeBtn.topAnchor.constraint(equalTo: container.topAnchor, constant: -1),
            closeBtn.heightAnchor.constraint(equalToConstant: 50),
            closeBtn.widthAnchor.constraint(equalToConstant: 50),

            container.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            container.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            container.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -50),
            container.heightAnchor.constraint(equalToConstant: 320),

            alertTitleLbl.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            alertTitleLbl.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            alertTitleLbl.topAnchor.constraint(equalTo: closeBtn.bottomAnchor),

            itemTitleTextField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            itemTitleTextField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            itemTitleTextField.topAnchor.constraint(equalTo: alertTitleLbl.bottomAnchor, constant: 20),

            itemDetailTextField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            itemDetailTextField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            itemDetailTextField.topAnchor.constraint(equalTo: itemTitleTextField.bottomAnchor, constant: 10),
            itemDetailTextField.heightAnchor.constraint(equalToConstant: 100),

            sendBtn.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            sendBtn.widthAnchor.constraint(equalToConstant: 150),
            sendBtn.heightAnchor.constraint(equalToConstant: 40),
            sendBtn.topAnchor.constraint(equalTo: itemDetailTextField.bottomAnchor, constant: 30),
        ])
    }
}


//MARK: - objc functions
@objc
extension AddNewItemAlertView {
    private func dismissAlert() {
        self.dismiss(animated: true)
    }

    private func saveDataTapped() {
        guard let title = itemTitleTextField.text, !title.isEmpty,
            let detail = itemDetailTextField.text, !detail.isEmpty else {
            print("Show Empty Error")
            return
        }
        delegate?.addNewItem(title: title, detail: detail)
        clearForm()
    }
}

//MARK: - Functions
extension AddNewItemAlertView {
    private func clearForm() {
        itemTitleTextField.text = ""
        itemDetailTextField.text = ""
    }
}

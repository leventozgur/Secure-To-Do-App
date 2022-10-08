//
//  MainViewController.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 5.10.2022.
//

import UIKit
import Combine

final class MainViewController: UIViewController {

    private var viewModel = MainViewModel(source: CoreDataHelper.shared)
    private let customAlertView = AddNewItemAlertView()
    private var observers: [AnyCancellable] = []

    let todoTableview: UITableView = {
        let tmp = UITableView()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        return tmp
    }()

    let counter: UILabel = {
        let tmp = UILabel()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.text = "Total Note Count: 0"
        tmp.textAlignment = .center
        tmp.textColor = UIColor.systemRed
        tmp.backgroundColor = .lightGray
        tmp.layer.bounds.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        tmp.font = UIFont.boldSystemFont(ofSize: 15)
        return tmp
    }()

    let addItemButton: UIButton = {
        let tmp = UIButton()
        let addImage = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        tmp.setImage(addImage, for: .normal)
        tmp.setTitle("Add", for: .normal)
        tmp.accessibilityIdentifier = "AddBtn"
        var configuration = UIButton.Configuration.plain()
        configuration.baseBackgroundColor = .systemBlue
        tmp.configuration = configuration
        return tmp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setObservers()
        setupUI()
        setBindings()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        observers.forEach({ $0.cancel() })
    }
}

//MARK: - settings
extension MainViewController {
    private func setupUI() {
        self.view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addItemButton)
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.title = "Secure To-Do List App"

        self.view.addSubview(counter)
        self.view.addSubview(todoTableview)

        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.counter.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.counter.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.counter.topAnchor.constraint(equalTo: safeArea.topAnchor),

            self.todoTableview.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.todoTableview.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.todoTableview.topAnchor.constraint(equalTo: counter.bottomAnchor),
            self.todoTableview.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }

    private func setBindings() {
        self.todoTableview.delegate = self
        self.viewModel.defineDiffDataSource(todoTableview)
        customAlertView.delegate = self
        self.addItemButton.addTarget(self, action: #selector(addItemTapped), for: .touchUpInside)
    }

    private func setObservers() {
        self.viewModel.action.sink { [weak self] count in
            guard let strongSelf = self else { return }
            strongSelf.counter.text = "Total Note Count: \(count)"
        }.store(in: &observers)
    }
}


//MARK: - TableviewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = self.viewModel.getToDoItemsArrayItem(with: indexPath.row) else { return }
        let vm = DetailViewModel(item: item)
        let vc = DetailViewController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: -AddNewItemAlertViewProtocol
extension MainViewController: AddNewItemAlertViewProtocol {
    func addNewItem(title: String, detail: String) {
        viewModel.addItem(title: title, detail: detail)
        customAlertView.dismiss(animated: true)
    }
}

//MARK: - objc functions
@objc
extension MainViewController {
    func addItemTapped() {
        showAlert()
    }
}

//MARK: - functions
extension MainViewController {
    private func showAlert() {
        customAlertView.providesPresentationContextTransitionStyle = true
        customAlertView.definesPresentationContext = true
        customAlertView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlertView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(customAlertView, animated: true, completion: nil)
    }
}

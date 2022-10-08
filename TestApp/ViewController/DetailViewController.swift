//
//  DetailViewController.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 7.10.2022.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private var viewModel: DetailViewModel?
    
    let titleLbl: UILabel = {
       let tmp = UILabel()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.font = UIFont.boldSystemFont(ofSize: 16)
        tmp.textAlignment = .center
        return tmp
    }()
    
    let detailLbl: UITextView = {
       let tmp = UITextView()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.font = UIFont.systemFont(ofSize: 14)
        tmp.isEditable = false
        return tmp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setBindings()
    }
    
    public init(viewModel: DetailViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension DetailViewController {
    private func setupUI() {
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.view.backgroundColor = .white
        self.view.addSubview(titleLbl)
        self.view.addSubview(detailLbl)
        
        if let title = viewModel?.getItemDetail()?.title,
           let detail = viewModel?.getItemDetail()?.detail {
            titleLbl.text = title
            detailLbl.text = detail
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10.0),
            titleLbl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
            titleLbl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
            
            detailLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 10.0),
            detailLbl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
            detailLbl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
            detailLbl.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    private func setBindings() {
        
    }
}

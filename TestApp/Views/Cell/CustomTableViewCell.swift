//
//  CustomTableViewCell.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 6.10.2022.
//

import UIKit

final class CustomTableViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"
    
    let titleLbl: UILabel = {
       let tmp = UILabel()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.font = UIFont.boldSystemFont(ofSize: 16)
        return tmp
    }()
    
    let detailLbl: UILabel = {
       let tmp = UILabel()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.font = UIFont.systemFont(ofSize: 14)
        return tmp
    }()
    
    let chevronImg: UIImageView = {
       let tmp = UIImageView()
        tmp.translatesAutoresizingMaskIntoConstraints = false
        let chevronImage = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        tmp.contentMode = .scaleAspectFit
        tmp.image = chevronImage
        tmp.tintColor = .black
        return tmp
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - settings
extension CustomTableViewCell {
    private func setupUI() {
        selectionStyle = .none
        
        addSubview(titleLbl)
        addSubview(detailLbl)
        addSubview(chevronImg)
        
        NSLayoutConstraint.activate([
            titleLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            titleLbl.topAnchor.constraint(equalTo: topAnchor, constant: 5.0),
            titleLbl.trailingAnchor.constraint(equalTo: chevronImg.leadingAnchor, constant: 10.0),
            
            detailLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            detailLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 5.0),
            detailLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0),
            detailLbl.trailingAnchor.constraint(equalTo: chevronImg.leadingAnchor, constant: 10.0),
            
            chevronImg.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
            chevronImg.heightAnchor.constraint(equalToConstant: 20.0),
            chevronImg.widthAnchor.constraint(equalToConstant: 20.0),
            chevronImg.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

//MARK: - functions
extension CustomTableViewCell {
    public func configure(title: String, detail: String){
        self.titleLbl.text = title
        self.detailLbl.text = detail
    }
}

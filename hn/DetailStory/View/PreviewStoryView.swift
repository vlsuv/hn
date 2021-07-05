//
//  PreviewStoryView.swift
//  hn
//
//  Created by vlsuv on 01.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PreviewStoryView: UIView {
    
    // MARK: - Properties
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AssetsColors.background
        
        configureTitleLabel()
        configureAuthorLabel()
        configureTextLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ viewModel: PreviewStoryViewModelProtocol) {
        titleLabel.text = viewModel.title
        authorLabel.text = "by \(viewModel.author) \(viewModel.time) ago"
        
        if let text = viewModel.text {
            textLabel.isHidden = false
            textLabel.text = text
        }
    }
    
    // MARK: - Element Setups
    private func configureTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
    }
    
    private func configureAuthorLabel() {
        self.addSubview(authorLabel)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        authorLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        authorLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
    }
    
    private func configureTextLabel() {
        self.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8).isActive = true
        textLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        textLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
    }
}

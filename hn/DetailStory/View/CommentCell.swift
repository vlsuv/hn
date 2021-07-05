//
//  CommentCell.swift
//  hn
//
//  Created by vlsuv on 01.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    // MARK: - Properties
    static var identifier: String = "CommentCell"
    
    private var commentViewContent: UIView = {
        let view = UIView()
        return view
    }()
    
    private var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 10)
        label.textColor = Color.mediumGray
        return label
    }()
    
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = .systemFont(ofSize: 10)
        label.textColor = AssetsColors.text
        return label
    }()
    
    
    var level: Int = 1
    var indentationUnit: CGFloat {
        return CGFloat(level * 18)
    }
    
    func configure(_ viewModel: DetailStoryCellViewModelType) {
        authorLabel.text = "\(viewModel.author) \(viewModel.time)"
        messageLabel.text = viewModel.text
        level = viewModel.level
        
        configureView()
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = AssetsColors.background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    func configureView() {
        configureCommentViewContent()
        configureAuthorLabel()
        configureMessageLabel()
        
        separatorInset.left = indentationUnit
    }
    
    private func configureCommentViewContent() {
        contentView.addSubview(commentViewContent)
        commentViewContent.translatesAutoresizingMaskIntoConstraints = false
        commentViewContent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        commentViewContent.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: indentationUnit).isActive = true
        commentViewContent.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -18).isActive = true
        commentViewContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    private func configureAuthorLabel() {
        commentViewContent.addSubview(authorLabel)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.topAnchor.constraint(equalTo: commentViewContent.topAnchor).isActive = true
        authorLabel.leftAnchor.constraint(equalTo: commentViewContent.leftAnchor).isActive = true
        authorLabel.rightAnchor.constraint(equalTo: commentViewContent.rightAnchor).isActive = true
    }
    
    private func configureMessageLabel() {
        commentViewContent.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: commentViewContent.leftAnchor).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: commentViewContent.rightAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: commentViewContent.bottomAnchor).isActive = true
    }
}

//
//  DetailStoryCellViewModel.swift
//  hn
//
//  Created by vlsuv on 01.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol DetailStoryCellViewModelType {
    var text: String? { get }
    var author: String { get }
    var level: Int { get }
    var time: String { get }
}

class DetailStoryCellViewModel: DetailStoryCellViewModelType {
    
    // MARK: - Properties
    private let comment: Comment
    
    var text: String? {
        guard let text = comment.text, let attributedString = attributedString(withHtmlText: text) else { return nil }
        
        return attributedString.string
    }
    
    var author: String {
        return comment.by ?? "??"
    }
    
    var level: Int {
        return comment.level
    }
    
    var time: String {
        return "\(comment.time.passedTime()) ago"
    }
    
    // MARK: - Init
    init(comment: Comment) {
        self.comment = comment
    }
    
    private func attributedString(withHtmlText htmlText: String) -> NSAttributedString? {
        let data = Data(htmlText.utf8)
        
        guard let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else { return nil }
        
        return attributedString
    }
}

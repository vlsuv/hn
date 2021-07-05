//
//  PreviewStoryViewModel.swift
//  hn
//
//  Created by vlsuv on 01.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol PreviewStoryViewModelProtocol {
    var title: String { get }
    var author: String { get }
    var text: String? { get }
    var time: String { get }
}

class PreviewStoryViewModel: PreviewStoryViewModelProtocol {
    
    // MARK: - Properties
    private let story: Story
    
    var title: String {
        return story.title
    }
    
    var author: String {
        return story.by
    }
    
    var text: String? {
        guard let text = story.text, let attributedString = attributedString(withHtmlText: text) else { return nil }
        
        return attributedString.string
        
    }
    
    var time: String {
        return story.time.passedTime()
    }
    
    // MARK: - Init
    init(for story: Story) {
        self.story = story
    }
    
    private func attributedString(withHtmlText htmlText: String) -> NSAttributedString? {
        let data = Data(htmlText.utf8)
        
        guard let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else { return nil }
        
        return attributedString
    }
}

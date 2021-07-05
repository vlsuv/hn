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
    var score: String { get }
    var urlHost: String? { get }
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
        guard let text = story.text, let attributedString = text.getAttributedString() else { return nil }
        
        return attributedString.string
    }
    
    var time: String {
        return story.time.passedTime()
    }
    
    var score: String {
        return "\(story.score) points"
    }
    
    var urlHost: String? {
        guard let urlString = story.url, let url = URL(string: urlString), let host = url.host else { return nil }
        
        return host
    }
    
    // MARK: - Init
    init(for story: Story) {
        self.story = story
    }
}

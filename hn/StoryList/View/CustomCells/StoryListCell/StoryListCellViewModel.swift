//
//  StoryListCellViewModel.swift
//  hn
//
//  Created by vlsuv on 29.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol StoryListCellViewModelType {
    var title: String { get }
    var urlHost: String { get }
    var score: String { get }
    var time: String { get }
}

class StoryListCellViewModel: StoryListCellViewModelType {
    
    // MARK: - Properties
    private let story: Story
    
    var title: String {
        return story.title
    }
    
    var urlHost: String {
        guard let urlString = story.url, let url = URL(string: urlString) else { return "show detail" }
        
        return url.host ?? "show detail"
    }
    
    var score: String {
        return "\(story.score)"
    }
    
    var time: String {
        return story.time.passedTime()
    }
    
    // MARK: - Init
    init(story: Story) {
        self.story = story
    }
}

//
//  DetailStoryViewModel.swift
//  hn
//
//  Created by vlsuv on 18.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol DetailStoryViewModelType {
    var text: String? { get }
    var request: URLRequest? { get }
}

class DetailStoryViewModel: DetailStoryViewModelType {
    
    // MARK: - Properties
    private let coordinator: DetailStoryCoordinator
    
    private var story: Story
    
    var text: String? {
        return story.text
    }
    
    var request: URLRequest? {
        guard let stringURL = story.url, let url = URL(string: stringURL) else { return nil }
        
        return URLRequest(url: url)
    }
    
    // MARK: - Init
    init(coordinator: DetailStoryCoordinator, story: Story) {
        self.coordinator = coordinator
        self.story = story
    }
}

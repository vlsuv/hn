//
//  DetailStoryViewModel.swift
//  hn
//
//  Created by vlsuv on 18.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol DetailStoryViewModelInputs {
}

protocol DetailStoryViewModelOutputs {
    var htmlText: String? { get }
}

protocol DetailStoryViewModelType {
    var inputs: DetailStoryViewModelInputs { get }
    var outputs: DetailStoryViewModelOutputs { get }
}

class DetailStoryViewModel: DetailStoryViewModelType, DetailStoryViewModelInputs, DetailStoryViewModelOutputs {
    
    // MARK: - Properties
    var inputs: DetailStoryViewModelInputs { return self }
    var outputs: DetailStoryViewModelOutputs { return self }
    
    private let coordinator: DetailStoryCoordinator
    
    private var story: Story
    
    var htmlText: String? {
        guard let text = story.text else { return nil }
        
        return text
    }
    
    // MARK: - Init
    init(coordinator: DetailStoryCoordinator, story: Story) {
        self.coordinator = coordinator
        self.story = story
    }
}

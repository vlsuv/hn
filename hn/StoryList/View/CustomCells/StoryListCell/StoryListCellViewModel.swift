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
    var urlHost: String? { get }
    var score: String { get }
    var time: String { get }
}

class StoryListCellViewModel: StoryListCellViewModelType {
    
    // MARK: - Properties
    private let story: Story
    
    var title: String {
        return story.title
    }
    
    var urlHost: String? {
        guard let urlString = story.url, let url = URL(string: urlString) else { return nil }
        
        return url.host
    }
    
    var score: String {
        return "\(story.score)"
    }
    
    var time: String {
        let date = Date(timeIntervalSince1970: story.time)
        
        let interval = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date, to: Date())
        
        if let day = interval.day, day > 0 {
            return "\(day)d"
        } else if let hour = interval.hour, hour > 0 {
            return "\(hour)h"
        } else if let minute = interval.minute, minute > 0 {
            return "\(minute)m"
        } else if let second = interval.second {
            return "\(second)s"
        } else {
            return "s"
        }
    }
    
    // MARK: - Init
    init(story: Story) {
        self.story = story
    }
}

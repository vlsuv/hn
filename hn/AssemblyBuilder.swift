//
//  AssemblyBuilder.swift
//  hn
//
//  Created by vlsuv on 26.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import SafariServices

protocol AssemblyBuilderProtocol {
    func createStoryListController(coordinator: StoryListCoordinator) -> UIViewController
    func createDetailStoryController(coordinator: DetailStoryCoordinator, story: Story) -> UIViewController
    func createSafariController(with url: URL) -> SFSafariViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createStoryListController(coordinator: StoryListCoordinator) -> UIViewController {
        let storyListViewModel = StoryListViewModel(coordinator: coordinator, storiesNetworkService: StoriesNetworkService())
        
        let storyListController = StoryListController()
        storyListController.viewModel = storyListViewModel
        
        return storyListController
    }
    
    func createDetailStoryController(coordinator: DetailStoryCoordinator, story: Story) -> UIViewController {
        let detailStoryViewModel = DetailStoryViewModel(coordinator: coordinator, story: story, storiesNetworkService: StoriesNetworkService())
        
        let detailStoryController = CommentsViewController()
        detailStoryController.viewModel = detailStoryViewModel
        
        return detailStoryController
    }
    
    func createSafariController(with url: URL) -> SFSafariViewController {
        let safariController = SFSafariViewController(url: url)
        return safariController
    }
}

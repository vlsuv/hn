//
//  StoryListCoordinator.swift
//  hn
//
//  Created by vlsuv on 26.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class StoryListCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = [Coordinator]()
    
    var parentCoordinator: Coordinator?
    
    private let navigationController: UINavigationController
    
    private let assemblyBuilder: AssemblyBuilderProtocol
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        self.assemblyBuilder = AssemblyBuilder()
    }
    
    // MARK: - Handlers
    func start() {
        let storyListController = assemblyBuilder.createStoryListController(coordinator: self)
        
        navigationController.viewControllers = [storyListController]
    }
    
    func showDetailStory(for story: Story) {
        let detailStoryCoordinator = DetailStoryCoordinator(navigationController: navigationController, story: story)
        detailStoryCoordinator.start()
        detailStoryCoordinator.parentCoordinator = self
        childCoordinators.append(detailStoryCoordinator)
    }
}

extension StoryListCoordinator {
    func childDidFinish(_ childCoordinator: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) else { return }
        childCoordinators.remove(at: index)
    }
}

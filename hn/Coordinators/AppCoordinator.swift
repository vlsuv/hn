//
//  AppCoordinator.swift
//  hn
//
//  Created by vlsuv on 26.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = [Coordinator]()
    
    private let window: UIWindow
    
    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Handlers
    func start() {
        let navigationController = UINavigationController()
        
        let storyListCoordinator = StoryListCoordinator(navigationController: navigationController)
        storyListCoordinator.start()
        storyListCoordinator.parentCoordinator = self
        childCoordinators.append(storyListCoordinator)
        
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) else { return }
        childCoordinators.remove(at: index)
    }
}

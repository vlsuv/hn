//
//  DetailStoryCoordinator.swift
//  hn
//
//  Created by vlsuv on 26.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class DetailStoryCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = [Coordinator]()
    
    var parentCoordinator: Coordinator?
    
    private let navigationController: UINavigationController
    
    private let assemblyBuilder: AssemblyBuilderProtocol
    
    private let story: Story
    
    // MARK: - Init
    init(navigationController: UINavigationController, story: Story) {
        self.navigationController = navigationController
        
        self.story = story
        
        self.assemblyBuilder = AssemblyBuilder()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Handlers
    func start() {
        let detailStoryController = assemblyBuilder.createDetailStoryController(coordinator: self, story: story)
        
        navigationController.pushViewController(detailStoryController, animated: true)
    }
    
    func viewDidDisappear() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func showSafari(with url: URL) {
        let safariCoordinator = SFSafariCoordinator(navigationController: navigationController, url: url)
        safariCoordinator.start()
        safariCoordinator.parentCoordinator = self
        childCoordinators.append(safariCoordinator)
    }
}

extension DetailStoryCoordinator {
    func childDidFinish(_ childCoordinator: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) else { return }
        childCoordinators.remove(at: index)
    }
}

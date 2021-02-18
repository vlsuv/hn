//
//  Router.swift
//  hn
//
//  Created by vlsuv on 15.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol BaseRouterProtocol {
    var navigationController: UINavigationController? { get }
    var assemblyBuilder: AssemblyModuleBuilderProtocol? { get }
}

protocol RouterProtocol: BaseRouterProtocol {
    func initialViewController()
    func showDetail(withStory story: Story?)
}

final class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyModuleBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        guard let navigationController = navigationController else { return }
        if let storyListViewController = assemblyBuilder?.createStoryListViewController(router: self) {
            navigationController.viewControllers = [storyListViewController]
        }
    }
    
    func showDetail(withStory story: Story?) {
        guard let navigationController = navigationController else { return }
        if let detailStoryViewController = assemblyBuilder?.createDetailStoryViewController(router: self, story: story) {
            navigationController.pushViewController(detailStoryViewController, animated: true)
        }
    }
}

//
//  AssemblyModuleBuilder.swift
//  hn
//
//  Created by vlsuv on 15.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol AssemblyModuleBuilderProtocol {
    func createStoryListViewController(router: RouterProtocol) -> UIViewController
    func createDetailStoryViewController(router: RouterProtocol, story: Story) -> UIViewController
}

final class AssemblyModuleBuilder: AssemblyModuleBuilderProtocol {
    func createStoryListViewController(router: RouterProtocol) -> UIViewController {
        let view = StoryListViewController()
        let storiesNetworkService = StoriesNetworkService()
        let presenter = StoryListViewPresenter(view: view, router: router, storiesNetworkService: storiesNetworkService)
        view.presenter = presenter
        return view
    }
    
    func createDetailStoryViewController(router: RouterProtocol, story: Story) -> UIViewController {
        let view = DetailStoryViewController()
        let presenter = DetailStoryViewPresenter(view: view, router: router, story: story)
        view.presenter = presenter
        return view
    }
}

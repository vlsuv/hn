//
//  RouterTest.swift
//  hnTests
//
//  Created by vlsuv on 18.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import XCTest
@testable import hn

class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

class RouterTest: XCTestCase {
    
    var navigationController: MockNavigationController!
    var router: RouterProtocol!
    var assemblyModuleBuilder: AssemblyModuleBuilderProtocol!

    override func setUpWithError() throws {
        navigationController = MockNavigationController()
        assemblyModuleBuilder = AssemblyModuleBuilder()
    }

    override func tearDownWithError() throws {
        router = nil
    }
    
    func testInitialViewController() {
        router = Router(navigationController: navigationController, assemblyBuilder: assemblyModuleBuilder)
        router.initialViewController()
        
        XCTAssertTrue(navigationController.viewControllers[0] is StoryListController)
    }
    
    func testShowStoryDetailViewController() {
        router = Router(navigationController: navigationController, assemblyBuilder: assemblyModuleBuilder)
        router.showDetail(withStory: nil)
        
        XCTAssertTrue(navigationController.presentedVC is DetailStoryController)
    }
}

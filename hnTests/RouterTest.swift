//
//  RouterTest.swift
//  hnTests
//
//  Created by vlsuv on 18.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import XCTest
@testable import hn

class RouterTest: XCTestCase {
    
    var router: RouterProtocol!

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        router = nil
    }
    
    func testInitialViewController() {
        let navigationController = UINavigationController()
        let assemblyModuleBuilder = AssemblyModuleBuilder()
        router = Router(navigationController: navigationController, assemblyBuilder: assemblyModuleBuilder)
        router.initialViewController()
        
        XCTAssertTrue(navigationController.viewControllers[0] is StoryListViewController)
    }
}

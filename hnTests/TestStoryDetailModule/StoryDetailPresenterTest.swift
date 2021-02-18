//
//  StoryDetailPresenterTest.swift
//  hnTests
//
//  Created by vlsuv on 18.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import XCTest
@testable import hn

protocol MockViewProtocol: DetailStoryViewProtocol {
    var request: URLRequest? { get set }
    var presenter: DetailStoryViewPresenterProtocol! { get set }
}

class MockView: MockViewProtocol {
    var request: URLRequest?
    var presenter: DetailStoryViewPresenterProtocol!
    
    func loadWebView(request: URLRequest) {
        self.request = request
    }
}

class StoryDetailPresenterTest: XCTestCase {
    
    var view: MockViewProtocol!
    var presenter: DetailStoryViewPresenter!
    var router: RouterProtocol!

    override func setUpWithError() throws {
        let navigationController = UINavigationController()
        let assemblyModuleBuilder = AssemblyModuleBuilder()
        
        view = MockView()
        router = Router(navigationController: navigationController, assemblyBuilder: assemblyModuleBuilder)
    }

    override func tearDownWithError() throws {
        view = nil
        presenter = nil
        router = nil
    }
    
    func testLoadWebView() {
        presenter = DetailStoryViewPresenter(view: view, router: router, story: Story(by: "baz", descendants: nil, id: 0, kids: nil, score: 0, time: 0, title: "baz", type: "baz", url: "https://xxx.xxxxxx.xxx"))
        view.presenter = presenter
        presenter.loadWebView()
        
        XCTAssertNotNil(view.request)
    }
}

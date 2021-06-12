//
//  StoryListViewTest.swift
//  hnTests
//
//  Created by vlsuv on 18.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import XCTest
@testable import hn

class MockStoryListView: StoryListViewProtocol {
    func Succes() {
    }
    
    func Failure(withError error: Error) {
    }
}

class MockStoriesNetworkService: StoriesNetworkServiceProtocol {
    var sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    var stories: [Story]?
    
    required init(sessionConfiguration: URLSessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    convenience init(stories: [Story]?) {
        self.init(sessionConfiguration: URLSessionConfiguration.default)
        self.stories = stories
    }
    
    func fetchStories(withEndpoint endpoint: Endpoint, length: Int, completionHandler: @escaping (NetworkServiceResult<[Story]>) -> ()) {
        if let stories = stories {
            completionHandler(.Succes(stories))
        }else {
            let error = NSError(domain: "Stories are nil", code: 0, userInfo: nil)
            completionHandler(.Failure(error))
        }
    }
}

class StoryListViewTest: XCTestCase {
    
    var view: StoryListViewProtocol!
    var storiesNetworkService: StoriesNetworkServiceProtocol!
    var router: RouterProtocol!

    override func setUpWithError() throws {
        view = MockStoryListView()
        let navigationController = UINavigationController()
        let assemblyModuleBuilder = AssemblyModuleBuilder()
        router = Router(navigationController: navigationController, assemblyBuilder: assemblyModuleBuilder)
    }

    override func tearDownWithError() throws {
        view = nil
        storiesNetworkService = nil
        router = nil
    }
    
    func testGetSuccesData() {
        storiesNetworkService = MockStoriesNetworkService(stories: [Story(by: "baz", descendants: nil, id: 0, kids: nil, score: 0, time: 0, title: "baz", type: "baz", url: "baz", text: nil)])
        
        var catchStories: [Story]?
        
        storiesNetworkService.fetchStories(withEndpoint: .topstories, length: 10) { networkServiceResult in
            switch networkServiceResult {
            case .Succes(let result):
                catchStories = result
            case .Failure(_):
                break
            }
        }
        
        XCTAssertNotNil(catchStories)
    }
    
    func testGetErrorData() {
        storiesNetworkService = MockStoriesNetworkService(stories: nil)
        
        var catchError: Error?
        storiesNetworkService.fetchStories(withEndpoint: .topstories, length: 10) { networkServiceResult in
            switch networkServiceResult {
            case .Succes(_):
                break
            case .Failure(let error):
                catchError = error
            }
        }
        
        XCTAssertNotNil(catchError)
    }
}

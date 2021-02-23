//
//  StoriesNetworkService.swift
//  hn
//
//  Created by vlsuv on 15.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol StoriesNetworkServiceProtocol: NetworkServiceProtocol {
    init(sessionConfiguration: URLSessionConfiguration)
    func fetchStories(withEndpoint endpoint: Endpoint, length: Int, completionHandler: @escaping (NetworkServiceResult<[Story]>) -> ())
}

enum Endpoint {
    static let baseURL: URL = URL(string: "https://hacker-news.firebaseio.com/v0/")!
    
    case topstories
    case newstories
    case showstories
    case story(Int)
    
    var request: URLRequest {
        switch self {
        case .topstories:
            let url = Endpoint.baseURL.appendingPathComponent("topstories.json")
            return URLRequest(url: url)
        case .newstories:
            let url = Endpoint.baseURL.appendingPathComponent("newstories.json")
            return URLRequest(url: url)
        case .showstories:
            let url = Endpoint.baseURL.appendingPathComponent("showstories.json")
            return URLRequest(url: url)
        case .story(let id):
            let url = Endpoint.baseURL.appendingPathComponent("item/\(id).json")
            return URLRequest(url: url)
        }
    }
    
    init?(index: Int) {
        switch index {
        case 0: self = .topstories
        case 1: self = .newstories
        case 2: self = .showstories
        default: return nil
        }
    }
}

final class StoriesNetworkService: StoriesNetworkServiceProtocol {
    var sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    
    init(sessionConfiguration: URLSessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    convenience init() {
        self.init(sessionConfiguration: URLSessionConfiguration.default)
    }
    
    func fetchStoryIDs(from endpoint: Endpoint, length: Int, completionHandler: @escaping ([Int]?, Error?) -> ()) {
        fetch(request: endpoint.request, parse: { (data) -> ([Int])? in
            if let storyIDs = try? JSONDecoder().decode([Int].self, from: data) {
                return storyIDs
            }else {
                return nil
            }
        }) { (networkServiceResult) in
            switch networkServiceResult {
            case .Succes(let storyIDs):
                let storyIDs = Array(storyIDs.prefix(length))
                completionHandler(storyIDs, nil)
            case .Failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func fetchStoriesArticle(id: Int, completionHandler: @escaping (Story?, Error?) -> ()) {
        let request = Endpoint.story(id).request
        
        fetch(request: request, parse: { (data) -> (Story)? in
            if let story = try? JSONDecoder().decode(Story.self, from: data) {
                return story
            }else {
                return nil
            }
        }) { (networkServiceResult) in
            switch networkServiceResult {
            case .Succes(let story):
                completionHandler(story, nil)
            case .Failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func fetchStories(withEndpoint endpoint: Endpoint, length: Int, completionHandler: @escaping (NetworkServiceResult<[Story]>) -> ()) {
        fetchStoryIDs(from: endpoint, length: length) { (storyIDs, error) in
            guard let storyIDs = storyIDs else {
                if let error = error {
                    completionHandler(.Failure(error))
                }
                return
            }
            
            var stories: [Story] = [Story]()
            let queue = DispatchQueue(label: "StoriesQueue", attributes: .concurrent)
            let group = DispatchGroup()
            
            storyIDs.forEach {
                group.enter()
                self.fetchStoriesArticle(id: $0) { (story, error) in
                    queue.async(flags: .barrier) {
                        guard let story = story else {
                            if let error = error {
                                print(error)
                            }
                            group.leave()
                            return
                        }
                        stories.append(story)
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: queue) {
                completionHandler(.Succes(stories))
            }
        }
    }
}

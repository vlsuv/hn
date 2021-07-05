//
//  StoriesNetworkService.swift
//  hn
//
//  Created by vlsuv on 15.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

enum Endpoint {
    static let baseURL: URL = URL(string: "https://hacker-news.firebaseio.com/v0/")!
    
    case topstories
    case newstories
    case showstories
    case story(Int)
    
    case comment(commentId: Int)
    
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
        case .comment(commentId: let commentId):
            let url = Endpoint.baseURL.appendingPathComponent("item/\(commentId).json")
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

protocol StoriesNetworkServiceProtocol: NetworkServiceProtocol {
    func stories(from endpoint: Endpoint) -> Observable<[Story]>
    func nextStories() -> Observable<[Story]>
    func comments(ids: [Int]) -> Observable<[Comment]>
}

class StoriesNetworkService: StoriesNetworkServiceProtocol {
    
    private var maxLength: Int = 20
    
    private var loadIDs: [Int] = [Int]()
    
    // MARK: - Stories
    func stories(from endpoint: Endpoint) -> Observable<[Story]> {
        return storyIDs(from: endpoint)
            .do(onNext: {
                self.maxLength = 20
                self.loadIDs = $0
            })
            .map { $0.prefix(self.maxLength) }
            .flatMap { Observable.from($0) }
            .flatMap { self.story(id: $0) }
            .toArray()
            .catchAndReturn( [Story]() )
            .filter { !$0.isEmpty }
            .asObservable()
    }
    
    func nextStories() -> Observable<[Story]> {
        let ids = Array(loadIDs[maxLength..<maxLength + 20])
        
        let observable = Observable.of(ids)
            .do(onNext: { _ in self.maxLength += 20 })
            .flatMap { Observable.from($0) }
            .flatMap { self.story(id: $0) }
            .toArray()
            .catchAndReturn([Story]())
            .filter { !$0.isEmpty }
            .asObservable()
        
        return observable
    }
    
    private func storyIDs(from endpoint: Endpoint) -> Observable<[Int]> {
        return fetch(endpoint.request)
    }
    
    private func story(id: Int) -> Observable<Story> {
        return fetch(Endpoint.story(id).request)
    }
    
    // MARK: - Comment
    func comments(ids: [Int]) -> Observable<[Comment]> {
        return Observable.from(ids)
            .flatMap { self.fetch(Endpoint.comment(commentId: $0).request) }
            .toArray()
            .asObservable()
    }
}

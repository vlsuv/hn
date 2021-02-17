//
//  StoryListPresenter.swift
//  hn
//
//  Created by vlsuv on 15.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol StoryListViewProtocol: class {
    func Succes()
    func Failure(withError error: Error)
}

protocol StoryListViewPresenterProtocol: class {
    init(view: StoryListViewProtocol, router: RouterProtocol, storiesNetworkService: StoriesNetworkServiceProtocol)
    var stories: [Story]? { get set }
    func fetchStories()
}

class StoryListViewPresenter: StoryListViewPresenterProtocol {
    
    weak var view: StoryListViewProtocol?
    var router: RouterProtocol!
    let storiesNetworkService: StoriesNetworkServiceProtocol!
    var stories: [Story]?
    
    required init(view: StoryListViewProtocol, router: RouterProtocol, storiesNetworkService: StoriesNetworkServiceProtocol) {
        self.view = view
        self.storiesNetworkService = storiesNetworkService
        self.router = router
    }
    
    func fetchStories() {
        storiesNetworkService?.fetchStories(withEndpoint: .topstories) { [weak self] networkServiceResult in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch networkServiceResult {
                case .Succes(let storyIDs):
                    self.stories = storyIDs
                    self.view?.Succes()
                case .Failure(let error):
                    self.view?.Failure(withError: error)
                }
            }
        }
    }
}

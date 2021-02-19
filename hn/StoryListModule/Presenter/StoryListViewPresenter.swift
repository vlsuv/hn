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
    func showDetail(withStory story: Story)
    var isLoading: Bool { get set }
    var storiesSegmentedIndex: Int { get set }
    func setStoriesSegmentedIndex(index: Int)
}

class StoryListViewPresenter: StoryListViewPresenterProtocol {
    
    weak var view: StoryListViewProtocol?
    var router: RouterProtocol!
    let storiesNetworkService: StoriesNetworkServiceProtocol!
    var stories: [Story]?
    var isLoading: Bool = false
    var storiesSegmentedIndex: Int = 0
    
    required init(view: StoryListViewProtocol, router: RouterProtocol, storiesNetworkService: StoriesNetworkServiceProtocol) {
        self.view = view
        self.storiesNetworkService = storiesNetworkService
        self.router = router
    }
    
    func fetchStories() {
        guard let endpoint = Endpoint(index: self.storiesSegmentedIndex) else {
            view?.Failure(withError: ErrorManager.StorySegmentError)
            return
        }
        isLoading = true
        
        storiesNetworkService?.fetchStories(withEndpoint: endpoint, length: (stories?.count ?? 0) + 20) { [weak self] networkServiceResult in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch networkServiceResult {
                case .Succes(let storyIDs):
                    self.stories = storyIDs
                    self.view?.Succes()
                case .Failure(let error):
                    self.view?.Failure(withError: error)
                }
                self.isLoading = false
            }
        }
    }
    
    func showDetail(withStory story: Story) {
        router.showDetail(withStory: story)
    }
    
    func setStoriesSegmentedIndex(index: Int) {
        self.storiesSegmentedIndex = index
        self.stories = nil
        self.fetchStories()
    }
}

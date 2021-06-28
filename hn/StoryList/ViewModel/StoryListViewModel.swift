//
//  StoryListViewModel.swift
//  hn
//
//  Created by vlsuv on 15.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol StoryListViewModelInputs {
    func didTapShowDetail(at indexPath: IndexPath)
    func didTapRefreshStories()
    func didTapChangeTheme()
    func nextData()
}

protocol StoryListViewModelOutputs {
    var stories: BehaviorRelay<[Story]> { get }
    var indexEndpoint: BehaviorRelay<Int> { get }
    var isLoading: BehaviorRelay<Bool> { get }
}

protocol StoryListViewModelProtocol: class {
    var inputs: StoryListViewModelInputs { get }
    var outputs: StoryListViewModelOutputs { get }
}

class StoryListViewModel: StoryListViewModelProtocol, StoryListViewModelInputs, StoryListViewModelOutputs {
    
    // MARK: - Properties
    var inputs: StoryListViewModelInputs { return self }
    var outputs: StoryListViewModelOutputs { return self }
    
    weak var coordinator: StoryListCoordinator?
    
    private let storiesNetworkService: StoriesNetworkServiceProtocol
    
    private let disposeBag: DisposeBag
    
    var stories: BehaviorRelay<[Story]> = .init(value: [Story]())
    
    var indexEndpoint: BehaviorRelay<Int> = .init(value: 0)
    
    var refreshTrigger: BehaviorRelay<()> = .init(value: ())
    
    var isLoading: BehaviorRelay<Bool> = .init(value: false)
    
    // MARK: - Init
    init(coordinator: StoryListCoordinator, storiesNetworkService: StoriesNetworkServiceProtocol) {
        self.coordinator = coordinator
        
        self.storiesNetworkService = storiesNetworkService
        
        self.disposeBag = DisposeBag()
        
        getData()
    }
    
    // MARK: - Data Manage
    private func getData() {
        Observable.combineLatest(indexEndpoint, refreshTrigger)
            .observe(on: MainScheduler.asyncInstance)
            .do(onNext: { _ in self.stories.accept([Story]()) })
            .flatMap { index, _ -> Observable<[Story]> in
                self.isLoading.accept(true)
                
                return self.storiesNetworkService.stories(from: Endpoint.init(index: index)!)
        }
        .subscribe(onNext: { stories in
            self.stories.accept(stories)
            
            self.isLoading.accept(false)
        })
            .disposed(by: disposeBag)
    }
    
    func nextData() {
        storiesNetworkService.nextStories()
            .observe(on: MainScheduler.asyncInstance)
            .do(onNext: { _ in
                self.isLoading.accept(true)
            })
            .subscribe(onNext: { stories in
                self.stories.accept(self.stories.value + stories)
                
                self.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Inputs Handlers
    func didTapShowDetail(at indexPath: IndexPath) {
        let story = stories.value[indexPath.row]
        
        if let _ = story.text {
            coordinator?.showDetailStory(for: story)
        } else if let stringURL = story.url, let url = URL(string: stringURL) {
            coordinator?.showSafari(with: url)
        }
    }
    
    func didTapRefreshStories() {
        refreshTrigger.accept(())
    }
    
    func didTapChangeTheme() {
        UserSettings.darkMode = !UserSettings.darkMode
        
        UIApplication.shared.windows.forEach{ window in
            window.overrideUserInterfaceStyle = UserSettings.darkMode ? .dark : .light
        }
    }
}

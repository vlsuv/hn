//
//  CommentsViewModel.swift
//  hn
//
//  Created by vlsuv on 01.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol DetailStoryViewModelInputs {
    func viewDidDisappear()
    func didTapPreviewStory()
}

protocol DetailStoryViewModelOutputs {
    func previewStoryViewModel() -> PreviewStoryViewModelProtocol
    var comments: BehaviorRelay<[Comment]> { get }
    func detailStoryCellViewModel(for item: Comment) -> DetailStoryCellViewModelType
    var isLoading: BehaviorRelay<Bool> { get }
}

protocol DetailStoryViewModelType {
    var inputs: DetailStoryViewModelInputs { get }
    var outputs: DetailStoryViewModelOutputs { get }
}

class DetailStoryViewModel: DetailStoryViewModelType, DetailStoryViewModelInputs, DetailStoryViewModelOutputs {
    
    // MARK: - Properties
    var inputs: DetailStoryViewModelInputs { return self }
    var outputs: DetailStoryViewModelOutputs { return self }
    
    private let coordinator: DetailStoryCoordinator
    
    private let storiesNetworkService: StoriesNetworkServiceProtocol
    
    var disposeBag: DisposeBag
    
    private let story: Story
    
    var comments: BehaviorRelay<[Comment]> = .init(value: [Comment]())
    
    var isLoading: BehaviorRelay<Bool> = .init(value: false)
    
    // MARK: - Init
    init(coordinator: DetailStoryCoordinator, story: Story, storiesNetworkService: StoriesNetworkServiceProtocol) {
        self.coordinator = coordinator
        self.story = story
        self.storiesNetworkService = storiesNetworkService
        self.disposeBag = DisposeBag()
        
        getComments()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Setups
    private func getComments() {
        guard let storiesIDs = story.kids else { return }
        
        storiesNetworkService
            .comments(ids: storiesIDs)
            .map({ (comments) -> [Comment] in
                self.isLoading.accept(true)
                
                return self.prepareCurrentComments(comments)
            })
            .subscribe(onNext: { comments in
                self.isLoading.accept(false)
                
                self.comments.accept(comments)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Outputs Handlers
    func previewStoryViewModel() -> PreviewStoryViewModelProtocol {
        return PreviewStoryViewModel(for: story)
    }
    
    func detailStoryCellViewModel(for item: Comment) -> DetailStoryCellViewModelType {
        return DetailStoryCellViewModel(comment: item)
    }
    
    // MARK: - Inputs Handlers
    func viewDidDisappear() {
        coordinator.viewDidDisappear()
    }
    
    func didTapPreviewStory() {
        guard let urlString = story.url, let url = URL(string: urlString) else { return }
        
        coordinator.showSafari(with: url)
    }
}

extension DetailStoryViewModel {
    func prepareComments(comments: [Comment], preparedComments: inout [Comment]) {
        let coms = comments

        for com in coms {
            preparedComments.append(com)
            prepareComments(comments: com.replies, preparedComments: &preparedComments)
        }
    }

    func prepareCurrentComments(_ coms: [Comment]) -> [Comment]{
        var preparedComs: [Comment] = [Comment]()
        
        prepareComments(comments: coms, preparedComments: &preparedComs)

        return preparedComs
    }
}

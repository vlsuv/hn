//
//  DetailStoryViewPresenter.swift
//  hn
//
//  Created by vlsuv on 18.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol DetailStoryViewProtocol: class {
    func loadWebView(request: URLRequest)
}

protocol DetailStoryViewPresenterProtocol {
    init(view: DetailStoryViewProtocol, router: RouterProtocol, story: Story)
    func loadWebView()
}

class DetailStoryViewPresenter: DetailStoryViewPresenterProtocol {
    weak var view: DetailStoryViewProtocol!
    var router: RouterProtocol!
    var story: Story?
    
    required init(view: DetailStoryViewProtocol, router: RouterProtocol, story: Story) {
        self.view = view
        self.router = router
        self.story = story
    }
    
    func loadWebView() {
        guard let story = story, let url = URL(string: story.url) else { return }
        let request = URLRequest(url: url)
        view.loadWebView(request: request)
    }
}

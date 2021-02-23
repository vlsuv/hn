//
//  DetailStoryViewPresenter.swift
//  hn
//
//  Created by vlsuv on 18.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol DetailStoryViewProtocol: class {
    func loadWebViewWithRequest(_ request: URLRequest)
    func loadWebViewWithText(_ text: String)
}

protocol DetailStoryViewPresenterProtocol {
    init(view: DetailStoryViewProtocol, router: RouterProtocol, story: Story?)
    func loadWebView()
}

class DetailStoryViewPresenter: DetailStoryViewPresenterProtocol {
    weak var view: DetailStoryViewProtocol!
    var router: RouterProtocol!
    var story: Story?
    
    required init(view: DetailStoryViewProtocol, router: RouterProtocol, story: Story?) {
        self.view = view
        self.router = router
        self.story = story
    }
    
    func loadWebView() {
        guard let story = story else { return }
        
        if let urlString = story.url, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            view.loadWebViewWithRequest(request)
        }else if let text = story.text {
            view.loadWebViewWithText(text)
        }
    }
}

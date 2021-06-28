//
//  DetailStoryController.swift
//  hn
//
//  Created by vlsuv on 18.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class DetailStoryController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: DetailStoryViewModelType?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.backgroundColor = .white
        
        configureWebView()
        configureActivityIndicator()
        
        loadWebView()
    }
    
    // MARK: - Setups
    private func configureWebView() {
        webView.navigationDelegate = self
    }
    
    private func configureActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
    }
    
    private func loadWebView() {
        guard let htmlText = viewModel?.outputs.htmlText else { return }
        
        webView.loadHTMLString(htmlText, baseURL: nil)
    }
}

// MARK: - WKNavigationDelegate
extension DetailStoryController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        activityIndicator.stopAnimating()
    }
}

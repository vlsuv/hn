//
//  DetailStoryViewController.swift
//  hn
//
//  Created by vlsuv on 18.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import WebKit

class DetailStoryViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var presenter: DetailStoryViewPresenterProtocol!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.backgroundColor = .white
        
        configureWebView()
        configureActivityIndicator()
        presenter.loadWebView()
    }
    
    // MARK: - Handlers
    private func configureWebView() {
        webView.navigationDelegate = self
    }
    
    private func configureActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
    }
}

// MARK: - DetailStoryViewPresenterProtocol
extension DetailStoryViewController: DetailStoryViewProtocol {
    func loadWebViewWithRequest(_ request: URLRequest) {
        webView.load(request)
    }
    
    func loadWebViewWithText(_ text: String) {
        webView.loadHTMLString(text, baseURL: nil)
    }
}

// MARK: - WKNavigationDelegate
extension DetailStoryViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        toogleActivityIndicatorStatus(activityIndicator: activityIndicator, isOn: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        toogleActivityIndicatorStatus(activityIndicator: activityIndicator, isOn: false)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        toogleActivityIndicatorStatus(activityIndicator: activityIndicator, isOn: false)
    }
}

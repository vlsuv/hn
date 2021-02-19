//
//  ViewController.swift
//  hn
//
//  Created by vlsuv on 15.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class StoryListViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var presenter: StoryListViewPresenterProtocol!
    private let loadingActivityIndicator = UIActivityIndicatorView()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    // MARK: - Handlers
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = loadingActivityIndicator
        tableView.tableFooterView?.frame.size.height = tableView.rowHeight
    }
    
    private func configureLoadingActivityIndicator() {
        loadingActivityIndicator.color = .black
        loadingActivityIndicator.startAnimating()
    }
}

// MARK: - StoryListViewProtocol
extension StoryListViewController: StoryListViewProtocol {
    func Succes() {
        toogleActivityIndicatorStatus(activityIndicator: loadingActivityIndicator, isOn: false)
        tableView.reloadData()
    }
    func Failure(withError error: Error) {
        print(error)
    }
}

// MARK: - UITableViewDataSource
extension StoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.stories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let story = presenter.stories?[indexPath.row] {
            cell.textLabel?.text = "\(story.title)"
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension StoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let story = presenter.stories?[indexPath.row] else { return }
        presenter.showDetail(withStory: story)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !presenter.isLoading {
                toogleActivityIndicatorStatus(activityIndicator: loadingActivityIndicator, isOn: true)
                presenter.fetchStories()
            }
        }
    }
}

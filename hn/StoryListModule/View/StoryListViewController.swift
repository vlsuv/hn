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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private let loadingActivityIndicator = UIActivityIndicatorView()
    var presenter: StoryListViewPresenterProtocol!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureLoadingActivityIndicator()
        configureSegmentedControl()
        configureNavigationController()
    }
    
    // MARK: - Actions
    @objc private func didChangeSegmentedControlValue(_ sender: UISegmentedControl) {
        presenter.setStoriesSegmentedIndex(index: sender.selectedSegmentIndex)
        tableView.reloadData()
        loadingActivityIndicator.startAnimating()
    }
    
    @objc private func didTapRefreshButton(_ sender: UIBarButtonItem) {
        presenter.refreshStories()
        tableView.reloadData()
        loadingActivityIndicator.startAnimating()
    }
    
    @objc private func didTapThemeButton(_ sender: UIBarButtonItem) {
        print("did change theme")
    }
    
    // MARK: - Handlers
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = loadingActivityIndicator
        tableView.tableFooterView?.frame.size.height = tableView.rowHeight
    }
    
    private func configureNavigationController() {
        let refreshAction = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(didTapRefreshButton(_:)))
        let changeThemeAction = UIBarButtonItem(title: "Theme", style: .plain, target: self, action: #selector(didTapRefreshButton(_:)))
        navigationItem.rightBarButtonItems = [refreshAction, changeThemeAction]
    }
    
    private func configureLoadingActivityIndicator() {
        loadingActivityIndicator.hidesWhenStopped = true
        loadingActivityIndicator.color = .black
    }
    
    private func configureSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(didChangeSegmentedControlValue(_:)), for: .valueChanged)
    }
}

// MARK: - StoryListViewProtocol
extension StoryListViewController: StoryListViewProtocol {
    func Succes() {
        loadingActivityIndicator.stopAnimating()
        tableView.reloadData()
    }
    func Failure(withError error: Error) {
        loadingActivityIndicator.stopAnimating()
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
                loadingActivityIndicator.startAnimating()
                presenter.fetchStories()
            }
        }
    }
}

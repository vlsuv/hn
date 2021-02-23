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
        view.backgroundColor = AssetsColors.background
        
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
        presenter.changeTheme()
    }
    
    // MARK: - Handlers
    private func configureTableView() {
        tableView.register(UINib(nibName: StoryListCell.identifier, bundle: nil), forCellReuseIdentifier: StoryListCell.identifier)
        tableView.tableFooterView = loadingActivityIndicator
        tableView.tableFooterView?.frame.size.height = tableView.rowHeight
        
        tableView.rowHeight = 48
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
    }
    
    private func configureNavigationController() {
        let refreshAction = UIBarButtonItem(image: Images.refresh, style: .plain, target: self, action: #selector(didTapRefreshButton(_:)))
        let changeThemeAction = UIBarButtonItem(image: Images.moon, style: .plain, target: self, action: #selector(didTapThemeButton(_:)))
        navigationItem.rightBarButtonItems = [refreshAction, changeThemeAction]
        
        navigationController?.navigationBar.tintColor = AssetsColors.text
        navigationController?.toTransparent()
    }
    
    private func configureLoadingActivityIndicator() {
        loadingActivityIndicator.hidesWhenStopped = true
        loadingActivityIndicator.color = AssetsColors.text
    }
    
    private func configureSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(didChangeSegmentedControlValue(_:)), for: .valueChanged)
        
        let normalAttributedString = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .light),
            NSAttributedString.Key.foregroundColor: AssetsColors.text
        ]
        segmentedControl.setTitleTextAttributes(normalAttributedString, for: .normal)
    }
}

// MARK: - StoryListViewProtocol
extension StoryListViewController: StoryListViewProtocol {
    func Succes() {
        loadingActivityIndicator.stopAnimating()
        tableView.reload()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryListCell.identifier, for: indexPath) as? StoryListCell else { return UITableViewCell() }
        if let story = presenter.stories?[indexPath.row] {
            cell.storyTitleLabel.text = story.title
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

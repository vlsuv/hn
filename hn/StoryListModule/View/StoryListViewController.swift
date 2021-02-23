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
    var presenter: StoryListViewPresenterProtocol!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AssetsColors.background
        
        configureTableView()
        configureSegmentedControl()
        configureNavigationController()
        
        presenter.fetchStories()
    }
    
    // MARK: - Actions
    @objc private func didChangeSegmentedControlValue(_ sender: UISegmentedControl) {
        presenter.setStoriesSegmentedIndex(index: sender.selectedSegmentIndex)
        tableView.reloadData()
    }
    
    @objc private func didTapRefreshButton(_ sender: UIBarButtonItem) {
        presenter.refreshStories()
        tableView.reloadData()
    }
    
    @objc private func didTapThemeButton(_ sender: UIBarButtonItem) {
        presenter.changeTheme()
    }
    
    // MARK: - Handlers
    private func configureTableView() {
        tableView.register(UINib(nibName: StoryListCell.identifier, bundle: nil), forCellReuseIdentifier: StoryListCell.identifier)
        tableView.register(UINib(nibName: LoadingCell.identifier, bundle: nil), forCellReuseIdentifier: LoadingCell.identifier)
        tableView.tableFooterView = UIView()
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
        tableView.reload()
    }
    func Failure(withError error: Error) {
        showAlert(title: error.localizedDescription, message: nil)
    }
}

// MARK: - UITableViewDataSource
extension StoryListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return presenter.stories?.count ?? 0
        } else if section == 1 && presenter.isLoading {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryListCell.identifier, for: indexPath) as? StoryListCell else { return UITableViewCell() }
            if let story = presenter.stories?[indexPath.row] {
                cell.storyTitleLabel.text = story.title
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier, for: indexPath) as? LoadingCell else { return UITableViewCell() }
            cell.activityIndicator.startAnimating()
            return cell
        }
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
                presenter.fetchStories()
                tableView.reloadSections(IndexSet(integer: 1), with: .none)
            }
        }
    }
}

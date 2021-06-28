//
//  StoryListController.swift
//  hn
//
//  Created by vlsuv on 15.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StoryListController: UIViewController {
    
    // MARK: - Properties
    var viewModel: StoryListViewModelProtocol?
    
    private var disposeBag: DisposeBag!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = AssetsColors.text
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    var shouldLoadNextData: Bool = false
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AssetsColors.background
        
        disposeBag = DisposeBag()
        
        configureNavigationController()
        configureTableView()
        configureSegmentedControl()
        setupInfiniteScroll()
        setupLoadingState()
    }
    
    // MARK: - Setups
    private func configureNavigationController() {
        let refreshAction = UIBarButtonItem(image: Image.refresh, style: .plain, target: self, action: nil)
        let changeThemeAction = UIBarButtonItem(image: Image.moon, style: .plain, target: self, action: nil)
        
        refreshAction.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.inputs.didTapRefreshStories()
            })
            .disposed(by: disposeBag)
        changeThemeAction.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.viewModel?.inputs.didTapChangeTheme()
            })
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItems = [refreshAction, changeThemeAction]
        
        navigationController?.navigationBar.tintColor = AssetsColors.text
        navigationController?.toTransparent()
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: StoryListCell.identifier, bundle: nil), forCellReuseIdentifier: StoryListCell.identifier)
        
        viewModel?.outputs.stories
            .do(onNext: { [weak self] stories in
                if !stories.isEmpty { self?.shouldLoadNextData = true }
            })
            .bind(to: tableView.rx.items(cellIdentifier: StoryListCell.identifier, cellType: StoryListCell.self)) { row, item, cell in
                cell.storyTitleLabel.text = item.title
        }
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel?.inputs.didTapShowDetail(at: indexPath)
            })
            .disposed(by: disposeBag)
        
        tableView.rowHeight = 48
        tableView.tableFooterView = activityIndicator
        tableView.tableFooterView?.frame.size.height = tableView.rowHeight + 10
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
    }
    
    private func configureSegmentedControl() {
        segmentedControl.rx.selectedSegmentIndex
            .bind(to: viewModel!.outputs.indexEndpoint)
            .disposed(by: disposeBag)
        
        let normalAttributedString = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .light),
            NSAttributedString.Key.foregroundColor: AssetsColors.text
        ]
        segmentedControl.setTitleTextAttributes(normalAttributedString, for: .normal)
    }
    
    private func setupInfiniteScroll() {
        tableView.rx.contentOffset
            .map { _ -> Bool in self.tableView.isNearBottomEdge(edgeOffset: 20.0) && self.shouldLoadNextData }
            .subscribe(onNext: { success in
                if success {
                    self.shouldLoadNextData = false
                    self.viewModel?.inputs.nextData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLoadingState() {
        viewModel?.outputs.isLoading.asDriver()
            .drive(onNext: { isLoading in
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }).disposed(by: disposeBag)
    }
}

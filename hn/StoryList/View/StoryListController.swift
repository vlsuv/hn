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
    
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    // MARK: - Properties
    var viewModel: StoryListViewModelProtocol?
    
    private var disposeBag: DisposeBag!
    
    @IBOutlet weak var tableView: UITableView!
        
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
        
        // When tap on refresh button
        refreshAction
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.inputs.refreshTrigger.accept(())
            })
            .disposed(by: disposeBag)
        
        // When tap on change theme button
        changeThemeAction
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in self?.viewModel?.inputs.didTapChangeTheme()
            })
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItems = [refreshAction, changeThemeAction]
        
        navigationController?.navigationBar.tintColor = AssetsColors.text
        navigationController?.toTransparent()
    }
    
    private func configureTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.register(UINib(nibName: StoryListCell.identifier, bundle: nil), forCellReuseIdentifier: StoryListCell.identifier)
        
        // When received data to change tableView
        viewModel?
            .outputs
            .stories
            .do(onNext: { [weak self] stories in
                if !stories.isEmpty { self?.shouldLoadNextData = true }
            })
            .bind(to: tableView.rx.items(cellIdentifier: StoryListCell.identifier, cellType: StoryListCell.self)) { row, item, cell in
                
                cell.viewModel = self.viewModel?.outputs.storyListViewModelCell(for: item)
        }
        .disposed(by: disposeBag)
        
        // When tap on cell
        tableView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel?.inputs.didTapShowDetail(at: indexPath)

                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        // tableView UI
        tableView.estimatedRowHeight = 85
        tableView.tableFooterView = activityIndicator
        tableView.tableFooterView?.frame.size.height = 48
        tableView.separatorStyle = .singleLine
    }
    
    private func configureSegmentedControl() {
        segmentedControl.setButtonTitles(buttonTitle: ["Top", "New", "Show"])
        
        // When tap segmented control
        segmentedControl
        .selectedSegmentIndex
            .bind(to: viewModel!.outputs.indexEndpoint)
        .disposed(by: disposeBag)
    }
    
    private func setupInfiniteScroll() {
        // Observe for contentOffset of tableView
        tableView
            .rx
            .contentOffset
            .map { _ -> Bool in self.tableView.isNearBottomEdge(edgeOffset: 20.0) && self.shouldLoadNextData }
            .subscribe(onNext: { success in
                if success {
                    self.shouldLoadNextData = false
                    
                    self.viewModel?.inputs.nextDataTrigger.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLoadingState() {
        // Observe for loading state
        viewModel?
            .outputs
            .isLoading
            .asDriver()
            .drive(onNext: { isLoading in
                isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension StoryListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

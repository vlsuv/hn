//
//  CommentsViewController.swift
//  hn
//
//  Created by vlsuv on 30.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CommentsViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: DetailStoryViewModelType!
    
    var previewStoryView: PreviewStoryView = {
        let view = PreviewStoryView()
        return view
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        tableView.backgroundColor = AssetsColors.background
        return tableView
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = AssetsColors.text
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    var disposeBag: DisposeBag!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        disposeBag = DisposeBag()
        
        view.backgroundColor = AssetsColors.background
        
        configureTableView()
        configurePreviewStoryView()
        setupLoadingState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.inputs.viewDidDisappear()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Handlers
    private func configureTableView() {
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.outputs.comments
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: CommentCell.identifier, cellType: CommentCell.self)) { [weak self] _, items, cell in
                guard let self = self else { return }
                
                cell.configure(self.viewModel.outputs.detailStoryCellViewModel(for: items))
        }
        .disposed(by: disposeBag)
        
        tableView.tableFooterView = activityIndicator
        tableView.tableFooterView?.frame.size.height = 48
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func configurePreviewStoryView() {
        previewStoryView.configure(viewModel.outputs.previewStoryViewModel())
        
        let tapGesture = UITapGestureRecognizer()
        previewStoryView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.subscribe(onNext: { [weak self] _ in
            self?.viewModel.inputs.didTapPreviewStory()
        })
            .disposed(by: disposeBag)
    }
    
    private func setupLoadingState() {
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
extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return previewStoryView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

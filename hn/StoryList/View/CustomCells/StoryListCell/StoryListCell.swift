//
//  StoryListCell.swift
//  hn
//
//  Created by vlsuv on 20.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class StoryListCell: UITableViewCell {
    
    // MARK: - Propeties
    static let identifier = "StoryListCell"
    
    @IBOutlet weak var storyTitleLabel: UILabel!
    
    @IBOutlet weak var urlLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var viewModel: StoryListCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            
            storyTitleLabel.text = viewModel.title
            urlLabel.text = viewModel.urlHost
            scoreLabel.text = viewModel.score
            timeLabel.text = viewModel.time
        }
    }
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorInset = .zero
        
        setupStoryTitleLabel()
        setupBottomLabels()
    }
    
    // MARK: - Elements Setups
    private func setupStoryTitleLabel() {
        storyTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        storyTitleLabel.textColor = Color.text
        storyTitleLabel.sizeToFit()
        storyTitleLabel.numberOfLines = 0
    }
    
    private func setupBottomLabels() {
        [urlLabel, scoreLabel, timeLabel].forEach {
            $0?.font = .systemFont(ofSize: 14, weight: .regular)
            $0?.textColor = Color.mediumGray
        }
    }
}

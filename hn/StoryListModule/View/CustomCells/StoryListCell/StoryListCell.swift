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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStoryTitleLabel()
    }
    
    func setupStoryTitleLabel() {
        storyTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        storyTitleLabel.textColor = AssetsColors.text
    }
}

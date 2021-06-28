//
//  LoadingCell.swift
//  hn
//
//  Created by vlsuv on 23.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "LoadingCell"
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

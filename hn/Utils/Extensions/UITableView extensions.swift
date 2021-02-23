//
//  UITableView extensions.swift
//  hn
//
//  Created by vlsuv on 22.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

extension UITableView {
    func reload() {
        let contentOffset = self.contentOffset
        self.reloadData()
        self.layoutIfNeeded()
        self.setContentOffset(contentOffset, animated: false)
    }
}

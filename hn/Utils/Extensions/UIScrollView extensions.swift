//
//  UIScrollView extensions.swift
//  hn
//
//  Created by vlsuv on 28.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}

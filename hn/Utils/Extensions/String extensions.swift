//
//  String extensions.swift
//  hn
//
//  Created by vlsuv on 05.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

extension String {
    func getAttributedString() -> NSAttributedString? {
        let data = Data(self.utf8)
        
        guard let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else { return nil }
        
        return attributedString
    }
}

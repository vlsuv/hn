//
//  Colors.swift
//  hn
//
//  Created by vlsuv on 20.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

enum Color {
    static let white = UIColor.white
    static let black = UIColor.black
    static let mediumGray = UIColor(named: "MediumGrayColor")
    static let darkGray = UIColor(named: "DarkGrayColor")
    static let orange = UIColor(named: "OrangeColor") ?? UIColor()
    
    static let text = UIColor(named: "TextColor") ?? UIColor()
    static let background = UIColor(named: "BackgroundColor") ?? UIColor()
}

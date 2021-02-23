//
//  UserSettings.swift
//  hn
//
//  Created by vlsuv on 22.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

final class UserSettings {
    enum SettingKeys: String {
        case darkMode
    }
    
    static var darkMode: Bool {
        get {
            return UserDefaults.standard.bool(forKey: SettingKeys.darkMode.rawValue)
        } set {
            let defaults = UserDefaults.standard
            let key = SettingKeys.darkMode.rawValue
            defaults.set(newValue, forKey: key)
        }
    }
}

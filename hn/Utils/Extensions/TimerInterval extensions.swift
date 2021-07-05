//
//  TimerInterval extensions.swift
//  hn
//
//  Created by vlsuv on 02.07.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

extension TimeInterval {
    func passedTime() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        let interval = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date, to: Date())
        
        if let day = interval.day, day > 0 {
            return "\(day)d"
        } else if let hour = interval.hour, hour > 0 {
            return "\(hour)h"
        } else if let minute = interval.minute, minute > 0 {
            return "\(minute)m"
        } else if let second = interval.second {
            return "\(second)s"
        } else {
            return "s"
        }
    }
}

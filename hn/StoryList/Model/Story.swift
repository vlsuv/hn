//
//  Story.swift
//  hn
//
//  Created by vlsuv on 15.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

struct Story: Decodable {
    let by: String
    let descendants: Int?
    let id: Int
    let kids: [Int]?
    let score: Int
    let time: TimeInterval
    let title: String
    let type: String
    let url: String?
    let text: String?
}

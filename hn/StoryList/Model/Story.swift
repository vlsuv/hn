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
    
    enum CustomerKeys: String, CodingKey {
        case by, descendants, id, kids, score, time, title, type, url, text
    }
    
    init (from decoder: Decoder) throws {
        let container =  try decoder.container (keyedBy: CustomerKeys.self)
        
        by = try container.decode(String.self, forKey: .by)
        descendants = try? container.decode(Int.self, forKey: .descendants)
        id = try container.decode(Int.self, forKey: .id)
        kids = try? container.decode([Int].self, forKey: .kids)
        score = try container.decode(Int.self, forKey: .score)
        time = try container.decode(TimeInterval.self, forKey: .time)
        title = try container.decode(String.self, forKey: .title)
        type = try container.decode(String.self, forKey: .type)
        url = try? container.decode(String.self, forKey: .url)
        text = try? container.decode(String.self, forKey: .text)
    }
}

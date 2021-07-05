//
//  Comment.swift
//  hn
//
//  Created by vlsuv on 30.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

/*
 "by" : "norvig",
 "id" : 2921983,
 "kids" : [ 2922097, 2922429, 2924562, 2922709, 2922573, 2922140, 2922141 ],
 "parent" : 2921506,
 "text" : "Aw shucks, guys ... you make me blush with your compliments.<p>Tell you what, Ill make a deal: I'll keep writing if you keep reading. K?",
 "time" : 1314211127,
 "type" : "comment"
 */

class Comment: Decodable {
    var by: String?
    var id: Int
    var kids: [Int]?
    var parent: Int
    var text: String?
    var time: TimeInterval
    var type: String
    
    var replies: [Comment] = [Comment]()
    var level: Int {
        guard let parentLevel = replyTo?.level else {
            return 1
        }
        
        return parentLevel + 1
    }
    var isExpand: Bool = false
    var replyTo: Comment?
    
    init(by: String = "bar", id: Int = 2, kids: [Int] = [Int](), parent: Int = 0, text: String = "hello", time: TimeInterval = 0.0, type: String = "story") {
        
        self.by = by
        self.id = id
        self.kids = kids
        self.parent = parent
        self.text = text
        self.time = time
        self.type = type
    }
    
    enum CustomerKeys: String, CodingKey {
        case by, id, kids, parent, text, time, type
    }
    
    required init (from decoder: Decoder) throws {
        let container =  try decoder.container (keyedBy: CustomerKeys.self)
        
        by = try? container.decode(String.self, forKey: .by)
        id = try container.decode(Int.self, forKey: .id)
        kids = try? container.decode([Int].self, forKey: .kids)
        parent = try container.decode(Int.self, forKey: .parent)
        text = try? container.decode(String.self, forKey: .text)
        time = try container.decode(TimeInterval.self, forKey: .time)
        type = try container.decode(String.self, forKey: .type)
    }
}

extension Comment {
    func addReply(_ reply: Comment) {
        reply.replyTo = self
        replies.append(reply)
    }
    
    func isRoot() -> Bool {
        return replyTo == nil
    }
    
    func isReplyToExpand() -> Bool {
        guard let replyTo = replyTo else { return false }
        
        return replyTo.isExpand
    }
    
    func setExpand(_ isExpand: Bool) {
        self.isExpand = isExpand
        
        for i in 0..<replies.count {
            replies[i].setExpand(isExpand)
        }
    }
}

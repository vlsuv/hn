//
//  ErrorManager.swift
//  hn
//
//  Created by vlsuv on 15.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

enum ErrorManager: Error {
    case MissingHTTPResponce
    case DataParseError
    case StatusCodeError(Int)
    case StorySegmentError
}

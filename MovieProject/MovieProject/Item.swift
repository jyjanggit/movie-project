//
//  Item.swift
//  MovieProject
//
//  Created by JY Jang on 10/11/25.
//

import Foundation
import SwiftData

@Model
final class Comment {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

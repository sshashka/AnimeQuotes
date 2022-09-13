//
//  Model.swift
//  AnimeQuotes
//
//  Created by Саша Василенко on 06.09.2022.
//

import Foundation

enum Section {
    case main
}

struct Model: Codable, Hashable {
    let identifier = UUID()
    let anime, character, quote: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(anime)
    }
    
    
}

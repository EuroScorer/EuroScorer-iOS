//
//  Song.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation

final class Song {
    
    var identifier = ""
    var number = 0
    var title = ""
    var link = ""
    var country: Country?
    var numberOfVotesGiven = 0
    
    func addVote() {
        numberOfVotesGiven = numberOfVotesGiven + 1
    }
    
    func removeVote() {
        numberOfVotesGiven = numberOfVotesGiven - 1
    }
}

extension Song: Decodable {
    enum CodingKeys: String, CodingKey {
        case number = "number"
        case title = "title"
        case country = "country"
        case link = "link"
    }
}

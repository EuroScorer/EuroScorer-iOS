//
//  FirebaseSong.swift
//  EuroScorer
//
//  Created by Sacha Durand Saint Omer on 12/04/2023.
//  Copyright © 2023 MarsacProductions. All rights reserved.
//

import Foundation

struct FirebaseSong: Song, Decodable {
    let number: Int
    let title: String
    let link:  String
    var country: Country?
    
    enum CodingKeys: String, CodingKey {
        case number = "number"
        case title = "title"
        case country = "country"
        case link = "link"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        number = try container.decode(Int.self, forKey: .number)
        title = try container.decode(String.self, forKey: .title)
        link = try container.decode(String.self, forKey: .link)
        country = try container.decode(FirebaseCountry.self, forKey: .country)
    }
}

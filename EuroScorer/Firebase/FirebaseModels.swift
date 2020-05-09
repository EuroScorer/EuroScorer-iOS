//
//  FirebaseModels.swift
//  EuroScorer
//
//  Created by Sacha DSO on 23/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation

struct FirebaseUser: UserProtocol {
    let countryCode: String
    let phoneNumber: String
}

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

struct FirebaseCountry: Country, Decodable {
    let code: String
    let name: String
}


struct FirebaseVote: Decodable {
    let user: String
    let country: String
    let votes: [String]
}

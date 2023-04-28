//
//  FirebaseSong.swift
//  EuroScorer
//
//  Created by Sacha Durand Saint Omer on 12/04/2023.
//  Copyright © 2023 MarsacProductions. All rights reserved.
//

import Foundation

struct FirebaseSong: Decodable {
    let number: Int
    let title: String
    let link:  String
    var country: FirebaseCountry?
}

extension FirebaseSong {
    func toSong() -> Song {
        var c: Country?
        if let country = country {
            c = Country(code: country.code, name: country.name)
        }
        return Song(number: number, title: title, link: link, country: c)
    }
}

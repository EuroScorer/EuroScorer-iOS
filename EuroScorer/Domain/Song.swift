//
//  Song.swift
//  EuroScorer
//
//  Created by Sacha Durand Saint Omer on 12/04/2023.
//  Copyright © 2023 MarsacProductions. All rights reserved.
//

import Foundation

protocol Song {
    var number: Int { get }
    var title: String { get }
    var link: String { get }
    var country: Country? { get }
}

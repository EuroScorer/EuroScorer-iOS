//
//  SongRepository.swift
//  EuroScorer
//
//  Created by Sacha Durand Saint Omer on 12/04/2023.
//  Copyright © 2023 MarsacProductions. All rights reserved.
//

import Foundation

protocol SongRepository {
    func fetchSongs() async throws -> [Song]
}

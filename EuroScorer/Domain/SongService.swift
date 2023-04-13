//
//  SongService.swift
//  EuroScorer
//
//  Created by Sacha Durand Saint Omer on 12/04/2023.
//  Copyright © 2023 MarsacProductions. All rights reserved.
//

import Foundation

class SongService {
    
    private let repository: SongRepository
    
    init(repository: SongRepository) {
        self.repository = repository
    }
    
    func fetchSongs() async throws -> [Song] {
        return try await repository.fetchSongs()
    }
}

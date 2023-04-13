//
//  FirebaseSongRepository.swift
//  EuroScorer
//
//  Created by Sacha Durand Saint Omer on 12/04/2023.
//  Copyright © 2023 MarsacProductions. All rights reserved.
//

import Foundation
import Networking

class FirebaseSongRepository: NetworkingService, SongRepository {
    
    init() {}
    
    var network = NetworkingClient(baseURL: "https://euroscorer-api.web.app/v1")
    
    func fetchSongs() async throws -> [Song] {
        let firebaseSongs: [FirebaseSong] = try await get("/songs")
        return firebaseSongs.map { $0.toSong() }
    }
}

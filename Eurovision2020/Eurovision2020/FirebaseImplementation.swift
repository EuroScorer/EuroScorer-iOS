//
//  FirebaseImplementation.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Combine

struct FirebaseImplementation {
    
    func fetchSongs() -> AnyPublisher<[Song], Error> {
        Future { promise in
            let db = Firestore.firestore()
            db.collection("songs").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let songs = querySnapshot!.documents.map { d -> Song in
                        let song = Song()
                        song.identifier = d.documentID
                        if let title: String = d.data()["title"] as? String {
                            song.title = title
                        }
                        
                        if let countryCode: String = d.data()["countryCode"] as? String {
                            song.country = Country.countries.first(where: { $0.code == countryCode })
                        }
                        return song
                    }
                    promise(.success(songs))
                }
            }
            
        }.eraseToAnyPublisher()
    }
    
    func fetchCountries() -> AnyPublisher<[Country], Error> {
        Future { promise in
            let db = Firestore.firestore()
            db.collection("countries").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let countries = querySnapshot!.documents.map { d -> Country in
                        var country = Country()
                        country.code = d.documentID
                        if let name: String = d.data()["name"] as? String {
                            country.name = name
                        }
                        return country
                    }
                    promise(.success(countries))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}

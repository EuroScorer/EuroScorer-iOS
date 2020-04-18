//
//  DatabaseScripts.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation
import FirebaseFirestore


let countriesLocalDatabase = [
    Country(code: "AL", name: "Albania"),
    Country(code: "AM", name: "Armenia"),
    Country(code: "AU", name: "Australia"),
    Country(code: "AT", name: "Austria"),
    Country(code: "AZ", name: "Azerbaijan"),
    Country(code: "BY", name: "Belarus"),
    Country(code: "BE", name: "Belgium"),
    Country(code: "HR", name: "Croatia"),
    Country(code: "CY", name: "Cyprus"),
    Country(code: "CZ", name: "Czech Republic"),
    Country(code: "EE", name: "Estonia"),
    Country(code: "DK", name: "Denmark"),
    Country(code: "FI", name: "Finland"),
    Country(code: "FR", name: "France"),
    Country(code: "GE", name: "Georgia"),
    Country(code: "DE", name: "Germany"),
    Country(code: "GR", name: "Greece"),
    Country(code: "HU", name: "Hungary"),
    Country(code: "IS", name: "Iceland"),
    Country(code: "IE", name: "Ireland"),
    Country(code: "IL", name: "Israel"),
    Country(code: "IT", name: "Italy"),
    Country(code: "LV", name: "Latvia"),
    Country(code: "LT", name: "Lithuania"),
    Country(code: "MT", name: "Malta"),
    Country(code: "MD", name: "Moldova"),
    Country(code: "NL", name: "Netherlands"),
    Country(code: "MK", name: "North Macedonia"),
    Country(code: "MO", name: "Norway"),
    Country(code: "PL", name: "Poland"),
    Country(code: "PT", name: "Portugal"),
    Country(code: "RO", name: "Romania"),
    Country(code: "RU", name: "Russia"),
    Country(code: "SM", name: "San Marino"),
    Country(code: "RS", name: "Serbia"),
    Country(code: "SI", name: "Slovenia"),
    Country(code: "ES", name: "Spain"),
    Country(code: "SE", name: "Sweden"),
    Country(code: "CH", name: "Switzerland"),
    Country(code: "UA", name: "Ukraine"),
    Country(code: "GB", name: "United Kingdom"),
    Country(code: "BG", name: "Bulgaria")
]

struct DataBaseScripts {
    static func createCountries() {
        let countriesDB = Firestore.firestore().collection("countries")
        countriesLocalDatabase.forEach { c in
            countriesDB.document(c.code).setData(["name": c.name]) { completion in
                print(completion)
            }
        }
    }
}


//let songs:[Song] = [
//    Song(country: Country(code: "AL", name: "Albania"), title: "Destiny - All of My Love"),
//    Song(country: Country(code: "AM", name: "Armenia"), title: "Aritera Ara - Fall from the King"),
//    Song(country: Country(code: "AU", name: "Australia"), title: "Crysto - Kemama"),
//    Song(country: Country(code: "AT", name: "Austria"), title: "Loustic - Some song"),
//    Song(country: Country(code: "AZ", name: "Azerbaijan"), title: "Destiny - All of My Love"),
//    Song(country: Country(code: "BY", name: "Belarus"), title: "Aritera Ara - Fall from the King"),
//    Song(country: Country(code: "BE", name: "Belgium"), title: "Crysto - Kemama"),
//    Song(country: Country(code: "HR", name: "Croatia"), title: "Loustic - Some song"),
//    Song(country: Country(code: "CY", name: "Cyprus"), title: "Destiny - All of My Love"),
//    Song(country: Country(code: "CZ", name: "Czech Republic"), title: "Aritera Ara - Fall from the King"),
//    Song(country: Country(code: "EE", name: "Estonia"), title: "Crysto - Kemama"),
//    Song(country: Country(code: "DK", name: "Denmark"), title: "Loustic - Some song"),
//    Song(country: Country(code: "FI", name: "Finland"), title: "Loustic - Some song"),
//    Song(country: Country(code: "FR", name: "France"), title: "Loustic - Some song"),
//    Song(country: Country(code: "GE", name: "Georgia"), title: "Loustic - Some song"),
//    Song(country: Country(code: "DE", name: "Germany"), title: "Loustic - Some song"),
//    Song(country: Country(code: "GR", name: "Greece"), title: "Loustic - Some song"),
//    Song(country: Country(code: "HU", name: "Hungary"), title: "Loustic - Some song"),
//    Song(country: Country(code: "IS", name: "Iceland"), title: "Loustic - Some song"),
//    Song(country: Country(code: "IE", name: "Ireland"), title: "Loustic - Some song"),
//    Song(country: Country(code: "IL", name: "Israel"), title: "Loustic - Some song"),
//    Song(country: Country(code: "IT", name: "Italy"), title: "Loustic - Some song"),
//    Song(country: Country(code: "LV", name: "Latvia"), title: "Loustic - Some song"),
//    Song(country: Country(code: "LT", name: "Lithuania"), title: "Loustic - Some song"),
//    Song(country: Country(code: "MT", name: "Malta"), title: "Loustic - Some song"),
//    Song(country: Country(code: "MD", name: "Moldova"), title: "Loustic - Some song"),
//    Song(country: Country(code: "NL", name: "Netherlands"), title: "Loustic - Some song"),
//    Song(country: Country(code: "MK", name: "North Macedonia"), title: "Loustic - Some song"),
//    Song(country: Country(code: "MO", name: "Norway"), title: "Loustic - Some song"),
//    Song(country: Country(code: "PL", name: "Poland"), title: "Loustic - Some song"),
//    Song(country: Country(code: "PT", name: "Portugal"), title: "Loustic - Some song"),
//    Song(country: Country(code: "RO", name: "Romania"), title: "Loustic - Some song"),
//    Song(country: Country(code: "RU", name: "Russia"), title: "Loustic - Some song"),
//    Song(country: Country(code: "SM", name: "San Marino"), title: "Loustic - Some song"),
//    Song(country: Country(code: "RS", name: "Serbia"), title: "Loustic - Some song"),
//    Song(country: Country(code: "SI", name: "Slovenia"), title: "Loustic - Some song"),
//    Song(country: Country(code: "ES", name: "Spain"), title: "Loustic - Some song"),
//    Song(country: Country(code: "SE", name: "Sweden"), title: "Loustic - Some song"),
//    Song(country: Country(code: "CH", name: "Switzerland"), title: "Loustic - Some song"),
//    Song(country: Country(code: "UA", name: "Ukraine"), title: "Loustic - Some song"),
//    Song(country: Country(code: "GB", name: "United Kingdom"), title: "Loustic - Some song")
//]

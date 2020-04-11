//
//  AppDelegate.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 07/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


let songs:[Song] = [
    Song(country: Country(code: "AL", name: "Albania"), title: "Destiny - All of My Love"),
    Song(country: Country(code: "AM", name: "Armenia"), title: "Aritera Ara - Fall from the King"),
    Song(country: Country(code: "AU", name: "Australia"), title: "Crysto - Kemama"),
    Song(country: Country(code: "AT", name: "Austria"), title: "Loustic - Some song"),
    Song(country: Country(code: "AZ", name: "Azerbaijan"), title: "Destiny - All of My Love"),
    Song(country: Country(code: "BY", name: "Belarus"), title: "Aritera Ara - Fall from the King"),
    Song(country: Country(code: "BE", name: "Belgium"), title: "Crysto - Kemama"),
    Song(country: Country(code: "HR", name: "Croatia"), title: "Loustic - Some song"),
    Song(country: Country(code: "CY", name: "Cyprus"), title: "Destiny - All of My Love"),
    Song(country: Country(code: "CZ", name: "Czech Republic"), title: "Aritera Ara - Fall from the King"),
    Song(country: Country(code: "EE", name: "Estonia"), title: "Crysto - Kemama"),
    Song(country: Country(code: "DK", name: "Denmark"), title: "Loustic - Some song"),
    Song(country: Country(code: "FI", name: "Finland"), title: "Loustic - Some song"),
    Song(country: Country(code: "FR", name: "France"), title: "Loustic - Some song"),
    Song(country: Country(code: "GE", name: "Georgia"), title: "Loustic - Some song"),
    Song(country: Country(code: "DE", name: "Germany"), title: "Loustic - Some song"),
    Song(country: Country(code: "GR", name: "Greece"), title: "Loustic - Some song"),
    Song(country: Country(code: "HU", name: "Hungary"), title: "Loustic - Some song"),
    Song(country: Country(code: "IS", name: "Iceland"), title: "Loustic - Some song"),
    Song(country: Country(code: "IE", name: "Ireland"), title: "Loustic - Some song"),
    Song(country: Country(code: "IL", name: "Israel"), title: "Loustic - Some song"),
    Song(country: Country(code: "IT", name: "Italy"), title: "Loustic - Some song"),
    Song(country: Country(code: "LV", name: "Latvia"), title: "Loustic - Some song"),
    Song(country: Country(code: "LT", name: "Lithuania"), title: "Loustic - Some song"),
    Song(country: Country(code: "MT", name: "Malta"), title: "Loustic - Some song"),
    Song(country: Country(code: "MD", name: "Moldova"), title: "Loustic - Some song"),
    Song(country: Country(code: "NL", name: "Netherlands"), title: "Loustic - Some song"),
    Song(country: Country(code: "MK", name: "North Macedonia"), title: "Loustic - Some song"),
    Song(country: Country(code: "MO", name: "Norway"), title: "Loustic - Some song"),
    Song(country: Country(code: "PL", name: "Poland"), title: "Loustic - Some song"),
    Song(country: Country(code: "PT", name: "Portugal"), title: "Loustic - Some song"),
    Song(country: Country(code: "RO", name: "Romania"), title: "Loustic - Some song"),
    Song(country: Country(code: "RU", name: "Russia"), title: "Loustic - Some song"),
    Song(country: Country(code: "SM", name: "San Marino"), title: "Loustic - Some song"),
    Song(country: Country(code: "RS", name: "Serbia"), title: "Loustic - Some song"),
    Song(country: Country(code: "SI", name: "Slovenia"), title: "Loustic - Some song"),
    Song(country: Country(code: "ES", name: "Spain"), title: "Loustic - Some song"),
    Song(country: Country(code: "SE", name: "Sweden"), title: "Loustic - Some song"),
    Song(country: Country(code: "CH", name: "Switzerland"), title: "Loustic - Some song"),
    Song(country: Country(code: "UA", name: "Ukraine"), title: "Loustic - Some song"),
    Song(country: Country(code: "GB", name: "United Kingdom"), title: "Loustic - Some song")
]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        
        db.collection("countries").getDocuments() { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        

        
        
        window = UIWindow()
        let navVC = UINavigationController(rootViewController: HomeVC())
        navVC.navigationBar.isHidden = true
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
        return true
    }
}


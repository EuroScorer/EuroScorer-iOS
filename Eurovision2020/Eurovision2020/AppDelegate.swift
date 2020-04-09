//
//  AppDelegate.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 07/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit

let songs:[Song] = [
    Song(country: "Malta", title: "Destiny - All of My Love"),
    Song(country: "Albani", title: "Aritera Ara - Fall from the King"),
    Song(country: "Czech Republic", title: "Crysto - Kemama"),
    Song(country: "France", title: "Loustic - Some song"),
    Song(country: "Malta", title: "Destiny - All of My Love"),
    Song(country: "Albani", title: "Aritera Ara - Fall from the King"),
    Song(country: "Czech Republic", title: "Crysto - Kemama"),
    Song(country: "France", title: "Loustic - Some song"),
    Song(country: "Malta", title: "Destiny - All of My Love"),
    Song(country: "Albani", title: "Aritera Ara - Fall from the King"),
    Song(country: "Czech Republic", title: "Crysto - Kemama"),
    Song(country: "France", title: "Loustic - Some song"),
]


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = VotingVC()
        window?.makeKeyAndVisible()
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
        return true
    }
}


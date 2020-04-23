//
//  AppDelegate.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 07/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Inject firebase implementations.
        let firebase = FirebaseImplementation()
        User.Endpoint.askForPhoneNumberVerification = firebase.askForPhoneNumberVerification
        User.Endpoint.confirmPhoneNumberWithCode = firebase.confirmPhoneNumberWithCode
        User.Endpoint.getCurrentUser = firebase.getCurrentUser
        User.Endpoint.logout = firebase.logout
        Song.Endpoint.fetchSongs = firebase.fetchSongs
        Vote.Endpoint.sendVotes = firebase.sendVotes
        firebase.startService()
        
        // Setup UI
        window = UIWindow()
        let votingVC = VotingVC()
        let navVC: NavVC! = NavVC(rootViewController: votingVC)
        navVC.navigationBar.barStyle = .black
        navVC.navigationBar.prefersLargeTitles = true
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        // Uncomment for code injection
        // Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
        
        return true
    }
}




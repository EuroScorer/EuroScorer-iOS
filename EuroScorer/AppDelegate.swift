//
//  AppDelegate.swift
//  EuroScorer
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
        User.Endpoint.confirmPhoneNumberWithCode = firebase.confirmPhoneNumberWithCode
        User.Endpoint.getCurrentUser = firebase.getCurrentUser
        User.Endpoint.sendVotes = firebase.sendVotes
        User.Endpoint.fetchVotes = firebase.fetchVotes
        User.Endpoint.logout = firebase.logout
        
        let songService = SongService(repository: FirebaseSongRepository())
        
        let userService = UserService(repository: FirebaseUserRepository())
        
        
        // Setup UI
        window = UIWindow()
        let votingVC = VotingVC(songService: songService, userService: userService)
        let navVC: NavVC! = NavVC(rootViewController: votingVC)
        navVC.navigationBar.barStyle = .black
        navVC.navigationBar.prefersLargeTitles = true
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        // Uncomment for code injection
         Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
        
        return true
    }
}




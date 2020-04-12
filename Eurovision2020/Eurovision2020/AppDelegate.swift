//
//  AppDelegate.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 07/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Firebase
import Combine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var cancellables = Set<AnyCancellable>()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let fbImplementation = FirebaseImplementation()
        Song.Endpoint.fetchSongs = fbImplementation.fetchSongs
        Country.Endpoint.fetchCountries = fbImplementation.fetchCountries
        
        FirebaseApp.configure()
        
        window = UIWindow()
        let navVC = NavVC(rootViewController: VotingVC())
        navVC.navigationBar.isHidden = true
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
        
        // Fetch countries on App Start
        Country.fetchCountries().then { fetchedCountries in
            Country.countries = fetchedCountries
        }.sinkAndStore(in: &cancellables)
        
        return true
    }
}

class NavVC: UINavigationController {
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


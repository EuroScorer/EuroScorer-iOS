//
//  ViewController.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 07/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    var v = HomeView()
    override func loadView() {
        view = v
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        v.blurredEffectView.addGestureRecognizer(tap)
     
//        on("INJECTION_BUNDLE_NOTIFICATION") {
//            self.v = HomeView()
//            self.view = self.v
//        }
        
        v.okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
    }
    
    @objc
    func tapped() {
        view.endEditing(true)
    }
    
    @objc
    func okTapped() {
        print("Phone number is : \(v.phoneNumberField.text) ")
    }
}


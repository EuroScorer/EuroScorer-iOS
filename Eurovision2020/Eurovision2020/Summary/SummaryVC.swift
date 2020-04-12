//
//  SummaryVC.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 09/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit

class SummaryVC: UIViewController {
    
    var v = SummaryView()
    override func loadView() {
        view = v
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName:
            NSNotification.Name(rawValue:"INJECTION_BUNDLE_NOTIFICATION"),
                                               object: nil,
                                               queue: .main) { [weak self] _ in
                                                self?.v = SummaryView()
                                                self?.view = self?.v
        }

    }    
}

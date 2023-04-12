//
//  LoadingButton.swift
//  EuroScorer
//
//  Created by Sacha DSO on 05/05/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia

class LoadingButton: UIButton {
    
    private var isLoadingValue = false
    var isLoading: Bool {
        get { isLoadingValue}
        set {
            if newValue == true {
                isUserInteractionEnabled = false
                titleLabel?.alpha = 0
                spinner.startAnimating()
            } else {
                isUserInteractionEnabled = true
                titleLabel?.alpha = 1
                spinner.stopAnimating()
            }
            isLoadingValue = newValue
        }
    }
    
    let spinner = UIActivityIndicatorView(style: .medium)
    
    convenience init() {
        self.init(frame: .zero)
        
        subviews {
            spinner
        }
        
        spinner.centerInContainer()
        
        spinner.color = .white
    }
}

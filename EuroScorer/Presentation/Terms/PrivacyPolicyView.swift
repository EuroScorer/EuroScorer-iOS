//
//  PrivacyPolicyView.swift
//  EuroScorer
//
//  Created by Sacha DSO on 05/05/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia

class PrivacyPolicyView: UIView {
    
    let background = BlurredBackgroundView()
    let button = UIButton()
    let textView = UITextView()
    
    convenience init() {
        self.init(frame: .zero)
    
        subviews {
            background
            textView
            button
        }
        
        background.fillContainer()
        layout {
            20
            |textView|
            10
            |-10-button-10-|// ~ 100
        }
        button.Bottom == safeAreaLayoutGuide.Bottom - 10
        
        button.style(Styles.buttonStyle)
        
        
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.isEditable = false
        

        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        
        button.setTitle("I am over 13 years old &\n I accept this Privacy Policy", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        backgroundColor = .white
    }
}

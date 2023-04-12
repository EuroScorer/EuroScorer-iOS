//
//  PhoneNumberValidationView.swift
//  EuroScorer
//
//  Created by Sacha DSO on 08/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia
import PhoneNumberKit

class PhoneNumberValidationView: UIView {
    
    let blurredbackground = BlurredBackgroundView()
    let phoneNumberBackground = UIView()
    let phoneNumberField = PhoneNumberTextField()
    let okButton = LoadingButton()
    
    convenience init() {
        self.init(frame: .zero)
        
        // MARK: - View Hierarchy
        subviews {
            blurredbackground
            phoneNumberBackground.subviews {
                phoneNumberField
            }
            okButton
        }

        // MARK: - Layout
        blurredbackground.fillContainer()
        |-20-phoneNumberBackground.centerVertically(offset: -100)-20-| ~ 60
        |-20-phoneNumberField.fillVertically()-20-|
        |-20-okButton-20-| ~ 50
        okButton.Bottom == keyboardLayoutGuide.Top - 20
        
        // MARK: - Style
        phoneNumberBackground.style { v in
            v.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            v.layer.cornerRadius = 10
        }
        phoneNumberField.style { f in
            f.font = UIFont.systemFont(ofSize: 30, weight: .light)
            f.textColor = .white
            f.withFlag = true
            f.withPrefix = true
            f.withExamplePlaceholder = true
            f.withDefaultPickerUI = true
        }
        okButton.style(Styles.buttonStyle)
        
        // MARK: - Content
//        phoneNumberField.attributedPlaceholder = NSAttributedString(string: " Enter your phone number",
//                                                                    attributes: [.foregroundColor: UIColor.white])
        okButton.setTitle("Validate my phone number", for: .normal)
    }
}

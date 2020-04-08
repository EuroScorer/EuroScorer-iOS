//
//  HomeView.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 08/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia
import KeyboardLayoutGuide

class HomeView: UIView {
    
    var blurredEffectView: UIVisualEffectView!
    let okButton = UIButton()
    let phoneNumberField = UITextField()
    
    convenience init() {
        self.init(frame: .zero)
        
        let backgroundImage = UIImageView()
        let blurrEffect = UIBlurEffect(style: .dark)
        blurredEffectView = UIVisualEffectView(effect: blurrEffect)
        let title = UILabel()
        
        
        
        subviews {
            backgroundImage
            blurredEffectView!
            okButton
        }
        
        backgroundImage.fillContainer()
        blurredEffectView.fillContainer()

        |-20-okButton-20-| ~ 50
            
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurrEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)

        vibrancyView.contentView.subviews {
            title
            phoneNumberField
        }
        blurredEffectView.contentView.subviews { vibrancyView }
        
        layout {
            100
            |-20-title-20-|
            100
            |-20-phoneNumberField-20-| ~ 60
        }
        vibrancyView.fillContainer()
        
        okButton.Bottom == keyboardLayoutGuide.Top - 20
        
        backgroundColor = UIColor(red: 10/255.0, green: 18/255.0, blue: 96/255.0, alpha: 1)
        backgroundImage.image = #imageLiteral(resourceName: "background")
        backgroundImage.contentMode = .scaleAspectFill
        title.style { l in
            l.textColor = UIColor.white//withAlphaComponent(0.6)
            l.font = UIFont.systemFont(ofSize: 50, weight: .black)
            l.numberOfLines = 0
            l.textAlignment = .center
        }
        phoneNumberField.style { f in
            f.font = UIFont.systemFont(ofSize: 30, weight: .light)
            f.textColor = .white
            f.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            f.layer.cornerRadius = 10
            f.keyboardType = .phonePad
            f.layer.borderColor = UIColor.white.cgColor
            f.layer.borderWidth = 1
        }
        okButton.style { b in
            b.backgroundColor = .systemRed//UIColor(red: 160/255.0, green: 21/255.0, blue: 21/255.0, alpha: 1)
            b.layer.cornerRadius = 5
        }
    
        title.text = "Euro 2020 voting app"
        let attrStr = NSAttributedString(string: " Enter your phone number", attributes: [.foregroundColor: UIColor.white])
        phoneNumberField.attributedPlaceholder = attrStr
        okButton.setTitle("OK", for: .normal)
    }
}

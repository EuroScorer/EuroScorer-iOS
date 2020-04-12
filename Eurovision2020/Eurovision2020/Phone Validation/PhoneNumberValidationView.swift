//
//  PhoneNumberValidationView.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 08/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia
import KeyboardLayoutGuide
import PhoneNumberKit

class PhoneNumberValidationView: UIView {
    
    var blurredEffectView: UIVisualEffectView!
    let okButton = UIButton()
    let phoneNumberBackground = UIView()
    let phoneNumberField = PhoneNumberTextField()
    
    convenience init() {
        self.init(frame: .zero)
        
        let backgroundImage = UIImageView()
        let blurrEffect = UIBlurEffect(style: .dark)
        blurredEffectView = UIVisualEffectView(effect: blurrEffect)
        let title = UILabel()
        
        subviews {
            backgroundImage
            blurredEffectView!
            phoneNumberBackground.subviews {
                phoneNumberField
            }
            okButton
        }
        
        backgroundImage.fillContainer()
        blurredEffectView.fillContainer()

        |-20-okButton-20-| ~ 50
            
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurrEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)

        vibrancyView.contentView.subviews {
            title
        }
        blurredEffectView.contentView.subviews { vibrancyView }
        
        layout {
            100
            |-20-title-20-|
        }
        
        phoneNumberBackground.centerVertically(offset: -100)
        |-20-phoneNumberBackground-20-| ~ 60
        
        layout {
            0
            |-20-phoneNumberField-20-|
            0
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
            l.isHidden = true
        }
        phoneNumberBackground.style { v in
            v.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            v.layer.cornerRadius = 10
        }
        phoneNumberField.style { f in
            f.font = UIFont.systemFont(ofSize: 30, weight: .light)
            f.textColor = .white
//            f.keyboardType = .phonePad
        }
        okButton.style { b in
            b.setBackgroundColor(.systemRed, for: .normal)//UIColor(red: 160/255.0, green: 21/255.0, blue: 21/255.0, alpha: 1)
            b.layer.cornerRadius = 5
            b.clipsToBounds = true
        }
    
        title.text = "Euro 2020 voting app"
        let attrStr = NSAttributedString(string: " Enter your phone number", attributes: [.foregroundColor: UIColor.white])
        phoneNumberField.attributedPlaceholder = attrStr
        okButton.setTitle("Validate my phone number", for: .normal)
        
        phoneNumberField.withFlag = true
        phoneNumberField.withPrefix = true
        phoneNumberField.withExamplePlaceholder = true
        phoneNumberField.withDefaultPickerUI = true
    }
}


extension UIButton {

    public func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let img = UIImage(color: color, size: CGSize(width: 1.0, height: 1.0))
        setBackgroundImage(img, for: state)
    }
}

extension UIImage {
    public convenience init(color: UIColor, size: CGSize) {
        
        var rect = CGRect.zero
        rect.size = size
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        color.setFill()
        UIRectFill(rect)
        
        let uiImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let cgImage = uiImage?.cgImage {
            self.init(cgImage: cgImage)
        } else {
            self.init()
        }
    }
}

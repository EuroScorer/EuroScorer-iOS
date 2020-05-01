//
//  BlurredBackgroundView.swift
//  EuroScorer
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia

class BlurredBackgroundView: UIView {
    
    convenience init() {
        self.init(frame: .zero)
        
        let backgroundImage = UIImageView()
        let blurrEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurrEffect)
        
        subviews {
            backgroundImage
            blurredEffectView
        }
        
        backgroundImage.fillContainer()
        blurredEffectView.fillContainer()
        
        backgroundImage.clipsToBounds = true
        backgroundImage.image = #imageLiteral(resourceName: "background")
        backgroundImage.contentMode = .scaleAspectFill
        blurredEffectView.backgroundColor = UIColor(red: 10/255.0, green: 16/255.0, blue: 72/255.0, alpha: 1).withAlphaComponent(0.7)
    }
}

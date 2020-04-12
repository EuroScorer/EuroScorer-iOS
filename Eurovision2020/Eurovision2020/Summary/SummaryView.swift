//
//  SummaryView.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 09/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia

class SummaryView: UIView {
    
    convenience init() {
        self.init(frame: .zero)
        
        let backgroundImage = UIImageView()
        let blurrEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurrEffect)
    
        
        let title = UILabel()
        
        subviews {
            backgroundImage
            blurredEffectView
            title
        }
        
        backgroundImage.fillContainer()
        blurredEffectView.fillContainer()
        
        title.centerHorizontally().top(80)
        
        
        backgroundImage.image = #imageLiteral(resourceName: "background")
        backgroundImage.contentMode = .scaleAspectFill
        title.style { l in
            l.textColor = .white
            l.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        }
        
        title.text = "Vote Summary"
    }
}

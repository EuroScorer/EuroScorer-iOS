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
        
        let background = BlurredBackgroundView()
        
        
        subviews {
            background
        }
        
        background.fillContainer()

    }
}


struct Vote {
    let user: User
}

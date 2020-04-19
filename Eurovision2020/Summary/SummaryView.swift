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
    
    private let background = BlurredBackgroundView()
    let button = UIButton()
    
    convenience init() {
        self.init(frame: .zero)

        subviews {
            background
            button
        }
        
        background.fillContainer()
        
        button.centerHorizontally().height(50)
        button.Bottom == safeAreaLayoutGuide.Bottom - 20
        
        
        button.style(Styles.buttonStyle)
        
        button.setTitle("Send votes", for: .normal)
    }
}

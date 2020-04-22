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
    let phoneNumber = UILabel()
    let country = UILabel()
    let votesScrollView = UIScrollView()
    let votesStackView = UIStackView()
    let button = UIButton()
    
    convenience init() {
        self.init(frame: .zero)

        subviews {
            background
            phoneNumber
            country
            votesScrollView.subviews {
                votesStackView
            }
            button
        }
        
        background.fillContainer()
        phoneNumber.Top == safeAreaLayoutGuide.Top + 20
        layout {
            |-20-phoneNumber-20-|
            20
            |-20-country-20-|
            20
            |votesScrollView|
            0
            |-20-button-20-| ~ 50
        }
    
        button.Bottom == safeAreaLayoutGuide.Bottom - 20
        votesStackView.axis = .vertical
        votesStackView.Width == Width
        votesStackView.fillContainer()
        
        let textStyle = { (l: UILabel) in
            l.textColor = .white
            l.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        }
        phoneNumber.style(textStyle)
        country.style(textStyle)
        button.style(Styles.buttonStyle)
        
        button.setTitle("Send votes", for: .normal)
    }
}

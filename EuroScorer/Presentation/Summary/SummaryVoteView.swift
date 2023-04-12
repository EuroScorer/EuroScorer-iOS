//
//  SummaryVoteView.swift
//  EuroScorer
//
//  Created by Sacha DSO on 23/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia

class SummaryVoteView: UIView {

    let country = UILabel()
    let votes = UILabel()
    let separator = UIView()
    
    convenience init() {
        self.init(frame: .zero)
        
        // MARK: - View Hierarchy
        subviews {
            country
            votes
            separator
        }
        
        // MARK: - Layout
        layout {
            10
            |-20-country-(>=20)-votes-20-|
            2
            |-20-separator-20-| ~ 1
            10
        }
        
        // MARK: - Style
        let textStyle = { (l: UILabel) in
            l.textColor = .white
            l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
        country.style(textStyle)
        votes.style(textStyle)
        separator.backgroundColor = .white
    }
}

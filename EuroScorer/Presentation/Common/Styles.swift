//
//  Styles.swift
//  EuroScorer
//
//  Created by Sacha DSO on 19/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit

struct Styles {
    
    @MainActor static func buttonStyle(b: UIButton) {
        let blue = UIColor(red: 10/255.0, green: 16/255.0, blue: 72/255.0, alpha: 1)
        b.setBackgroundColor(blue, for: .normal)
        b.layer.cornerRadius = 5
        b.clipsToBounds = true
//        b.layer.borderColor = UIColor.white.cgColor
//        b.layer.borderWidth = 0.5
        b.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        b.setTitleColor(.white, for: .normal)
        b.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        b.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
    }
}


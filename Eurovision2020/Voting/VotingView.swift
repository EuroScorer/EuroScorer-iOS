//
//  VotingView.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 09/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia

class VotingView: UIView {
    
    let refreshControl = UIRefreshControl()
    let tableView = UITableView()
    let votesLeft = UILabel()
    let votesGiven = UILabel()
    let confirm = UIButton()
    
    convenience init() {
        self.init(frame: .zero)
        backgroundColor = .blue
        
        let blurredbackground = BlurredBackgroundView()
        let recapContainer = UIView()
        let votesTitle = UILabel()
        
        
        let hairline = UIView()
        
        subviews {
            blurredbackground
            tableView
            recapContainer.subviews {
                hairline
                votesTitle
                votesLeft
                votesGiven
                confirm
            }
        }
        tableView.addSubview(refreshControl)
        
        blurredbackground.fillContainer()

    
        layout {
            0
            |tableView|
            |recapContainer|
        }
        
        recapContainer.Bottom == safeAreaLayoutGuide.Bottom
        
        layout {
            0
            |hairline| ~ 0.5
        }
        
        
        layout {
            20
            |-20⁃votesLeft⁃confirm⁃votesGiven⁃20-|
            20
        }
        
        confirm.centerHorizontally().height(50)
        confirm.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        
        refreshControl.tintColor = .white
        tableView.backgroundColor = .clear
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.2)
        tableView.allowsSelection = false
        recapContainer.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        hairline.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        votesTitle.textColor = .white
        votesTitle.text = "Spread your votes".uppercased()
        votesTitle.textAlignment = .center
        votesTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        votesTitle.isHidden = true
        
        let textStyle = { (l: UILabel) in
            l.font = .systemFont(ofSize: 20, weight: .semibold)
            l.textColor = .white
            l.numberOfLines = 0
            l.textAlignment = .center
        }
        votesLeft.style(textStyle)
        votesGiven.style(textStyle)
        confirm.style(Styles.buttonStyle)

        confirm.setTitle("Confirm my votes", for: .normal)
    }
}

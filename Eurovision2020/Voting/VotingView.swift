//
//  VotingView.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 09/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia
import YouTubeiOSPlayerHelper

class VotingView: UIView {
    
    let blurredbackground = BlurredBackgroundView()
    let refreshControl = UIRefreshControl()
    let tableView = UITableView()
    let recapContainer = UIView()
    let hairline = UIView()
    let votesLeft = UILabel()
    let votesGiven = UILabel()
    let confirm = UIButton()
    let playerView = WKYTPlayerView()
    var playerViewHeightConstraint: NSLayoutConstraint?
    
    convenience init() {
        self.init(frame: .zero)
        
        // MARK: - View Hierarchy
        subviews {
            blurredbackground
            tableView
            playerView
            recapContainer.subviews {
                hairline
                votesLeft
                votesGiven
                confirm
            }
        }
        tableView.addSubview(refreshControl)
        
        // MARK: - Layout
        blurredbackground.fillContainer()
        playerView.Top == safeAreaLayoutGuide.Top
        layout {
            |playerView|
            0
            |tableView|
            |recapContainer|
            0
        }
        
        hairline.top(0).height(0.5).fillHorizontally()
        layout {
            20
            |-20⁃votesLeft⁃confirm.centerHorizontally().height(50)⁃votesGiven⁃20-|
        }
        
        votesLeft.Bottom == safeAreaLayoutGuide.Bottom - 0
        
        confirm.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        
        
        
        playerViewHeightConstraint = playerView.Height == 0
    
        
        playerView.layer.shadowColor = UIColor.black.cgColor
        playerView.layer.shadowOpacity = 1
        playerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
    
        
        // MARK: - Style
        refreshControl.tintColor = .white
        tableView.style { tbv in
            tbv.backgroundColor = .clear
            tbv.separatorColor = UIColor.white.withAlphaComponent(0.2)
            tbv.allowsSelection = false
            tbv.register(VotingCell.self, forCellReuseIdentifier: "VotingCell")
            tbv.estimatedRowHeight = 100
        }
        recapContainer.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        hairline.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        let textStyle = { (l: UILabel) in
            l.font = .systemFont(ofSize: 18, weight: .semibold)
            l.textColor = .white
            l.numberOfLines = 0
            l.textAlignment = .center
        }
        votesLeft.style(textStyle)
        votesGiven.style(textStyle)
        confirm.style(Styles.buttonStyle)

        // MARK: - Content
        confirm.setTitle("Confirm my votes", for: .normal)
        

    }
}

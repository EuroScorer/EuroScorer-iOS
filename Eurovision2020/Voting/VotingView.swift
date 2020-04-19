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
    
    let blurredbackground = BlurredBackgroundView()
    let refreshControl = UIRefreshControl()
    let tableView = UITableView()
    let recapContainer = UIView()
    let hairline = UIView()
    let votesLeft = UILabel()
    let votesGiven = UILabel()
    let confirm = UIButton()
    
    convenience init() {
        self.init(frame: .zero)
        
        // MARK: - View Hierarchy
        subviews {
            blurredbackground
            tableView
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
        layout {
            0
            |tableView|
            |recapContainer|
        }
        recapContainer.Bottom == safeAreaLayoutGuide.Bottom
        hairline.top(0).height(0.5).fillHorizontally()
        layout {
            20
            |-20⁃votesLeft⁃confirm.centerHorizontally().height(50)⁃votesGiven⁃20-|
            20
        }
        confirm.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        
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
            l.font = .systemFont(ofSize: 20, weight: .semibold)
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

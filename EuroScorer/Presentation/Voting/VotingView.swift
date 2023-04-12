//
//  VotingView.swift
//  EuroScorer
//
//  Created by Sacha DSO on 09/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia
import YoutubePlayer

class VotingView: UIView {
    
    let blurredbackground = BlurredBackgroundView()
    let refreshControl = UIRefreshControl()
    let tableView = UITableView()
    let recapContainer = UIView()
    let hairline = UIView()
    let votesLeft = UILabel()
    let votesGiven = UILabel()
    let confirm = UIButton()
    let playerView = YTPlayerView()
    var playerViewHeightConstraint: NSLayoutConstraint?
    let playerCloseButton = UIButton()
    
    convenience init() {
        self.init(frame: .zero)
        
        // MARK: - View Hierarchy
        subviews {
            blurredbackground
            tableView
            playerView
            playerCloseButton
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
        
        
        let bottomMargin: Double = (UIApplication.shared.windows[0].safeAreaInsets.bottom > 0) ? 0 : 20
        votesLeft.Bottom == safeAreaLayoutGuide.Bottom - bottomMargin
        confirm.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        playerViewHeightConstraint = playerView.Height == 0
        
        playerCloseButton.size(44)|
        playerCloseButton.Top == playerView.Bottom
    
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
        playerView.layer.shadowColor = UIColor.black.cgColor
        playerView.layer.shadowOpacity = 1
        playerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        // Close button
        let conf = UIImage.SymbolConfiguration(pointSize: 30)
        let closeImg = UIImage(systemName: "xmark.circle.fill", withConfiguration: conf)
        playerCloseButton.setImage(closeImg, for: .normal)
        playerCloseButton.tintColor = .white
        playerCloseButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        playerCloseButton.layer.shadowColor = UIColor.black.cgColor
        playerCloseButton.layer.shadowOpacity = 1
        playerCloseButton.layer.shadowOffset = CGSize(width: 0, height: 1)

        // MARK: - Content
        confirm.setTitle("See summary", for: .normal)
        
        

        
        playerCloseButton.isHidden = true

    }
}

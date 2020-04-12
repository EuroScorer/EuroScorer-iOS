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
    
    convenience init() {
        self.init(frame: .zero)
        backgroundColor = .blue
        
        let backgroundImage = UIImageView()
        let blurrEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurrEffect)
        let recapContainer = UIView()
        

        let votesTitle = UILabel()
        
        let confirm = UIButton()
        
        subviews {
            backgroundImage
            blurredEffectView
            tableView
            recapContainer.subviews {
                votesTitle
                votesLeft
                votesGiven
                confirm
            }
        }
        tableView.addSubview(refreshControl)
        
        backgroundImage.fillContainer()
        blurredEffectView.fillContainer()
    
        layout {
            0
            |tableView|
            |recapContainer|
            0
        }
        
        layout {
//            2
//            |-20-votesTitle-20-|
            40
            |-20⁃votesLeft⁃confirm⁃votesGiven⁃20-|
            40
        }
        
        confirm.centerHorizontally().height(50)
        confirm.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        
        
        backgroundImage.clipsToBounds = true
        backgroundImage.image = #imageLiteral(resourceName: "background")
        backgroundImage.contentMode = .scaleAspectFill
        refreshControl.tintColor = .white
        tableView.backgroundColor = .clear
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.2)
        tableView.allowsSelection = false
        recapContainer.backgroundColor = UIColor.black
        
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
        
        confirm.setBackgroundColor(.systemRed, for: .normal)
        confirm.layer.cornerRadius = 5
        confirm.clipsToBounds = true
        confirm.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        confirm.setTitle("Confirm my votes", for: .normal)
    }
}

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
            20
            |-20-votesTitle-20-|
            20
            |-20⁃votesLeft⁃(>=8)⁃confirm⁃(>=8)⁃votesGiven⁃20-|
            40
        }
        
        confirm.centerHorizontally().height(50)
        
        
        backgroundImage.clipsToBounds = true
        backgroundImage.image = #imageLiteral(resourceName: "background")
        backgroundImage.contentMode = .scaleAspectFill
        tableView.backgroundColor = .clear
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.2)
        tableView.allowsSelection = false
        recapContainer.backgroundColor = UIColor.black
        
        votesTitle.textColor = .white
        votesTitle.text = "Spread your votes".uppercased()
        votesTitle.textAlignment = .center
        votesTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        votesLeft.style { l in
            l.textColor = .white
            l.numberOfLines = 0
            l.textAlignment = .center
        }
        votesGiven.style { l in
            l.textColor = .white
            l.numberOfLines = 0
            l.textAlignment = .center
        }
        confirm.setBackgroundColor(.systemRed, for: .normal)
        confirm.layer.cornerRadius = 5
        confirm.clipsToBounds = true
        confirm.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        confirm.setTitle("Confirm my votes", for: .normal)
    }
}

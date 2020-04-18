//
//  VotingCell.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 09/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia

protocol VotingCellDelegate: class {
    func votingCellDidAddVote(cell: VotingCell)
    func votingCellDidRemoveVote(cell: VotingCell)
    func votingCellDidTapPlay(cell: VotingCell)
}

class VotingCell: UITableViewCell {
    
    weak var delegate: VotingCellDelegate?
    let number = UILabel()
    let country = UILabel()
    let flag = UIImageView()
    let title = UILabel()
    let minusButton = UIButton()
    let plusButton = UIButton()
    let playButton = UIButton()
    let votes = UILabel()
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        subviews {
            number
            country
            flag
            title
            minusButton
            plusButton
            playButton
            votes
        }
        
        layout {
            20
            |-20-number.width(38)
        }
        
        number-20-flag-country
        
        flag.CenterY == country.CenterY
                
        layout {
            20
            country
            8
            title-20-|
            8
            minusButton⁃plusButton⁃40-playButton
            20
        }
        
//        alignHorizontally(minusButton, with: plusButton)
        
        layout {
            votes-20-|
            20
        }
        
        title.Left == flag.Left
        
        minusButton.Left == flag.Left
        
        
        
        backgroundColor = .clear
        number.style { l in
            l.textColor = .white
            l.font = UIFont.monospacedSystemFont(ofSize: 18, weight: .bold)
            l.textAlignment = .center
        }
        country.style { l in
            l.textColor = .white
            l.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        }
        title.style { l in
            l.textColor = .white
            l.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            title.numberOfLines = 0
        }
        votes.style { l in
            l.textColor = .white
            l.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        
        let buttonStyle = { (b: UIButton) in
            b.setBackgroundColor(UIColor.white.withAlphaComponent(0.2), for: .normal)
            b.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            b.layer.cornerRadius = 6
            b.clipsToBounds = true
            b.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .bold)
        }
        minusButton.style(buttonStyle)
        plusButton.style(buttonStyle)
        playButton.style(buttonStyle)
        
        minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)

        minusButton.setTitle("-", for: .normal)
        plusButton.setTitle("+", for: .normal)
        playButton.setTitle("▶︎", for: .normal)
    }
    
    @objc
    func didTapMinus() {
        delegate?.votingCellDidRemoveVote(cell: self)
    }
    
    @objc
    func didTapPlus() {
        delegate?.votingCellDidAddVote(cell: self)
    }
    
    @objc
    func didTapPlay() {
        delegate?.votingCellDidTapPlay(cell: self)
    }
}

//
//  VotingCell.swift
//  EuroScorer
//
//  Created by Sacha DSO on 09/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia

protocol VotingCellDelegate: AnyObject {
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
        
        // MARK: - View Hieararchy
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
        
        // MARK: - Layout
        number.width(38)
        layout {
            20
            |-20-number-20-flag-country
        }
        layout {
            20
            country-(>=8)-votes-20-|
            8
            title-20-|
            8
            minusButton-plusButton-(>=20)-playButton-20-| ~ 44
            20
        }
        align(lefts: flag, title, minusButton)
    
        // MARK: - Style
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
        playButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        // MARK: - Content
        let conf = UIImage.SymbolConfiguration(weight: UIImage.SymbolWeight.ultraLight)
        let img = UIImage(systemName: "play.rectangle.fill", withConfiguration: conf)
        playButton.setImage(img, for: .normal)
        playButton.tintColor = .white
        
        let imgMinus = UIImage(systemName: "minus")
        minusButton.setImage(imgMinus, for: .normal)
        minusButton.tintColor = .white
        
        let imgPlus = UIImage(systemName: "plus")
        plusButton.setImage(imgPlus, for: .normal)
        plusButton.tintColor = .white
        
        // MARK: - Events
        minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
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

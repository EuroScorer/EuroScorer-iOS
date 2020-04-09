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
}

class VotingCell: UITableViewCell {
    
    weak var delegate: VotingCellDelegate?
    let rank = UILabel()
    let country = UILabel()
    let title = UILabel()
    let stepper = UIStepper()
    let votes = UILabel()
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        subviews {
            rank
            country
            title
            stepper
            votes
        }
        
        layout {
            20
            |-20-rank.width(36)
        }
        
        rank-20-country
                
        layout {
            20
            country
            8
            title
            8
            stepper
            20
        }
        
        layout {
            votes-20-|
            20
        }
        
        title.Left == country.Left
        stepper.Left == country.Left
        
        rank.style { l in
            l.textColor = .white
            l.font = UIFont.systemFont(ofSize: 18, weight: .black)
            l.textAlignment = .center
        }
        country.style { l in
            l.textColor = .white
            l.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        }
        title.style { l in
            l.textColor = .white
            l.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        votes.style { l in
            l.textColor = .white
            l.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
        
        votes.text = "16 votes"
        
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
    }
    
    @objc
    func stepperValueChanged() {
        delegate?.votingCellDidAddVote(cell: self)
    }
}

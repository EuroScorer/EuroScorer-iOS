//
//  SummaryVC.swift
//  EuroScorer
//
//  Created by Sacha DSO on 09/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia
import Combine

class SummaryVC: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    var v = SummaryView()
    override func loadView() {
        view = v
    }
    
    let votes: [String]
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(votes: [String]) {
        self.votes = votes
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        title = "Vote Summary"
        
        v.phoneNumber.text = User.currentUser?.phoneNumber
        let countryName = Locale.current.localizedString(forRegionCode: User.currentUser!.countryCode)
        v.country.text =  "From \(countryName!)"
        
        v.button.addTarget(self, action: #selector(sendVotesTapped), for: .touchUpInside)
        
        
        let uniqueCountries = Set(votes).sorted()
        print(uniqueCountries)
        uniqueCountries.forEach { c in
            let count = votes.filter { c == $0 }.count
            let summaryVoteView = SummaryVoteView()
            summaryVoteView.country.text = Locale.current.localizedString(forRegionCode: c)?.uppercased()
            summaryVoteView.votes.text = "\(count)"
            v.votesStackView.addArrangedSubview(summaryVoteView)
        }
    }
    
    @objc
    func sendVotesTapped() {
        v.button.isLoading = true
        User.currentUser?.sendVotes(votes).then { [unowned self] in
            let alert = UIAlertController(title: "Thank you ❤️", message:
                "You votes have been succesfully sent ! \nYou can update them until the final date.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }.onError { error in
            print(error)
        }.finally { [unowned self] in
            self.v.button.isLoading = false
        }
        .sinkAndStore(in: &cancellables)
    }
}




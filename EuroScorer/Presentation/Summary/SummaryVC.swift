//
//  SummaryVC.swift
//  EuroScorer
//
//  Created by Sacha DSO on 09/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia

class SummaryVC: UIViewController {
    
    var v = SummaryView()
    override func loadView() {
        view = v
    }
    
    let votes: [String]
    private let userService: UserService
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(userService: UserService, votes: [String]) {
        self.userService = userService
        self.votes = votes
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        title = "Vote Summary"
        
        Task {
            let phoneNumber = try await userService.getCurrentUser()?.phoneNumber
            await MainActor.run {
                v.phoneNumber.text = phoneNumber
            }
        }
        Task {
            let countryCode = try await userService.getCurrentUser()!.countryCode
            await MainActor.run {
                let countryName = Locale.current.localizedString(forRegionCode: countryCode)
                v.country.text =  "From \(countryName!)"
            }
        }
        
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
        
        Task {
            _ = try await userService.fetchVotes()
            await MainActor.run {
                v.button.setTitle("Update my votes", for: .normal)
            }
        }
    }
    
    @objc
    func sendVotesTapped() {
        v.button.isLoading = true
        Task {
            do {
                try await userService.sendVotes(votes)
                await MainActor.run {
                    let alert = UIAlertController(title: "Thank you ❤️", message:
                                                    "You votes have been succesfully sent ! \nYou can update them until the final date.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } catch {
                print(error)
            }
            await MainActor.run {
                v.button.isLoading = false
            }
        }
    }
}




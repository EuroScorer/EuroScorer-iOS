//
//  SummaryVC.swift
//  Eurovision2020
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
        
//        on("INJECTION_BUNDLE_NOTIFICATION") { [weak self] in
//            self?.v = SummaryView()
//            self?.view = self?.v
//        }
        
        v.button.addTarget(self, action: #selector(sendVotesTapped), for: .touchUpInside)
    }
    
    @objc
    func sendVotesTapped() {
        Vote.sendVotes(votes).then { [unowned self] in
            let alert = UIAlertController(title: "Thank you ❤️", message:
                "You votes have been succesfully sent ! \nYou can update them until the final date.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }.onError { error in
            print(error)
        }.sinkAndStore(in: &cancellables)
    }
    
}

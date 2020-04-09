//
//  VotingVC.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 09/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia

class Song {
    let country: String
    let title: String
    var numberOfVotesGiven: Int = 0
    
    init(country: String, title: String) {
        self.country = country
        self.title = title
    }
    
    func addVote() {
        numberOfVotesGiven = numberOfVotesGiven + 1
    }
}

class VotingVC: UIViewController {
    
    let maxVotes = 20
    var availableVotes = 0
    
    var v = VotingView()
    override func loadView() {
        view = v
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        availableVotes = maxVotes
    
        self.render()
        on("INJECTION_BUNDLE_NOTIFICATION") {
            self.v = VotingView()
            self.view = self.v
            self.render()
        }
    }
    
    func render() {
        v.tableView.dataSource = self
        refreshVotes()
    }
    
    func refreshVotes() {
        v.votesLeft.text = "\(availableVotes) Votes\nLeft"
        v.votesGiven.text = "\(maxVotes - availableVotes) Votes\nGiven"
    }
}

extension VotingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = songs[indexPath.row]
        let cell = VotingCell()
        cell.backgroundColor = .clear
        cell.rank.text = "#\(indexPath.row)"
        cell.country.text = song.country
        cell.title.text = song.title
        cell.votes.text = "\(song.numberOfVotesGiven) votes"
//        cell.detailTextLabel?.text = song.country
        
        cell.delegate = self
        return cell
    }
}

extension VotingVC: VotingCellDelegate {
    func votingCellDidRemoveVote(cell: VotingCell) {
        
    }
    
    
    func votingCellDidAddVote(cell: VotingCell) {
        if let indexPath = v.tableView.indexPath(for: cell) {
            let song = songs[indexPath.row]
            
            if availableVotes > 0 {
                song.addVote()
                availableVotes = availableVotes - 1
            }
            refreshVotes()
            
            v.tableView.reloadData()
        }
        
    }
}

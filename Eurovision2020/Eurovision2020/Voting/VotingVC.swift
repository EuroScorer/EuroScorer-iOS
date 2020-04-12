//
//  VotingVC.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 09/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import UIKit
import Stevia
import FlagKit

import Combine

class VotingVC: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    var songs = [Song]()
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
        
        
        refresh()
        v.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc
    func refresh() {
        Song.fetchSongs().then { [unowned self] fetchedSongs in
            self.songs = fetchedSongs.sorted { $0.number < $1.number }
            self.v.tableView.reloadData()
        }.finally { [unowned self] in
            self.v.refreshControl.endRefreshing()
        }.sinkAndStore(in: &cancellables)
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
        cell.rank.text = "#\(song.number)"
        cell.country.text = song.country?.name
        
        
//        let countryCode = Locale.current.regionCode!
        let flag = Flag(countryCode: song.country?.code ?? "GB")!
        cell.flag.image = flag.image(style: .roundedRect)
        
            

    //        // Retrieve the unstyled image for customized use
    //        let originalImage = flag.originalImage
    //
    //        // Or retrieve a styled flag
    //        let styledImage = flag.image(style: .circle)
    //        You can always access the underlying assets directly, through the bundled Asset Catalog:
    //

        cell.title.text = song.title
        cell.votes.text = "\(song.numberOfVotesGiven) votes"
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

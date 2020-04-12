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
    
    var user: User! = nil
    
    convenience init(user: User) {
        self.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
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
        navigationItem.largeTitleDisplayMode = .never
        title = "Spread your votes!"
        availableVotes = maxVotes
    
        self.render()
        on("INJECTION_BUNDLE_NOTIFICATION") {
            self.v = VotingView()
            self.view = self.v
            self.render()
        }
        
        
        refresh()
        v.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        v.confirm.addTarget(self, action:#selector(confirmTapped), for: .touchUpInside)
        v.tableView.register(VotingCell.self, forCellReuseIdentifier: "VotingCell")
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
        v.votesLeft.text = "\(availableVotes)\nLeft"
        v.votesGiven.text = "\(maxVotes - availableVotes)\nGiven"
    }
    
    @objc
    func confirmTapped() {
        navigationController?.pushViewController(SummaryVC(), animated: true)
    }
}

extension VotingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = songs[indexPath.row]
        let isMyCountry = song.country?.code == user.countryCode
        let cell = tableView.dequeueReusableCell(withIdentifier: "VotingCell", for: indexPath) as! VotingCell
        cell.number.text = (song.number < 10) ? "0\(song.number)" : "\(song.number)"
        let flag = Flag(countryCode: song.country?.code ?? "GB")!
        cell.flag.image = flag.image(style: .roundedRect)
        cell.title.text = song.title
        cell.votes.text = "\(song.numberOfVotesGiven) votes"
        cell.minusButton.isEnabled = !isMyCountry
        cell.minusButton.isHidden = isMyCountry
        cell.plusButton.isEnabled = !isMyCountry
        cell.plusButton.isHidden = isMyCountry
        cell.votes.isHidden = isMyCountry
        cell.country.text = isMyCountry ? "\(song.country?.name ?? "") (Your country)" : song.country?.name
        cell.backgroundColor = isMyCountry ? UIColor.black.withAlphaComponent(0.5) : .clear
        cell.delegate = self
        return cell
    }
}

extension VotingVC: VotingCellDelegate {
    
    func votingCellDidRemoveVote(cell: VotingCell) {
        if let indexPath = v.tableView.indexPath(for: cell) {
            let song = songs[indexPath.row]
            if availableVotes < maxVotes {
                song.removeVote()
                availableVotes = availableVotes + 1
            }
            refreshVotes()
            v.tableView.reloadData()
        }
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

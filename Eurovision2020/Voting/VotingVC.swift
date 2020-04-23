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
import YouTubeiOSPlayerHelper

class VotingVC: UIViewController {
    
    var votes = [String]()
    var cancellables = Set<AnyCancellable>()
    var songs = [Song]()
    let maxVotes = 20
    var isloggedIn: Bool { User.currentUser != nil }
    
    let v = VotingView()
    override func loadView() { view = v }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = "Spread your votes!"
        v.refreshControl.addTarget(self, action: #selector(refreshSongs), for: .valueChanged)
        v.confirm.addTarget(self, action:#selector(confirmTapped), for: .touchUpInside)
        v.tableView.dataSource = self
        v.playerView.delegate = self
        refreshSongs()
        refreshVotes()
        refreshLogoutButton()
    }
    
    func refreshLogoutButton() {
        if User.currentUser == nil {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutTapped))
            navigationItem.rightBarButtonItem?.tintColor = .white
        }
    }
    
    @objc
    func logoutTapped() {
        User.currentUser?.logout()
        votes.removeAll()
        refreshVotes()
        refreshLogoutButton()
        v.tableView.reloadData()
    }
        
    @objc
    func refreshSongs() {
        Song.fetchSongs().then { [unowned self] fetchedSongs in
            self.songs = fetchedSongs
            self.v.tableView.reloadData()
        }.finally { [unowned self] in
            self.v.refreshControl.endRefreshing()
        }.sinkAndStore(in: &cancellables)
    }

    func refreshVotes() {
        v.votesLeft.text = "\(availableVotes())\nLeft"
        v.votesGiven.text = "\(votesGiven())\nGiven"
    }
    
    @objc
    func confirmTapped() {
        if !isloggedIn {
            showLogin()
            return
        }
        navigationController?.pushViewController(SummaryVC(votes: votes), animated: true)
    }
    
    func showLogin() {
        let alert = UIAlertController(title: "Voting", message:
            "You need to verify your phone number before voting 😎", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Let's do this!", style: .default, handler: { a in
            let vc = PhoneNumberValidationVC()
            vc.didLogin = {
                self.refreshLogoutButton()
                self.v.tableView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
            self.present(vc, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Not now", style: .cancel, handler: { a in
            print("not now")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension VotingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = songs[indexPath.row]
        let isMyCountry = song.country?.code == User.currentUser?.countryCode
        let cell = tableView.dequeueReusableCell(withIdentifier: "VotingCell", for: indexPath) as! VotingCell
        cell.number.text = (song.number < 10) ? "0\(song.number)" : "\(song.number)"
        let flag = Flag(countryCode: song.country?.code ?? "GB")!
        cell.flag.image = flag.image(style: .roundedRect)
        cell.title.text = song.title
        cell.votes.text = "\(numberOfVotesFor(song: song)) votes"
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

// MARK: - Votes

extension VotingVC {
    
    func numberOfVotesFor(song: Song) -> Int {
        votes.filter { $0 == song.country?.code }.count
    }
    
    func addVoteFor(song: Song) {
        votes.append(song.country!.code)
    }
    
    func canVote() -> Bool {
        votes.count < maxVotes
    }
    
    func availableVotes() -> Int {
        maxVotes - votes.count
    }
    
    func votesGiven() -> Int {
        votes.count
    }
}

// MARK: - VotingCellDelegate

extension VotingVC: VotingCellDelegate {
    
    func votingCellDidTapPlay(cell: VotingCell) {
        if let indexPath = v.tableView.indexPath(for: cell) {
            let song = songs[indexPath.row]
            if let url = URL(string: song.link) {
                v.playerView.load(withVideoId: url.lastPathComponent, playerVars: ["playsinline": NSNumber(value: 1)])
            }
        }
    }
    
    func votingCellDidRemoveVote(cell: VotingCell) {
        
        if !isloggedIn {
            showLogin()
            return
        }
        
        guard let indexPath = v.tableView.indexPath(for: cell) else { return }
        let song = songs[indexPath.row]
        if let index = votes.firstIndex(of: song.country!.code) {
            votes.remove(at: index)
            cell.votes.text = "\(numberOfVotesFor(song: song)) votes"
            refreshVotes()
            playHapticsFeedback(style: .soft)
        }
    }
    
    func votingCellDidAddVote(cell: VotingCell) {
        
        if !isloggedIn {
            showLogin()
            return
        }
        
        guard let indexPath = v.tableView.indexPath(for: cell) else { return }
        let song = songs[indexPath.row]
        if canVote() {
            addVoteFor(song: song)
            cell.votes.text = "\(numberOfVotesFor(song: song)) votes"
            refreshVotes()
            playHapticsFeedback(style: .medium)
        }
    }
    
    func playHapticsFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

extension VotingVC: WKYTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        print(playerView)
        playerView.seek(toSeconds: 6, allowSeekAhead: true)

        v.playerViewHeightConstraint?.constant = v.playerView.frame.width * 0.56
        UIView.animate(withDuration: 0.3) {
            self.v.layoutIfNeeded()
        }
    }
    
    func playerViewPreferredInitialLoading(_ playerView: WKYTPlayerView) -> UIView? {
        let myView = UIView()
        myView.backgroundColor = .black
        return myView
    }
}

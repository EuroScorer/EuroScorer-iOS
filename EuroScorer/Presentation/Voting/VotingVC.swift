//
//  VotingVC.swift
//  EuroScorer
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
    var isloggedIn: Bool { userService.getCurrentUser() != nil }
    
    let v = VotingView()
    override func loadView() { view = v }
    
    private let songService: SongService
    private let userService: UserService
    
    required init(songService: SongService, userService: UserService) {
        self.songService = songService
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = "Spread your votes!"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Privacy", style: UIBarButtonItem.Style.plain, target: self, action: #selector(privacyTapped))
        navigationItem.leftBarButtonItem?.tintColor = .white
        v.refreshControl.addTarget(self, action: #selector(refreshSongs), for: .valueChanged)
        v.playerCloseButton.addTarget(self, action: #selector(closePlayerTapped), for: .touchUpInside)
        v.confirm.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        v.tableView.dataSource = self
        v.playerView.delegate = self
        refreshSongs()
        refreshVotes()
        refreshLogoutButton()
        tryFetchUserVotes()
    }
    
    func tryFetchUserVotes() {
        Task { @MainActor in
            votes = try await userService.fetchVotes()
            refreshVotes()
            v.tableView.reloadData()
        }
    }
    
    func refreshLogoutButton() {
        if userService.getCurrentUser() == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: UIBarButtonItem.Style.plain, target: self, action: #selector(loginTapped))
            navigationItem.rightBarButtonItem?.tintColor = .systemYellow
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutTapped))
            navigationItem.rightBarButtonItem?.tintColor = .systemRed
        }
    }
    
    @objc
    func privacyTapped() {
        let privacyPolicyVC = PrivacyPolicyVC()
        let navVC = NavVC(rootViewController: privacyPolicyVC)
        navVC.navigationBar.barStyle = .black
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
        privacyPolicyVC.v.button.isHidden = true
        privacyPolicyVC.v.button.height(0)
    }
    
    @objc
    func logoutTapped() {
        let alert = UIAlertController(title: "Log out",
                                      message: "Are you sure you want to log out ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yup", style: .destructive, handler: { a in
            self.userService.logout()
            self.votes.removeAll()
            self.refreshVotes()
            self.refreshLogoutButton()
            self.v.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { a in
            print("not now")
        }))
        self.present(alert, animated: true, completion: nil)
    }
        
    @objc
    func refreshSongs() {
        Task { @MainActor in
            do {
                let fetchedSongs = try await songService.fetchSongs()
                songs = fetchedSongs
                v.tableView.reloadData()
            } catch {
                
            }
            v.refreshControl.endRefreshing()
        }
        
//        Songs.fetchSongs().then { [unowned self] fetchedSongs in
//            self.songs = fetchedSongs
//            self.v.tableView.reloadData()
//        }.finally { [unowned self] in
//            self.v.refreshControl.endRefreshing()
//        }.sinkAndStore(in: &cancellables)
    }
    
    @objc
    func closePlayerTapped() {
        v.playerView.stopVideo()
        hidePlayer()
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
        navigationController?.pushViewController(SummaryVC(userService: userService, votes: votes), animated: true)
    }
    
    @objc
    func loginTapped() {
        showLoginView()
    }
    
    func showLogin() {
        let alert = UIAlertController(title: "Voting", message:
            "You need to verify your phone number before voting 😎", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Let's do this!", style: .default, handler: { a in
            self.showLoginView()
        }))
        
        alert.addAction(UIAlertAction(title: "Not now", style: .cancel, handler: { a in
            print("not now")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoginView() {
        let privacyPolicyVC = PrivacyPolicyVC()
        let navVC = NavVC(rootViewController: privacyPolicyVC)
        navVC.navigationBar.barStyle = .black
        navVC.modalPresentationStyle = .fullScreen
        privacyPolicyVC.didAccept = {
                    
            let phoneNumberValidationVC = PhoneNumberValidationVC(userService: self.userService)
            phoneNumberValidationVC.didLogin = {
                self.refreshLogoutButton()
                self.v.tableView.reloadData()
                self.tryFetchUserVotes()
                self.dismiss(animated: true, completion: nil)
            }
            navVC.pushViewController(phoneNumberValidationVC, animated: true)
        }
 
        self.present(navVC, animated: true, completion: nil)
    }
}

extension VotingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = songs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "VotingCell", for: indexPath) as! VotingCell
        render(cell: cell, with: song)
        cell.delegate = self
        return cell
    }
    
    func render(cell: VotingCell, with song: Song) {
        let isMyCountry = song.country?.code == userService.getCurrentUser()?.countryCode
        cell.number.text = (song.number < 10) ? "0\(song.number)" : "\(song.number)"
        let flag = Flag(countryCode: song.country?.code ?? "GB")!
        cell.flag.image = flag.image(style: .roundedRect)
        cell.title.text = song.title
        cell.votes.text = "\(numberOfVotesFor(song: song)) pts"
        cell.votes.textColor = numberOfVotesFor(song: song) > 0 ? .systemYellow : .clear
        cell.minusButton.isEnabled = !isMyCountry
        cell.minusButton.isHidden = isMyCountry
        cell.plusButton.isEnabled = !isMyCountry
        cell.plusButton.isHidden = isMyCountry
        cell.votes.isHidden = isMyCountry
        cell.country.text = isMyCountry ? "\(song.country?.name ?? "") (Your country)" : song.country?.name
        cell.backgroundColor = isMyCountry ? UIColor.black.withAlphaComponent(0.5) : .clear
    }
    
    func showPlayer() {
        v.playerCloseButton.isHidden = false
        v.playerViewHeightConstraint?.constant = v.playerView.frame.width * 0.56
        UIView.animate(withDuration: 0.3, animations: {
            self.v.layoutIfNeeded()
        }) { _ in
            self.v.playerView.isHidden = false
            self.v.playerCloseButton.isHidden = false
        }
    }
    
    func hidePlayer() {
        v.playerCloseButton.isHidden = true
        v.playerViewHeightConstraint?.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.v.layoutIfNeeded()
        }) { _ in
            self.v.playerView.isHidden = true
            self.v.playerCloseButton.isHidden = true
        }
           
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
                showPlayer()
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
            render(cell: cell, with: song)
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
            render(cell: cell, with: song)
            refreshVotes()
            playHapticsFeedback(style: .medium)
        }
    }
    
    func playHapticsFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

extension VotingVC: YTPlayerViewDelegate {
        
    func playerViewDidBecomeReady(playerView: YTPlayerView) {
        print(playerView)
        if !playerView.isHidden {
            playerView.seek(toSeconds: 6, allowSeekAhead: true)
        }
    }
    
    func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
        let myView = UIView()
        myView.backgroundColor = .black
        return myView
    }
    
    
    
    func playerView(playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .playing || state == .buffering  {
            if playerView.isHidden {
                playerView.stopVideo()
            }
        }
    }
}

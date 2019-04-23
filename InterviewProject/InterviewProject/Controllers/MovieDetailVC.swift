//
//  MovieDetailVC.swift
//  InterviewProject
//
//  Created by Nadeem Arain on 4/16/19.
//  Copyright © 2019 logics limited. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import SDWebImage
import AVKit

class MovieDetailVC: UITableViewController {

    //MARK: - Instance Variables
    
    var movieId: Int?
    var movieDetail: MovieDetailModel?
    var youtubeVideoId: String?
    var genres = String()

    //MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMovieDetailFromNetwork()
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.tableView.reloadData()
    }
    

    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if movieId != nil {
            return 1
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if movieDetail != nil {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
            cell.selectionStyle = .none
            
            let posterPath = movieDetail!.posterPath ?? ""
            let urlStr = AppConstants.IMAGES_BASE_URL + posterPath
            let url = URL(string: urlStr)
            
            cell.movieIV.sd_setImage(with: url, completed: nil)
            cell.movieTitle.text = movieDetail!.title!
            cell.watchBtn.addTarget(self, action: #selector(self.watch), for: .touchUpInside)

            cell.genresLabel.text = genres
            cell.dateLabel.text = movieDetail!.releaseDate
            cell.overviewLabel.text = movieDetail!.overview

            return cell
        }
        return UITableViewCell()
    }

    //MARK: - Helper Methods
    
    func loadMovieDetailFromNetwork() {
        
        if movieId != nil {
            
            if Reachability.isConnectedToNetwork() {
                SwiftLoader.show(animated: true)
                NetworkManager.shared.getVideos(movieId: movieId!) { (videoData) in
                    guard let data = videoData else {return}
                    self.youtubeVideoId = data.results.first?.key
                }
                NetworkManager.shared.getMovieDetail(movieId: movieId!) { (movieData) in
                    SwiftLoader.hide()
                    guard let data = movieData else {return}
                    self.movieDetail = data
                    for gen in data.genres ?? [] {
                        self.genres = gen.name! + ", "
                    }
                    self.tableView.reloadData()
                }
            }else {
                AppUtility.shared.displayAlert(title: "", messageText: "No network connection", delegate: self)
            }
        }
    }
    
    @objc func watch() {
        if Reachability.isConnectedToNetwork() {
            if youtubeVideoId != nil {
                
                // XCDYouTubeVideoPlayerViewController giving depreciated warning becuase of they used MPMoviePlayerViewController which is depreciated.
                
                let videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: youtubeVideoId)
                videoPlayerViewController.modalTransitionStyle = .crossDissolve
                self.present(videoPlayerViewController, animated: true, completion: nil)
            }
        }else {
            AppUtility.shared.displayAlert(title: "", messageText: "No network connection", delegate: self)
        }
    }
}

